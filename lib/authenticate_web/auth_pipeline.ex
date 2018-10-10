defmodule Authenticate.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :authenticate,
  module: Authenticate.Guardian,
  error_handler: Authenticate.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
