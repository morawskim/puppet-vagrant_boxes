#! /usr/bin/env ruby

describe Puppet::Type.type(:vagrant_box) do

  before :each do
    @vagrant_box = Puppet::Type.type(:vagrant_box).new(
    :name => 'opensuse/openSUSE-13.2-x86_64',
      :version => '1.0.0',
    )
  end

  it 'should accept name' do
    expect(@vagrant_box[:name]).to eq('opensuse/openSUSE-13.2-x86_64')
  end

  it 'should set default box_provider to virtualbox' do
    expect(@vagrant_box[:box_provider]).to eq('virtualbox')
  end

  it 'should set version' do
    expect(@vagrant_box[:version]).to eq('1.0.0')
  end

  it 'explicitly set vagrant_home' do
    vagrant_box = Puppet::Type.type(:vagrant_box).new(
        :name => 'opensuse/openSUSE-13.2-x86_64',
        :version => '1.0.0',
        :vagrant_home => '/tmp/vagrant'
    )
    expect(vagrant_box[:vagrant_home]).to eq('/tmp/vagrant')
  end

  context 'set vagrant_home from fact' do
    let(:facts) { { vagrant_home: '/usr/share/vagrant'} }
    it 'should have vagrant_home' do
      expect(@vagrant_box[:vagrant_home]).to eq('/usr/share/vagrant')
    end

    it 'and overwrite in type' do
      @vagrant_box[:vagrant_home] = '/not/exist'
      expect(@vagrant_box[:vagrant_home]).to eq('/not/exist')
    end
  end

  #context co jesli zla sciezka, nie jest to katalog itp

  # moze tez podejrzec https://github.com/puppetlabs/puppetlabs-vcsrepo/blob/master/spec/unit/puppet/type/vcsrepo_spec.rb
  # jak zrobic testy qutorequire
end
