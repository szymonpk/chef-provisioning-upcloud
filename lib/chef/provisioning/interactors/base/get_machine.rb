class Base::GetMachine
  include Interactor

  # @param client
  # @param action_handler (optional)
  # @param machine_spec
  def call
    machine_id = context.machine_spec.reference["server_id"]
    response = context.client.get("server/#{machine_id}")
    case response.status_code
    when 404
      context.action_handler.perform_action "Machine #{machine_id} does not exist.\n" do
        context.machine_spec.reference = nil
      end if context.action_handler
      context.machine = nil
    when 200
      puts "Machine #{machine_id} exist.\n"
      context.machine = JSON.parse(response.body)["server"]
    else
      fail "Unexpected response"
    end
  end
end
