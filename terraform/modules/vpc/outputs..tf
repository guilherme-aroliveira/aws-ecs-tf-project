output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main_vpc.id
}

output "public_subnet_1" {
  description = "The ID of the public subnet 1"
  value = aws_subnet.public_subnets["public-subnet-1"].id
}

output "public_subnet_2" {
  description = "The ID of the public subnet 2"
  value = aws_subnet.public_subnets["public-subnet-2"].id
}

output "public_subnet_3" {
  description = "The ID of the public subnet 3"
  value = aws_subnet.public_subnets["public-subnet-3"].id
}