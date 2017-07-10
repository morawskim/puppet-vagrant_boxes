Puppet::Type::newtype(:vagrant_box) do
    @doc = "Mange vagrant boxes"

    ensurable

    newparam(:name) do
        desc "The vagrant box's name"

        isnamevar

        validate do |value|
            #hashicorp/precise64
            true
        end
    end
    
    newparam(:provider) do
        desc "The provider"
        
        #todo enum validate
        #validate
    end
    
    newparam(:version) do
        desc "Box version"
        #todo validate as in package type
    end
end

