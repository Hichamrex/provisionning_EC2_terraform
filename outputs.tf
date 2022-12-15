output "ec2_public_ip" {
    value = module.server.instance.public_ip
}