require "chef/provisioning/interactors/base"
require "chef/provisioning/interactors/base/request_machine"
require "chef/provisioning/interactors/base/initialize_client"

class RequestMachine
  include Interactor::Organizer

  organize Base::InitializeClient, Base::RequestMachine
end
