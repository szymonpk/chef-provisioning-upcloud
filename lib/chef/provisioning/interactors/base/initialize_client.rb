class Base::InitializeClient
  include Interactor

  # @param auth_token
  def call
    client = Hurley::Client.new "https://api.upcloud.com/1.2/"
    client.header["Authorization"] = "Basic #{context.auth_token}"
    client.header["Content-Type"] = "application/json"

    context.client = client
  end
end
