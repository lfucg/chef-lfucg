Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        # The AWS api forces signed requests to be no older than 5 minutes. If you leave a vagrant VM running while your
        # host OS sleeps, you can experience a drastic time skew on the guest OS.
        #
        # This forces the system time to sync every 10 seconds as opposed to the default 20 minutes.  If you still
        # experience AWS 400 errors, the solution is to run `vagrant reload`.
        v.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]

        # Remote files seem to download slowly without these settings
        v.customize [ "modifyvm", :id, "--natdnshostresolver1", "on" ]
        v.customize [ "modifyvm", :id, "--natdnsproxy1", "on" ]
    end

    # the line below is going to name your machine, this will help you find it when it is running on
    # your host machine.
    config.vm.hostname = "chef-lfucg"
    config.vm.box = "bento/ubuntu-14.04"

    # the line below is going to determine which port your application will be forwarded to on your
    # host machine.  For example, if your application is using php and apache, apache will be using
    # port 80.  If you wanted to forward that to port 8000 on your host the line would look like:
    # config.vm.network :forwarded_port, guest: 80, host: 8000
    config.vm.network :forwarded_port, guest: 8000, host: 8000
    config.vm.network :forwarded_port, guest: 5555, host: 5555
    config.vm.network :public_network, bridge: "en1: Wi-Fi (AirPort)"
    config.vm.boot_timeout = 120

    config.berkshelf.enabled = true
    config.omnibus.chef_version = "12.19.26"

    #  You don’t need to get your code on your virtual machine because it is able to share folders with
    #  your host machine.  Your repo root should be in the directory that contains this Vagrantfile.
    config.vm.synced_folder "../", "/home/vagrant/chef-lfucg"

    # OSX needs this for concurrent open files
    config.vm.provision :shell, :inline => "ulimit -n 4048"

    # This is needed for windows 7 (not sure about later versions)
    config.vm.provision :shell, :inline => <<-SHELL
        echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4
    SHELL

    #  Below you’ll see chef.run_list =
    # This determines which recipes will be run when you start your machine with ```vagrant up```
    # or ```vagrant provision```.  We’ll start with one recipe for now, uncomment the ‘recipe’ line
    # and fill in the name of your chef-repo

    config.vm.provision :chef_solo do |chef|
        chef.log_level = :fatal
        # Sets password for the postgres user
        chef.json = {
            "vagrant" => {
                "symlink_npm" => (RbConfig::CONFIG["host_os"] =~ /cygwin|mswin|mingw/) ? true : false
            },
            "postgresql": {
                "password": {
                    "postgres": "password"
                }
            }
        }
        chef.run_list = [
            "recipe[chef-lfucg::system]"
        ]
    end
end
