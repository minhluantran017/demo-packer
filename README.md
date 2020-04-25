# Demo Packer
A demo Packer usage and templates.

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
|____packer-<builder>       \\ Contains JSON templates specific for each builder (vsphere-iso, amazon-ebs,...)
|    |____ubuntu1404.json  
|    |____centos7.json    
|____scripts                \\ Contains shell/python/powershell scripts
|    |____*.sh
|    |____*.py
|____files                  \\ Contains other files 
|    |____*.txt
|    |____*.cfg
|____licences               \\ Contains licenses
|    |____*.lic
|____Jenkinsfile            \\ Jenkinsfile for CI/CD
|____README.md
```

### Creating a VirtualBox OVA

This code creates an OVA file and optionally a Vagrant box for Virtualbox.
You need to have VirtualBox (and Vagrant if needed) installed on your machine.

This code is tested with Packer v1.5.5, VirtualBox 4.3.40.

The default SSH username/password of built image can be found in preseed/kickstart/... file.
You should change it or use SSH key instead for security.

```shell
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

The output artifacts will be in `packer-virtualbox-iso/output-<build_number>` directory.
You should upload it to artifactory.

### Creating a VMware vSphere template

This code is tested with Packer v1.5.5, ESXi/vCenter v6.5.

The default SSH username/password of built image can be found in preseed/kickstart/... file.
You should change it or use SSH key instead for security.

```shell
# Choose base OS for your image, eg:
export BASE_OS=ubuntu1404
export BUILD_NUMBER=01

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

# Inspect the template to look at template information if you want:
packer inspect ./$BASE_OS.json

# Build the image:
packer build ./$BASE_OS.json

```

### Creating an Amazon AMI

This code creates an AMI backed by an EBS snapshot on your AWS account.

This code is tested with Packer v1.5.5.

You should have AWS account first, and have Access key and Secret key properly configured.
You can do this by either:
* Use environment variables:
```shell
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```

* Use AWS profile:
```shell
mkdir -p $HOME/.aws
cat >> $HOME/.aws/credentials <<EOF
[default]
aws_access_key_id=anaccesskey
aws_secret_access_key=asecretkey
EOF
```

The default region is `us-east-1`. The subnet and security group used for Packer must have these tags:
```
"namespace" : "devops",
"project"   : "demo",
"ispublic"  : "true"
```

The default SSH username/password of built image can be found in preseed/kickstart/... file.
You should change it or use SSH key instead for security.

```shell
# Choose base OS for your image, eg:
export BASE_OS=ubuntu1404
export BUILD_NUMBER=01

cd packer-amazon-ebs

# Validate template to eliminate syntax errors:
packer validate ./$BASE_OS.json

# Inspect the template to look at template information if you want:
packer inspect ./$BASE_OS.json

# Build the image:
packer build ./$BASE_OS.json

```

### Creating an OpenStack QCOW2 image 

TODO

## 3. Code of Conduct

- Create branch for each component from `master` with convention: `dev_<component>`.
For example: `dev_vsphere-iso`.

- Please always create Pull Request to merge it to `master`. Only merge if all the tests pass.

## 4. Licenses

Packer is under MPL2 licence. See [licenses](licences)

## 5. TODO

* N/A