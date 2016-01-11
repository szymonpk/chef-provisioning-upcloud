# chef-provisioning-upcloud

**Pull requests are encouraged and greatly appreciated!**

## Warning - there will be dragons

- Use at your own risk.
- It's POC, created just for fun and maybe to learn something.

## What doesn't work

- `action :destroy` won't delete disks.

## Quick start

### knife.rb

```ruby
current_dir = File.dirname(__FILE__)
cookbook_copyright       "Szymon Szypulski"
cookbook_email           "szymon.szypulski@gmail.com"
log_level                :info
log_location             STDOUT
node_name                "szymon"
client_key               "#{ENV["HOME"]}/.chef_priv/szymon.pem"
validation_client_name   "organization-validator"
validation_key           "#{ENV["HOME"]}/.chef_priv/organization-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/organization"
cookbook_path            ["./cookbooks"]
profiles(
  "default" => {},
  "openday" => {
    driver: "upcloud:openday",
    machine_options: {
      bootstrap_options: {
        # https://api.upcloud.com/1.2/storage/template
        template: "01000000-0000-4000-8000-000030040200", # Ubuntu 14.04
        # https://api.upcloud.com/1.2/zone
        zone: "uk-lon1",
        # https://api.upcloud.com/1.2/plan
        plan: "1xCPU-1GB"
      }
    }
  }
)
drivers(
  "upcloud:openday" => {
    driver_options: {
      compute_options: {
        auth_token: "<base64 from upcloud user+":"+password>"
      }
    }
  }
)
```

### provision.rb

```ruby
require "chef/provisioning/upcloud_driver/driver"

with_chef_server Chef::Config[:chef_server_url],
                 client_name: Chef::Config[:node_name],
                 signing_key_filename: Chef::Config[:client_key]

machine "web1.tld.com"
```

### Execution

```
CHEF_PROFILE=openday chef-client -c knife.rb provision.rb
```
