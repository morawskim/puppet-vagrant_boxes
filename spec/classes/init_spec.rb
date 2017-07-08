require 'spec_helper'
describe 'vagrant_boxes' do

  context 'with defaults for all parameters' do
    it { should contain_class('vagrant_boxes') }
  end
end
