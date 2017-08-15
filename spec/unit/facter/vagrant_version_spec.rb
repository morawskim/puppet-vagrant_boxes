require 'spec_helper'

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe 'vagrant_version' do
    context 'with value' do
      before :each do
        # resolve_value
        Facter::Util::Resolution.stubs(:exec)
            .with('vagrant --version')
            .returns('Vagrant 1.9.5')
      end
      it {
        expect(Facter.fact(:vagrant_version).value).to eq('1.9.5')
      }
    end
  end
end
