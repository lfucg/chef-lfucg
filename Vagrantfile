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

    config.vm.hostname = "chef-ckan"
    config.vm.box = "bento/ubuntu-14.04"

    config.vm.network :forwarded_port, guest: 8000, host: 8000
    config.vm.network :forwarded_port, guest: 5555, host: 5555
    config.vm.network :public_network, bridge: "en1: Wi-Fi (AirPort)"
    config.vm.boot_timeout = 120


    # OSX needs this for concurrent open files
    config.vm.provision :shell, :inline => "ulimit -n 4048"

    # This is needed for windows 7 (not sure about later versions)
    config.vm.provision :shell, :inline => <<-SHELL
        echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4
    SHELL

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
