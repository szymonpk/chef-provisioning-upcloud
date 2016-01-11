class Base::ReadyMachine
  include Interactor

  # @param client
  # @param action_handler
  # @param machine_spec
  def call
    client = context.client
    machine_id = context.machine_spec.reference["server_id"]

    machine = GetMachine.call(*context).machine
    return if machine["state"] == "started"
    context.action_handler.perform_action "Powering up, wait for machine #{machine_id}\n" do
      client.post("server/#{machine_id}/start")
      while machine["state"] != "started"
        Timeout.timeout(60) do
          sleep 5
          client.post("server/#{machine_id}/start")
          machine = GetMachine.call(*context).machine
        end
      end
    end
  end
end
