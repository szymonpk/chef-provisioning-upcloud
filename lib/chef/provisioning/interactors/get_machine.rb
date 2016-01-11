require "chef/provisioning/interactors/base"
require "chef/provisioning/interactors/base/get_machine"
require "chef/provisioning/interactors/base/initialize_client"

class GetMachine
  include Interactor::Organizer

  organize Base::InitializeClient, Base::GetMachine
end
