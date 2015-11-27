require "chef/provisioning/interactors/base"
require "chef/provisioning/interactors/base/destroy_machine"
require "chef/provisioning/interactors/base/initialize_client"
require "chef/provisioning/interactors/base/stop_machine"

class DestroyMachine
  include Interactor::Organizer

  organize Base::InitializeClient, Base::StopMachine, Base::DestroyMachine
end
