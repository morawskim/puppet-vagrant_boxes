# require 'beaker-rspec/spec_helper'
# require 'beaker-rspec/helpers/serverspec'
require 'beaker-rspec'

hosts.each do |host|
  # not on sle
  # install_puppet
end



RSpec.configure do |c|
  find_only_one :default
  # c.qweqweqwe = 'aaaa'

#    proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
#    c.formatter = :documentation
  c.before :suite do
    project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    # Install module and dependencies
    puppet_module_install(:source => project_root, :module_name => 'vagrant_boxes')

    # hosts.each do |host|
    # end
  #     copy_module_to(host, :source => proj_root, :module_name => 'module')
  #
  #     ...
  #
  #         on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
  #     on host, puppet('module','install','puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
  #   end
  end
end
