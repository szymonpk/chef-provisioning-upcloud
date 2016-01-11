class Base::DestroyMachine
  include Interactor

  # @param client
  # @param action_handler
  # @param machine_spec
  def call
    machine_id = context.machine_spec.reference["server_id"]
    context.action_handler.perform_action "Destroy machine #{machine_id}\n" do
      # delete all disks too
      context.client.delete("server/#{machine_id}")
      context.machine_spec.reference = nil
    end
  end
end
