variable "build_number" {
    type = string
    default = "1"
}
variable "aws_region" {
    type = string
    default = "us-west-1"
}
# the source block is what was defined in the builders section and represents a
# reusable way to start a machine. You build your images from that source. All
# sources have a 1:1 correspondance to what currently is a builder. The
# argument name (ie: ami_name) must be unquoted and can be set using the equal
# sign operator (=).
source "amazon-ebs" "example" {
    ami_name = "packer-ubuntu1404-${var.build_number}"
    region   = var.aws_region
    instance_type = "t2.micro"

    source_ami_filter {
        filters = {
          virtualization-type = "hvm"
          name =  "*ubuntu-trusty-14.04-amd64-server-*"
          root-device-type = "ebs"
        }
        owners = ["099720109477"]
        most_recent = true
    }
    subnet_filter {
        filters = {
            "tag:namespace" = "devops"
            "tag:project"   = "demo"
            "tag:ispublic"  = "true"
        }
        most_free     = true
        random        = false
    }
    security_group_filter {
        filters = {
            "tag:namespace" = "devops"
            "tag:project"   = "demo"
            "tag:ispublic"  = "true"
        }
    }

    communicator = "ssh"
    ssh_username = "ubuntu"
    ssh_timeout  = "30m"
    user_data_file = "ubuntu_user_data"
    launch_block_device_mappings {
        device_name = "/dev/sda1"
        volume_size = 10
        volume_type = "gp2"
        delete_on_termination = true
    }
    run_tags = {
        Name      = "packer-ubuntu1404-${var.build_number}"
        namespace = "devops"
        project   = "demo"
    }
    tags = {
        Name      = "packer-ubuntu1404-${var.build_number}"
        namespace = "devops"
        project   = "demo"
    }
}

# A build starts sources and runs provisioning steps on those sources.
build {
    sources = [
        # there can be multiple sources per build
        "source.amazon-ebs.example"
    ]

    # All provisioners and post-processors have a 1:1 correspondence to their
    # current layout. The argument name (ie: inline) must to be unquoted
    # and can be set using the equal sign operator (=).
    provisioner "shell" {
        inline = [
            "echo 'Hello, world'"
        ]
    }
    provisioner "file" {
        source = "../files/index.html"
        destination = "/home/ubuntu/index.html"
    }

    # post-processors work too, example: `post-processor "shell-local" {}`.
    post-processor "shell-local" {
        inline = [
            "echo foo"
        ]
    }
}