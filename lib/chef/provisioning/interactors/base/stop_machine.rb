class Base::StopMachine
  include Interactor

  # @param client
  # @param action_handler
  # @param machine_spec
  def call
    machine_id = context.machine_spec.reference["server_id"]
    context.action_handler.perform_action "Power off machine #{machine_id}\n" do
      context.client.post("server/#{machine_id}/stop")
    end

    machine = GetMachine.call(*context).machine
    while machine["state"] != "stopped"
      Timeout.timeout(60) do
        sleep 20
        machine = GetMachine.call(*context).machine
      end
    end
  end
end
