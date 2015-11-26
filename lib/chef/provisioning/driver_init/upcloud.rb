require 'chef/provisioning/upcloud_driver/driver'

Chef::Provisioning.register_driver_class(
  'upcloud',
  Chef::Provisioning::UpcloudDriver::Driver
)
