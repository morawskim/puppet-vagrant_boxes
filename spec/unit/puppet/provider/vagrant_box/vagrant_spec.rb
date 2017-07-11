#!/usr/bin/env rspec
require 'spec_helper'

describe Puppet::Type.type(:vagrant_box).provider(:vagrant) do
  let :resource do
    Puppet::Type.type(:vagrant_box).new(
 name: 'ubuntu/precise64',
					ensure: :present
    )
  end

  let :provider do
    described_class.new(resource).tap do |provider|
      provider.stubs(:command).with(:vagrant).returns '/usr/local/bin/vagrant'
    end
  end

  # def self.it_should_respond_to(*actions)
  #   actions.each do |action|
  #     it "should respond to :#{action}" do
  #       expect(provider).to respond_to(action)
  #     end
  #   end
  # end
  #
  # it_should_respond_to :install, :uninstall, :update, :query

  # describe 'when installing npm packages' do
  #
  #   describe 'and install_options is a hash' do
  #     it 'passes the install_options to npm' do
  #       resource[:install_options] = [{ '-d' => '/tmp' }]
  #       provider.expects(:composer).with('--no-interaction', 'require', '-d=/tmp', 'phing/phing')
  #       provider.install
  #     end
  #   end
  #
  #   describe 'and install_options is a string' do
  #     it 'passes the install_options to npm' do
  #       resource[:install_options] = ['--verbose -d /tmp']
  #       provider.expects(:npm).with('install', '--global', '--verbose', 'express')
  #       provider.install
  #     end
  #   end
  #
  # end
  #
  #
  #
  # it 'returns a list of npm packages installed globally' do
  #   provider.class.expects(:execute).with(['/usr/local/bin/npm', 'list', '--json', '--global'], anything).returns(my_fixture_read('npm_global'))
  #   expect(provider.class.instances.map(&:properties).sort_by { |res| res[:name] }).to eq([
  #                                                                                             { ensure: '2.5.9', provider: 'npm', name: 'express' },
  #                                                                                             { ensure: '1.1.15', provider: 'npm', name: 'npm' }
  #                                                                                         ])
  # end
  #
  # it 'logs and continue if the list command has a non-zero exit code' do
  #   provider.class.expects(:execute).with(['/usr/local/bin/npm', 'list', '--json', '--global'], anything).returns(my_fixture_read('npm_global'))
  #   Process::Status.any_instance.expects(:success?).returns(false) # rubocop:disable RSpec/AnyInstance
  #   Process::Status.any_instance.expects(:exitstatus).returns(123) # rubocop:disable RSpec/AnyInstance
  #   Puppet.expects(:debug).with(regexp_matches(%r{123}))
  #   expect(provider.class.instances.map(&:properties)).not_to eq([])
  # end
  #
  # it 'remove' do
  #   resource[:ensure] = 'absent'
  #   resource[:install_options] = [{ '-d' => '/tmp' }]
  #   provider.expects(:composer).with('--no-interaction', 'require', '-d=/tmp', 'phing/phing')
  #   provider.uninstall
  # end

  describe '#create' do
    it 'with wrong provider' do
      provider.stubs(:vagrantcmd).with('box', 'add', '--provider', resource[:box_provider], resource[:name])
      provider.create
    end

    it 'with default provider' do
      provider.stubs(:vagrantcmd).with('box', 'add', '--provider', 'virtualbox', resource[:name])
      provider.create
    end

    it 'with box version and provider' do
      resource[:version] = '20170112.0.0'
      provider.stubs(:vagrantcmd).with('box', 'add', '--provider', resource[:box_provider], '--box-version', resource[:version], resource[:name])
      provider.create
    end

    it 'with box version and without provider' do
      resource[:version] = '20170112.0.0'
      provider.stubs(:vagrantcmd).with('box', 'add', '--provider', 'virtualbox', '--box-version', resource[:version], resource[:name])
      provider.create
    end
  end

  describe '#exists?' do
    it 'with wrong box version' do
      resource[:version] = 'X.Y.Z'
      provider.stubs(:vagrantcmd).returns(my_fixture_read('boxes_list'))
      result = provider.exists?
      expect(result).to be_falsey
    end

    it 'with correct box version' do
      resource[:version] = '20170112.0.0'
      provider.stubs(:vagrantcmd).returns(my_fixture_read('boxes_list'))
      result = provider.exists?
      expect(result).to be_truthy
    end

    it 'with not exists provider' do
      resource[:box_provider] = 'FAKE'
      provider.stubs(:vagrantcmd).returns(my_fixture_read('boxes_list'))
      result = provider.exists?
      expect(result).to be_falsey
    end
  end

  describe '#destroy ' do
    it 'without box version' do
      provider.stubs(:vagrantcmd).with('box', 'remove', '--provider', 'virtualbox', '--force', resource[:name])
      provider.destroy
    end

    it 'with box version' do
      resource[:version] = '20170112.0.0'
      provider.stubs(:vagrantcmd).with(
        'box',
        'remove',
        '--provider',
        'virtualbox',
        '--box-version',
        resource[:version],
        '--force',
        resource[:name]
      )
      provider.destroy
    end
  end
end
