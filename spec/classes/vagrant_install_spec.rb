require 'spec_helper'

describe 'vagrant_boxes::install' do

  context 'with defaults for all parameters' do
    context 'rpm' do
      ['OpenSuSE'].each do |distro|
        context 'x64' do
          ['x86_64', 'amd64'].each do |arch|
            let(:facts) do
              {:architecture => arch, :operatingsystem => distro}
            end

            let(:params) {{:version => '1.9.0'}}
            it do
              should contain_package('vagrant').with(
                'ensure'   => 'present',
                'source'   => 'https://releases.hashicorp.com/vagrant/1.9.0/vagrant_1.9.0_x86_64.rpm',
                'provider' => 'rpm',
              )
            end
          end
        end

        context 'x86' do
          let(:facts) { {:architecture => 'i386', :operatingsystem => distro} }
          let(:params) { {:version => '1.9.0'} }

          it do
            should contain_package('vagrant').with(
              'ensure'   => 'present',
              'source'   => 'https://releases.hashicorp.com/vagrant/1.9.0/vagrant_1.9.0_i686.rpm',
              'provider' => 'rpm',
            )
          end
        end
      end
    end
  end
end
