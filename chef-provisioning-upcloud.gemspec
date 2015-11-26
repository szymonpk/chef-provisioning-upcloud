$:.unshift(File.dirname(__FILE__) + '/lib')
require 'chef/provisioning/upcloud_driver/version'

Gem::Specification.new do |s|
  s.name = 'chef-provisioning-upcloud'
  s.version = Chef::Provisioning::UpcloudDriver::VERSION
  s.platform = Gem::Platform::RUBY
  # TODO: add LICENSE and README.md
  s.extra_rdoc_files = []
  s.summary = 'Provisioner for creating upcloud containers in Chef Provisioning.'
  s.description = s.summary
  s.author = 'Szymon Szypulski'
  s.email = 'szymon.szypulski@gmail.com'
  s.homepage = 'https://github.com/szymonpk/chef-provisioning-upcloud'

  s.add_dependency 'chef', '>= 11.16.4'
  s.add_dependency 'chef-provisioning', '~> 0.9'
  s.add_dependency 'hurley'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'

  s.bindir       = "bin"
  s.executables  = %w( )

  s.require_path = 'lib'
  # TODO: add LICENSE and README.md
  s.files = %w(Rakefile) + Dir.glob("{distro,lib,tasks,spec}/**/*", File::FNM_DOTMATCH).reject {|f| File.directory?(f) }
end
