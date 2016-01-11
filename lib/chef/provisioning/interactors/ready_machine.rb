require "chef/provisioning/interactors/base"
require "chef/provisioning/interactors/base/initialize_client"
require "chef/provisioning/interactors/base/ready_machine"

class ReadyMachine
  include Interactor::Organizer

  organize Base::InitializeClient, Base::ReadyMachine
end
