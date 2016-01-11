require "chef/provisioning/upcloud_driver/version"

class Base::RequestMachine
  include Interactor

  # @param client
  # @param action_handler
  # @param machine_spec
  # @param driver_url
  def call
    machine_options = context.machine_options
    machine_spec = context.machine_spec

    context.action_handler.perform_action "Creating server #{machine_spec.name} with options #{machine_options}\n" do
      response = context.client.post("server", request_body(machine_options, machine_spec).to_json, "application/json")
      if response.success?
        server = JSON.parse(response.body)["server"]

        machine_spec.reference = {
          "driver_url" => context.driver_url,
          "driver_version" => ::Chef::Provisioning::UpcloudDriver::VERSION,
          "server_id" => server["uuid"],
          "bootstrap_password" => server["password"]
        }
      else
        fail "Unexpected response: #{response.body}"
      end
    end
  end

  private

  def request_body(machine_options, machine_spec)
    {
      server: {
        zone: machine_options[:bootstrap_options][:zone],
        title: machine_spec.name,
        hostname: machine_spec.name,
        plan: machine_options[:bootstrap_options][:plan],
        storage_devices: {
          storage_device: [{
            action: "clone",
            storage: machine_options[:bootstrap_options][:template],
            title: "#{machine_spec.name} from a template",
            size: 30,
            tier: "maxiops"
          }]
        }
      }
    }
  end
end
