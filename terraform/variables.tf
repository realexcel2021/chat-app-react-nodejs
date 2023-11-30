# deployment region
variable "region" {
  type = string
}

# project tags
variable "tags" {
  type = object({
  })
}

# project name
variable "project_name" {
  type = string
}

# subnet group for database subnet tags
variable "database_subnet_group_name" {
  type = string
}

# VPC cidr block
variable "vpc_cidr" {
  type = string
}

# public subnets cidr blocks
variable "public_subnets" {
  type = list(string)
}

# private subnet cidr blocks for both clusters
variable "private_subnets" {
  type = list(string)
}

# subnet cidr blocks for database subnets
variable "database_subnets" {
  type = list(string)
}

# list of avaliablilty zones
variable "azs" {
  type = list(string)
}

# tags for private subnets
variable "private_subnet_tags" {
  type = object({
  })
}

# tags for public subnets
variable "public_subnet_tags" {
  type = object({
  })
}

# s3 bucket for the frontend
variable "frontend_bucket_name" {
  type = string
}

# identifier for the database
variable "cluster_identifier" {
  type = string
}

# number of document db intance
variable "docdb_count" {
  type = number
}

# instance class of the docdb cluster
variable "docdb_class" {
  type = string
}