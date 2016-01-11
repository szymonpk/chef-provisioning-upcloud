require "chef/provisioning/interactors/base"
require "chef/provisioning/interactors/base/stop_machine"
require "chef/provisioning/interactors/base/initialize_client"

class StopMachine
  include Interactor::Organizer

  organize Base::InitializeClient, Base::StopMachine
end
