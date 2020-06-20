# Demo Packer
A demo Packer usage and templates.

![](https://img.shields.io/static/v1?label=Packer%20version&message=v1.6.0&color=blue)
![](https://github.com/minhluantran017/demo-packer/workflows/Validate%20templates/badge.svg)

## 1. Installation

```shell
PACKER_VER=`curl -sS https://releases.hashicorp.com/packer/ | grep href | head -2 | tail -1 | awk -F/ '{print $3}'`
curl -o packer.zip https://releases.hashicorp.com/packer/${PACKER_VER}/packer_${PACKER_VER}_linux_amd64.zip
unzip packer.zip
sudo mv packer /usr/local/bin/packer
rm -f packer.zip
packer version
```

## 2. Getting Started

Check out source code:
```shell
git clone https://github.com/minhluantran017/demo-packer.git
cd demo-packer
```

Code structure:
```
.
|____packer-<builder>       // Contains templates specific for each builder (vsphere-iso, amazon-ebs,...)
|    |____*.json                // JSON templates (old format)
|    |____*.pkr.hcl             // HCL2 templates (new format)
|____scripts                // Contains Bash/Python/PowerShell scripts
|    |____*.sh
|    |____*.py
|    |____*.ps1
|____files                  // Contains other files 
|    |____*.txt
|    |____*.cfg
|____README.md
```

### Creating a VirtualBox OVA

This code creates an OVA file and optionally a Vagrant box for Virtualbox.
You need to have VirtualBox (and Vagrant if needed) installed on your machine.

The default SSH username/password of built image can be found in preseed/kickstart/... file.
You should change it or use SSH key instead for security.

This code was tested with Packer v1.6.0 (except Vagrant post-processor in HCL).

```sh
# Choose base OS for your image, eg:
export BASE_OS=ubuntu1404
export BUILD_NUMBER=01

# Validate template to eliminate syntax errors:
packer validate ./$BASE_OS.json

# Inspect the template to look at template information if you want:
packer inspect ./$BASE_OS.json

# Build the image (along with Vagrant box):
packer build ./$BASE_OS.json

# If you don't need Vagrant box:
packer build -except=vagrant-box ./$BASE_OS.json

```

The output artifact will be in `packer-virtualbox-iso/output-<build_number>` directory.
You should upload it to artifactory.

### Creating a VMware vSphere template

This code is tested with Packer v1.5.5, ESXi/vCenter v6.5.

The default SSH username/password of built image can be found in preseed/kickstart/... file.
You should change it or use SSH key instead for security.

```sh
# Choose base OS for your image, eg:
BASE_OS=ubuntu1404

# Input VMware vSphere information:
cd packer-vsphere-iso
sed -i "s/SED_VSPHERE_VCENTER/vcenter.example.com/" ./$BASE_OS.json
sed -i "s/SED_VSPHERE_HOST/esxi-1.example.com/" ./$BASE_OS.json
sed -i "s/SED_VSPHERE_USERNAME/user/" ./$BASE_OS.json
sed -i "s/SED_VSPHERE_PASSWORD/password/" ./$BASE_OS.json
sed -i "s/SED_VSPHERE_DATACENTER/datacenter1/" ./$BASE_OS.json
sed -i "s/SED_VSPHERE_CLUSTER/cluster1/" ./$BASE_OS.json
sed -i "s/SED_VSPHERE_DATASTORE/datastore1/" ./$BASE_OS.json
sed -i "s/SED_VSPHERE_NETWORK/Network1/" ./$BASE_OS.json

# Validate template to eliminate syntax errors:
packer validate ./$BASE_OS.json

# Build the image:
packer build ./$BASE_OS.json

```

### Creating an Amazon AMI

TODO

### Creating an OpenStack QCOW2 image 

TODO

## 3. HCL2 configuration

All Packer HCL2 templates in this repo need Packer v1.6.0 and later to run.

## 4. Code of Conduct

- Create branch for each component from `master` with convention: `dev_<component>`.
For example: `dev_vsphere-iso`.

- Please always create Pull Request to merge it to `master`. Only merge if all the tests pass.

## 5. TODO

* Add VMX data to vsphere-iso builder (eg. enable nested virtualization)
* N/A