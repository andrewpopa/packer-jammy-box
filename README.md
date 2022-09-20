# packer-jammy-box
Packer box for Jammy-Jellyfish (Ubuntu 22.04.1 LTS) for VirtualBox and AWS

#  Pre-requirements
- [Packer](https://www.packer.io/)
- [Virtualbox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- [AWS account](https://aws.amazon.com/console/)


```shell
git clone git@github.com:andrewpopa/packer-jammy-box.git
cd packer-jammy-box
```

validate packer configuration

```
packer validate .
```

build the boxes

```shell
packer build .
```

add newly created box to vagrant list

```shell
vagrant box add --name jammy64 --provider virtualbox jammy64_0.1.box
```

In case you want to build just one of the two existing boxes, you can do it

- just for virtualbox

```shell
packer build -only=virtualbox-iso.virtualbox .
```

- just for aws

```shell
packer build -only=amazon-ebs.aws .
```

AWS box is based on the existing AWS AMI for the Ubuntu 22.04.1 LTS - `ami-052efd3df9dad4825`

use Vagrant Cloud to store the images

make sure you are logged in

```shell
vagrant cloud auth login
```

upload created box for virtulabox

```shell
vagrant cloud publish apopa/jammy64 0.1 virtualbox jammy64_0.1.box \
-d "Jammy64 minimal" \
--version-description "Jammy64 minimal" \
--release --short-description "Jammy64 minimal" --force
```

then you can consume it from the internet directly

```shell
vagrant init -m apopa/jammy64
vagrant up --provider virtualbox
```