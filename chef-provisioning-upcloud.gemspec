# rubocop:disable Style/FileName
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")
require "chef/provisioning/upcloud_driver/version"

Gem::Specification.new do |s|
  s.name = "chef-provisioning-upcloud"
  s.version = Chef::Provisioning::UpcloudDriver::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = []
  s.summary = "Provisioner for creating upcloud containers in Chef Provisioning."
  s.description = s.summary
  s.author = "Szymon Szypulski"
  s.email = "szymon.szypulski@gmail.com"
  s.homepage = "https://github.com/szymonpk/chef-provisioning-upcloud"
  s.license = "MIT"

  s.add_dependency "chef", "~> 12.5"
  s.add_dependency "chef-provisioning", "~> 1.5.0"
  s.add_dependency "hurley"
  s.add_dependency "interactor", "~> 3.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "pry"

  s.bindir       = "bin"
  s.executables  = %w( )

  s.require_path = "lib"

  s.files = Dir.glob("{distro,lib,tasks,spec}/**/*", File::FNM_DOTMATCH).reject do |f|
    File.directory?(f)
  end + %w(Rakefile README.md CHANGELOG.md)
end
