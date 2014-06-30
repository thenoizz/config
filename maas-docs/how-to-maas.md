#How to deploy MAAS
##Prerequisites:
*
*

##Notes:
* For maas-node you need 2 nics, one public, one private.
* The windows machine will only be used to generate the windows images for maas.
* It needs access to the samba server

##Steps:

1. Add ppa	
	```
	ppa:maas-maintainers/testing
	sudo apt-get install software-properties-common -y
	sudo add-apt-repository ppa:maas-maintainers/testing
	sudo apt-get update
	```
2. install maas and maas-samba. Be sure to have only maas-samba running with the proper configurations.
	```
	sudo apt-get install maas maas-samba -y
	sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.old
	sudo cp /etc/maas/smb.conf /etc/samba/smb.conf
	sudo service smbd  restart
	mkdir -p /var/lib/samba/usershares/reminst
	```

3. create admin user(insert password when prompted)
	```
	sudo maas-region-admin createadmin --username root --email user@server.com"
	```
4. import boot images
	```
	sudo maas-import-pxe-files
	```

5. Do the steps for the windows machine. We need to do this on windows machine to generate windows images:

	1. Install git

	2. Get tools for generating winPE files `git clone https://github.com/cloudbase/adk-tools-maas.git`
	
	3. Download and mount your ISO windows file that you later want to deploy and set *InstallMediaPath* variable to the correct drive letter inside BuildInstallImage.ps1

	4. Mount the samba server "\\<server-ip>\reminst"
	```
	New-PSDrive -Name <drive letter> -Root \\<server-ip>\reminst -PSProvider FileSystem
	```

	5. Set *TargetPath* inside CopyImageToMaaS.ps1 to the appropriate samba server mounted on your drive letter. So instead of the default value "\\192.168.100.1\WinPE" you would have  "<drive letter>:\\"

	6. Run scripts in this order:
	```
	./BuildWinPE.ps1
	./BuildInstallImage.ps1 
	./CopyImageToMaaS.ps1
	```
	**** for further reading about the tools:
			https://github.com/cloudbase/adk-tools-maas/blob/master/README.md

6. Create symlinks to the the windows images into boot-resources:
	note : replace win2012r2 with the windows flavour that you need

	command1 : mkdir -p /var/lib/maas/boot-resources/current/windows/amd64/generic/win2012r2/release
	command2 : cd /var/lib/maas/boot-resources/current/windows/amd64/generic/win2012r2/release
	command3 : for i in `ls /var/lib/maas/samba/ws2012r2/boot/`;do ln -s /var/lib/maas/samba/win2012r2/boot/$i $i;done

7.  Edit the default cluster and enable DHCP and DNS on the interface where you will be serving DHCP, see following image for an example.
	go to the url: http://<maas-server-ip>/MAAS/clusters/ ; eth1 is most probably the one that needs to be configured
	Example:
		Router ip = eth1's Ip
		Ip = eth1's Ip
		http://wiki.cloudbase.it/_media/screen_shot_2014-04-23_at_01.27.08.png

8. Set upstream DNS:
	go to the url: http://<maas-server-ip>/MAAS/settings/
	Look for "Upstream DNS used to resolve domains not managed by this MAAS" and set the dns to something like 8.8.8.8

9. Add a ssh key for authentification to the nodes:
	Generate a key:
		Command1 : ssh-keygen -t rsa
		Command2 : cat ~/.ssh/id_rsa.pub
			copy the output
	go to the url: http://<maas-server-ip>/MAAS/account/prefs/sshkey/add/
	here you need to paste the contents that you copied.

10. If you are working on Vmware workstation/ESXI server you will need a power adapter so that maas can power on and off the VM's

	command1 : git clone https://github.com/trobert2/maas-hacks
	command2 : git fetch origin
	command3 : git checkout -b new_poweradapter origin/new_poweradapter
	command4 : cd maas-hacks/vmware

	NOTE: in the install file on the line that does `cp "$BASEDIR/vmware.template" ~/maas/etc/maas/templates/power/` you need to replace "~/maas/etc/maas/templates/power/" with "etc/maas/templates/power/"
	The diff has to patch these two files:
	/usr/lib/python2.7/dist-packages/provisioningserver/power_schema.py
	/usr/lib/python2.7/dist-packages/maasserver/models/node.py













<!-- Dorin’s way (on VMware ESXi)

Add a new VM, 2 NIC’s, 1 external, 1 private.
Install Ubuntu 14.04
Install vmware tools
apt-get update & upgrade
configure networking (static ip’s, etc) -->

