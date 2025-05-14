defmodule ExJiraWeb.TaskLive.Index do
  use ExJiraWeb, :live_view

  alias ExJira.Auth.Permissions
  alias ExJira.Accounts.User
  alias ExJira.Tasks
  alias ExJira.Tasks.Task

  @impl true
  @spec mount(any(), map(), map()) :: {:ok, any()}
  def mount(_params, %{"access_control_id" => access_control_id} = session, socket) do
    current_user = socket.assigns.current_user

    %ExJira.Accounts.AccessControl{} =
      access_control =
      ExJira.Accounts.get_access_control_by(%{
        user_id: current_user.id,
        id: access_control_id,
        organisation_id: session["organisation_id"]
      })

    socket
    |> assign(:access_control, access_control)
    |> stream(:tasks, Tasks.list_tasks_for_organisation(access_control.organisation_id))
    |> ok()
  end

  @impl true
  def handle_params(params, _url, socket) do
    Process.send_after(self(), :clear_flash, 3000)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    %User{} = user = socket.assigns.current_user

    case Permissions.can?(socket.assigns.access_control, user, :update) do
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

    case Permissions.can?(socket.assigns.access_control, user, :create) do
      false ->
        socket
        |> put_flash(:error, "You are not authorized to create a task.")
        |> push_navigate(to: ~p"/tasks")

      true ->
        socket
        |> assign(:page_title, "New Task")
        |> assign(:task, %Task{organisation_id: socket.assigns.access_control.organisation_id})
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

  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    %User{} = user = socket.assigns.current_user

    case Permissions.can?(socket.assigns.access_control, user, :delete) do
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
