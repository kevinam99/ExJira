defmodule ExJiraWeb.TaskLiveTest do
  use ExJiraWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExJira.TasksFixtures
  import ExJira.AccountsFixtures

  @create_attrs %{status: "some status", description: "some description", title: "some title"}
  @update_attrs %{
    status: "open",
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{status: nil, description: nil, title: nil}

  defp create_task(_) do
    organisation = ExJira.OrganisationsFixtures.organisation_fixture()
    task = task_fixture(%{organisation_id: organisation.id})
    %{task: task, organisation: organisation}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all tasks", %{conn: conn, task: task, organisation: organisation} do
      {:ok, _index_live, html} =
        conn |> log_in_user(user_fixture(%{organisation_id: organisation.id})) |> live(~p"/tasks")

      assert html =~ "Listing Tasks"
      assert html =~ task.status
    end

    test "saves new task", %{conn: conn, organisation: organisation} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture(%{organisation_id: organisation.id, role: "admin"}))
        |> live(~p"/tasks")

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, ~p"/tasks/new")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tasks")

      html = render(index_live)
      assert html =~ "Task created successfully"
      assert html =~ "some status"
    end

    test "updates task in listing", %{conn: conn, task: task, organisation: organisation} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture(%{organisation_id: organisation.id, role: "admin"}))
        |> live(~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, ~p"/tasks/#{task}/edit")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tasks")

      html = render(index_live)
      assert html =~ "Task updated successfully"
      assert html =~ "open"
    end

    test "deletes task in listing", %{conn: conn, task: task, organisation: organisation} do
      {:ok, index_live, _html} =
        conn |> log_in_user(user_fixture(%{organisation_id: organisation.id})) |> live(~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Delete") |> render_click()
      # because JS.hide is removed
      assert has_element?(index_live, "#tasks-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    test "displays task", %{conn: conn, task: task, organisation: organisation} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture(%{organisation_id: organisation.id}))
        |> live(~p"/tasks/#{task}")

      assert html =~ "Show Task"
      assert html =~ task.status
    end

    test "updates task within modal", %{conn: conn, task: task, organisation: organisation} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture(%{organisation_id: organisation.id}))
        |> live(~p"/tasks/#{task}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, ~p"/tasks/#{task}/show/edit")

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tasks/#{task}")

      html = render(show_live)
      assert html =~ "Task updated successfully"
      assert html =~ "open"
    end
  end
end
