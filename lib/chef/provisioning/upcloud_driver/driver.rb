require 'chef/provisioning/driver'

require 'hurley'

class Chef
module Provisioning
module UpcloudDriver
  class Driver < Chef::Provisioning::Driver
    include Chef::Mixin::ShellOut

    def self.from_url(driver_url, config)
      Driver.new(driver_url, config)
    end
  end
end
end
end
