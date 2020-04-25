# Demo Packer
A demo Packer usage and templates.

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
|    |____ubuntu14.04.json  
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

TODO

### Creating a VMware vSphere template

TODO

### Creating an Amazon AMI

TODO

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