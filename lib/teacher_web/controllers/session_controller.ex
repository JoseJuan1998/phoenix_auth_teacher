defmodule TeacherWeb.SessionController do
  use TeacherWeb, :controller

  alias Teacher.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    auth_params["username"]
    |> Accounts.get_by_username()
    |> Bcrypt.check_pass(auth_params["password"])
    |> case do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed in successfully")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, _error} ->
        conn
        |> put_flash(:error, "There was a problem with your username/password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
