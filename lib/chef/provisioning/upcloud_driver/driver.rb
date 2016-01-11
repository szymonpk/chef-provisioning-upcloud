require "chef/provisioning/driver"
require "chef/provisioning/upcloud_driver/version"

require "chef/provisioning/transport/ssh"
require "chef/provisioning/convergence_strategy/install_cached"
require "chef/provisioning/machine/unix_machine"

require "hurley"
require "interactor"

require "chef/provisioning/interactors/destroy_machine"
require "chef/provisioning/interactors/get_machine"
require "chef/provisioning/interactors/ready_machine"
require "chef/provisioning/interactors/request_machine"
require "chef/provisioning/interactors/stop_machine"

class Chef
  module Provisioning
    module UpcloudDriver
      class Driver < Chef::Provisioning::Driver
        include Chef::Mixin::ShellOut

        def self.from_url(driver_url, config)
          Driver.new(driver_url, config)
        end

        def initialize(driver_url, config)
          super

          begin
            @auth_token = config[:driver_options][:compute_options][:auth_token]
          rescue NoMethodError
            msg = "Auth token is missing"
            Chef::Log.fatal msg
            raise msg
          end
        end

        def self.canonicalize_url(driver_url, config)
          [driver_url, config]
        end

        def allocate_machine(action_handler, machine_spec, machine_options)
          if machine_spec.reference
            GetMachine.call(action_handler: action_handler, auth_token: @auth_token, machine_spec: machine_spec)
          end
          return if machine_spec.reference
          RequestMachine.call(
            action_handler: action_handler, auth_token: @auth_token, driver_url: driver_url,
            machine_options: machine_options, machine_spec: machine_spec
          )
        end

        def stop_machine(action_handler, machine_spec, _machine_options)
          return unless machine_spec.reference
          StopMachine.call(action_handler: action_handler, auth_token: @auth_token, machine_spec: machine_spec)
        end

        def destroy_machine(action_handler, machine_spec, _machine_options)
          return unless machine_spec.reference
          DestroyMachine.call(action_handler: action_handler, auth_token: @auth_token, machine_spec: machine_spec)
        end

        def ready_machine(action_handler, machine_spec, machine_options)
          ReadyMachine.call(auth_token: @auth_token, action_handler: action_handler, machine_spec: machine_spec)

          machine_for(machine_spec, machine_options)
        end

        def machine_for(machine_spec, machine_options)
          machine = GetMachine.call(auth_token: @auth_token, machine_spec: machine_spec).machine
          ip_address = machine["ip_addresses"]["ip_address"].find do |address|
            address["family"] == "IPv4" && address["access"] == "public"
          end["address"]

          ssh_options = {
            auth_methods: ["password"],
            password: machine_spec.reference["bootstrap_password"]
          }

          transport = Chef::Provisioning::Transport::SSH.new(
            ip_address, "root", ssh_options, {}, config
          )

          convergence_strategy =
            Chef::Provisioning::ConvergenceStrategy::InstallCached.new(machine_options[:convergence_options], {})
          Chef::Provisioning::Machine::UnixMachine.new(machine_spec, transport, convergence_strategy)
        end

        def connect_to_machine(machine_spec, machine_options)
          machine_for(machine_spec, machine_options)
        end
      end
    end
  end
end
