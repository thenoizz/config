#How to deploy MAAS
This document will describe how to deploy Ubuntu® MAAS supporting some Windows features.

###Prerequisites:
**Machine 1** (MAAS Controller): Ubuntu 14.04 Server w/ two NIC's (1 external, 1 private).

**Machine 2** (Windows Image Generator): Windows Server 2012 R2, 1 NIC (external) on the same network w/ Machine 1. 

*Note:* Machine 2 will need network acces to the Machine 1 samba server.
<!-- PreSteps for VMware ESXi

Create a new VM, 2 NIC’s, 1 external, 1 private.
Install Ubuntu 14.04
Install vmware tools
apt-get update & upgrade
configure networking (static ip’s, etc) 

-->

<!-- ###Notes:
* For maas-controller you need 2 NIC's, one public, one private.
* The Windows machine will only be used to generate the windows images for MAAS. -->

###Steps:

1. Add ppa:maas-maintainers/testing
	
	```bash
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install software-properties-common -y
	sudo add-apt-repository ppa:maas-maintainers/testing
	sudo apt-get update
	```

2. Install maas and maas-samba. Be sure to have only maas-samba running with the proper configurations.
	
	```bash
	sudo apt-get install maas maas-samba -y
	sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.old
	sudo cp /etc/maas/smb.conf /etc/samba/smb.conf
	sudo service smbd restart
	mkdir -p /var/lib/samba/usershares/reminst
	```

3. Create admin user (insert password when prompted)
	
	```bash
	sudo maas-region-admin createadmin --username root --email user@server.com
	```

4. Import boot images
	
	```bash
	sudo maas-import-pxe-files
	```

5. The steps are for the Windows machine. We need to do this on windows to generate boot images.

	1. Install git

	2. Get tools for generating winPE files 
		```PowerShell
		git clone https://github.com/cloudbase/adk-tools-maas.git
		cd adk-tools-maas
		```
	
	3. Download and mount a Windows ISO file that you later want to deploy. 
	
	4. Edit `BuildInstallImage.ps1` and set the *InstallMediaPath* variable to the mounted ISO drive letter. 

	5. Mount the samba server `\\<server-ip>\reminst`
		```PowerShell
		New-PSDrive -Name <drive letter> -Root \\<server-ip>\reminst -PSProvider FileSystem
		```

	6. Set *TargetPath* inside `CopyImageToMaaS.ps1` to the appropriate samba server mounted on your drive letter. So instead of the default value `\\192.168.100.1\WinPE` you would have `<drive letter>:\\`


	7. Run scripts in the following order:
		```PowerShell
		.\BuildWinPE.ps1
		.\BuildInstallImage.ps1 
		.\CopyImageToMaaS.ps1
		```

	*For further reading about the tools:*
	[https://github.com/cloudbase/adk-tools-maas/blob/master/README.md](https://github.com/cloudbase/adk-tools-maas/blob/master/README.md)

6. Create symlinks to the the windows images into boot-resources:
	
	*Note:* Replace win2012r2 with the windows flavour that you need.

	```bash
	mkdir -p /var/lib/maas/boot-resources/current/windows/amd64/generic/win2012r2/release
	cd /var/lib/maas/boot-resources/current/windows/amd64/generic/win2012r2/release
	for i in `ls /var/lib/maas/samba/ws2012r2/boot/`;do ln -s /var/lib/maas/samba/win2012r2/boot/$i $i;done
	```

7.  Edit the default cluster and enable DHCP and DNS on the interface where you will be serving DHCP (see the screenshot as an example).
	
	Open `http://<maas-server-ip>/MAAS/clusters/` in a browser; **eth1** is most probably the one that needs to be configured.
	
	Example:
		
	>*Router IP = eth1's IP*
	>*IP = eth1's IP*
	>![Screenshot](http://wiki.cloudbase.it/_media/screen_shot_2014-04-23_at_01.27.08.png)
		

8. Set upstream DNS:

	Open `http://<maas-server-ip>/MAAS/settings/` in a browser.
	Look for "Upstream DNS used to resolve domains not managed by this MAAS" and set the dns to something like 8.8.8.8

9. Add a ssh key for authentification to the nodes
	
	Generate a key:
		```bash
		ssh-keygen -t rsa
		cat ~/.ssh/id_rsa.pub
		```
	
	Copy the output.
	
	Open `http://<maas-server-ip>/MAAS/account/prefs/sshkey/add/` and paste the contents.

10. If you are working on Vmware workstation/ESXI server you will need a power adapter so that MAAS can power on and off the VM's

	```bash
	git clone https://github.com/trobert2/maas-hacks
	git fetch origin
	git checkout -b new_poweradapter origin/new_poweradapter
	cd maas-hacks/vmware
	```

	*Note:* In the install file on the line that does `cp "$BASEDIR/vmware.template" ~/maas/etc/maas/templates/power/` you need to replace "~/maas/etc/maas/templates/power/" with "etc/maas/templates/power/"
	The diff has to patch these two files:
	/usr/lib/python2.7/dist-packages/provisioningserver/power_schema.py
	/usr/lib/python2.7/dist-packages/maasserver/models/node.py


