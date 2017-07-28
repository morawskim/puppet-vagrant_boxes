require 'spec_helper_acceptance'

describe 'vagrant box' do

  let :pp do
    <<-EOS
      vagrant_box{'ubuntu/trusty64':
        ensure => present,
      }
    EOS
  end

  it 'should run without errors' do
    apply_manifest(pp, :catch_failures => true)
  end

  it 'should have box ubuntu' do
    show_result = shell('vagrant box list')
    expect(show_result.stdout).to match /ubuntu\/trusty64 \(virtualbox/
  end

  it 'should run a second time without changes' do
    result = apply_manifest(pp, :catch_failures => true)
    expect(result.exit_code).to eq 0
  end
end