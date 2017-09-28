require 'pathname'

Puppet::Type::newtype(:vagrant_box) do
    @doc = "Mange vagrant boxes"

    ensurable

    autorequire(:class) { 'vagrant_boxes' }

    newparam(:name) do
        desc "The vagrant box's name"

        isnamevar

        validate do |value|
            #hashicorp/precise64
            true
        end
    end
    
    newparam(:box_provider) do
      # @type self [Puppet::Parameter]
      desc "The provider"
      defaultto 'virtualbox'

      #todo enum validate
      #validate
    end
    
    newparam(:version) do
        desc "Box version"
    end

    newparam(:vagrant_home) do
      desc 'VAGRANT_HOME can be set to change the directory
        where Vagrant stores global state.
        The Vagrant home directory is where things such as boxes are stored,
        so it can actually become quite large on disk.'
      defaultto do
        Facter.fact(:vagrant_home).value
      end

      validate do |value|
        path = Pathname.new(value)
        unless path.absolute? && path.directory?
          raise ArgumentError, "Path must be existing directory: #{path}"
        end
      end
    end
end
