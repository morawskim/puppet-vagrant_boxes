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
end
