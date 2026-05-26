# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Default configurations
  config.vm.communicator = "winrm"
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  # DC01-Prod (Domain Controller corp.local)
  config.vm.define "dc01-prod" do |dc01|
    dc01.vm.box = "gusztavvargadr/windows-server-2022-standard"
    
    # Port Forwarding for Host management / Ansible / RDP
    dc01.vm.network "forwarded_port", guest: 5985, host: 59851, id: "winrm", auto_correct: false
    dc01.vm.network "forwarded_port", guest: 3389, host: 33891, id: "rdp", auto_correct: false
    
    # Internal network interface
    dc01.vm.network "private_network", ip: "10.10.10.10", virtualbox__intnet: "net_corp_prod"
    
    dc01.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "6144"
      vb.cpus = 2
      vb.name = "dc01-prod"
      vb.customize ["modifyvm", :id, "--groups", "/ActiveDirectoryLab"]
      vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    end

    # Provision bootstrap WinRM
    dc01.vm.provision "shell", path: "bootstrap.ps1"
  end

  # DC02-Dev-Tree (Domain Controller dev-internal.local - Dual Homed / Router)
  config.vm.define "dc02-dev-tree" do |dc02|
    dc02.vm.box = "gusztavvargadr/windows-server-2022-standard"
    
    # Port Forwarding for Host management / Ansible / RDP
    dc02.vm.network "forwarded_port", guest: 5985, host: 59852, id: "winrm", auto_correct: false
    dc02.vm.network "forwarded_port", guest: 3389, host: 33892, id: "rdp", auto_correct: false
    
    # Dual network interfaces
    # Interface 1: corp internal net
    dc02.vm.network "private_network", ip: "10.10.10.11", virtualbox__intnet: "net_corp_prod"
    # Interface 2: dev zone internal net
    dc02.vm.network "private_network", ip: "10.10.20.11", virtualbox__intnet: "net_dev_zone"
    
    dc02.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "6144"
      vb.cpus = 2
      vb.name = "dc02-dev-tree"
      vb.customize ["modifyvm", :id, "--groups", "/ActiveDirectoryLab"]
      vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    end

    # Provision bootstrap WinRM
    dc02.vm.provision "shell", path: "bootstrap.ps1"
  end

  # WS01-Prod (Workstation in corp.local)
  config.vm.define "ws01-prod" do |ws01|
    ws01.vm.box = "gusztavvargadr/windows-10"
    
    # Port Forwarding for Host management / Ansible / RDP
    ws01.vm.network "forwarded_port", guest: 5985, host: 59853, id: "winrm", auto_correct: false
    ws01.vm.network "forwarded_port", guest: 3389, host: 33893, id: "rdp", auto_correct: false
    
    # Internal network interface
    ws01.vm.network "private_network", ip: "10.10.10.20", virtualbox__intnet: "net_corp_prod"
    
    ws01.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "4096"
      vb.cpus = 2
      vb.name = "ws01-prod"
      vb.customize ["modifyvm", :id, "--groups", "/ActiveDirectoryLab"]
      vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    end

    # Provision bootstrap WinRM
    ws01.vm.provision "shell", path: "bootstrap.ps1"
  end

  # SRV01-Apps (Application Server in dev-internal.local)
  config.vm.define "srv01-apps" do |srv01|
    srv01.vm.box = "gusztavvargadr/windows-server-2022-standard"
    
    # Port Forwarding for Host management / Ansible / RDP
    srv01.vm.network "forwarded_port", guest: 5985, host: 59854, id: "winrm", auto_correct: false
    srv01.vm.network "forwarded_port", guest: 3389, host: 33894, id: "rdp", auto_correct: false
    
    # Internal network interface
    srv01.vm.network "private_network", ip: "10.10.20.30", virtualbox__intnet: "net_dev_zone"
    
    srv01.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "4096"
      vb.cpus = 1
      vb.name = "srv01-apps"
      vb.customize ["modifyvm", :id, "--groups", "/ActiveDirectoryLab"]
      vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    end

    # Provision bootstrap WinRM
    srv01.vm.provision "shell", path: "bootstrap.ps1"
  end
end
