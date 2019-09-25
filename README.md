# ws2019

## What is this project about?

`ws2019` is a set of configuration files used to build automated Windows Server 2019 virtual machine images using [Packer](https://www.packer.io/).
This Packer configuration file allows you to build images for VMware Workstation and Oracle VM VirtualBox.

## Prerequisites

* [Packer](https://www.packer.io/downloads.html) to run the build process
* [VMware ESXI](https://www.vmware.com/de/products/esxi-and-esx.html) to build on
* [VMware OVF Tool](https://www.vmware.com/support/developer/ovf/) to create the OVA from the generated VM

## Build process

* Unattended installation of WS2019 Datacenter Eval version (Desktop experience) from downloaded ISO file
* Installation of VMware tools from ISO provided from the build ESX server
* Updating OS via Windows Update
* Export VM and package as OVA file

## HowTo

### Prepare Build ESX Server

* Default ESXi installation
* Enable SSH service
* Configure guest IP hack via SSH: 
  ```sh
  esxcli system settings advanced set -o /Net/GuestIPHack -i 1
  ```

### Prepare Build Host

* Install Packer
* Install VMware OVA Tool

### Configure Build Variables

There are some variables which can or must be changed before building at the top of the `ws2019-gui.json` file.
You can overwrite these variables in the file, in a variable file or via commandline.

See the [Packer documentation on user variables](https://www.packer.io/docs/templates/user-variables.html) for details.

- **"iso_url"**\
By default the .iso of Windows Server 2019 is pulled from Microsoft server.\
You can change the URL to one closer to your build server. 

### How to use Packer

To create a Windows Server 2019 VM image using a vSphere ESX host:

```sh
cd <path-to-git-root-directory>
packer build ws2019-gui.json
```

Wait for the build to finish to find the generated OVA file in the `output-vmware-iso` folder.

## Default credentials

The default credentials for this VM image are:

| Username      | Password    |
|---------------|-------------|
| Administrator | `Passw0rd.` |

## Implementation Details

- Sleep at 1st provisioner because Windows is doing another reboot first

## Resources

- [packer-Win2019](https://github.com/eaksel/packer-Win2019) (used as a base for this work - big kudos!)
- Repo contains VMware's drivers for paravirtual devices (`pvscsi` and `vmxnet3`)