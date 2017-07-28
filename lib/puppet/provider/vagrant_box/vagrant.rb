Puppet::Type.type(:vagrant_box).provide(:vagrant) do
  desc "Vagrant provide for vagrant_box"

  commands :vagrantcmd => "vagrant"

  def create
    #vagrant box add --box-version VALUE --provider PROVIDER hashicorp/precise64
    #vagrant box update --box VALUE  --provider VALUE
    #todo implement code
    args = ['box', 'add', '--provider', @resource.value(:box_provider)]
    if @resource.value(:version)
      args += ['--box-version', @resource.value(:version)]
    end
    args << @resource.value(:name)
    vagrantcmd(*args)
  end

  def destroy
    #vagrant box remove  --provider PROVIDER --box-version VERSION --force NAME
    #
    #todo implement code
    args = ['box', 'remove', '--provider', @resource.value(:box_provider)]
    if @resource.value(:version)
      args += ['--box-version', @resource.value(:version)]
    end
    args << '--force'
    args << @resource.value(:name)

    vagrantcmd(*args)
    unless $CHILD_STATUS.success?
      self.fail "Could not remove vagrant box: #{@resource.value(:name)}"
    end
  end

  def exists?
    #vagrant box list
    #todo implement code
    output = vagrantcmd('box', 'list')

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
      next if match_data.nil?

      provider, version = match_data.captures
      unless boxes.has_key? name
        boxes[name] = []
      end
      boxes[name] << {'name' => name, 'version' => version, 'box_provider' => provider}
    end

    if boxes.has_key?(@resource.value(:name))
      box = boxes[@resource.value(:name)]
      filtered = box.select do |item|
        if @resource.value(:version)
          version_constraint = Puppet::Util::Package.versioncmp(@resource.value(:version), item['version']) === 0
        else
          version_constraint = true
        end
        item['box_provider'] == @resource.value(:box_provider) && version_constraint
      end
      filtered.empty? ? false : true
    else
      false
    end
  end
end
