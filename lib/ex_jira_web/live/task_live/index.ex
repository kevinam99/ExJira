defmodule ExJiraWeb.TaskLive.Index do
  use ExJiraWeb, :live_view

  alias ExJira.Auth.Permissions
  alias ExJira.Accounts.User
  alias ExJira.Tasks
  alias ExJira.Tasks.Task

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    {:ok, stream(socket, :tasks, Tasks.list_tasks_for_organisation(user.organisation_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    %User{} = user = socket.assigns.current_user

    case Permissions.can?(user, :update) do
      false ->
        socket
        |> put_flash(:error, "You are not authorized to edit this task.")
        |> push_navigate(to: ~p"/tasks")

      true ->
        socket
        |> assign(:page_title, "Edit Task")
        |> assign(:task, Tasks.get_task!(id))
    end
  end

  defp apply_action(socket, :new, _params) do
    %User{} = user = socket.assigns.current_user

    case Permissions.can?(user, :create) do
      false ->
        socket
        |> put_flash(:error, "You are not authorized to create a task.")
        |> push_navigate(to: ~p"/tasks")

      true ->
        socket
        |> assign(:page_title, "New Task")
        |> assign(:task, %Task{})
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({ExJiraWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    %User{} = user = socket.assigns.current_user

    case Permissions.can?(user, :delete) do
      false ->
        socket
        |> put_flash(:error, "You are not authorized to delete this task.")

      true ->
        task = Tasks.get_task!(id)
        {:ok, _} = Tasks.delete_task(task)
        put_flash(socket, :info, "Task deleted successfully.")
        |> push_navigate(to: ~p"/tasks")
    end
    |> noreply()
  end
end
