Puppet::Type.type(:vagrant_box).provide(:vagrant) do
    desc "Vagrant provide for vagrant_box"

    commands :vagrantcmd => "vagrant"

    def create
        #vagrant box add --box-version VALUE --provider PROVIDER hashicorp/precise64
        #vagrant box update --box VALUE  --provider VALUE 
        #todo implement code
    end

    def destroy
        #vagrant box remove NAME
        #
        #todo implement code
    end

    def exists?
        #vagrant box list
        #todo implement code
        output = vagrantcmd 'box' 'list'
        
        unless $CHILD_STATUS.success?
            self.fail "Could not list avaiable boxes: #{output.chomp}"
        end
        
        #morawskim/openSUSE-42.2-x86_64 (virtualbox, 1.0.1)
        #morawskim/openSUSE-42.2-x86_64 (virtualbox, 1.0.2)
        #suste_test                     (virtualbox, 0)
        
        boxes = {}
        output.split("\n").each do |l|
            line = l.strip
            name, info = line.split(' ', 2)
            match_data = info.match(/([a-zA-Z]+),\s+([\d\.]+)/)
            provider, version = match_data.captures
            unless boxes.has_key? name
                boxes[name] = []               
            end
            boxes[name] << {'name' => name, 'version' => version, 'provider' => provider}
        end
        
        if boxes.has_key?(@resource.value(:name))
            box = boxes[@resource.value(:name)]
            filtered = box.select do |item|
                item['provider'] == @resource.value(:provider)
            end
            if filtered.empty?
                false
            else
                true
            end
        else
            false
        end
    end
end
