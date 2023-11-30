
# Deployment region
region = "us-west-2"

# VPC CIDR block
vpc_cidr = "10.0.0.0/16"

# public subnets cidr for both load balancers
public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

# private subnet cidr for both clusters
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

# private subnet cide for data base
database_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

# availability zones for the subnets
azs = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]

# database subnet group name

database_subnet_group_name = "snappy-db"

# project name

project_name = "Snappy"

# project tags
tags = {
  Project = "Snappy",
}

# public subnet tags
public_subnet_tags = {
  Name = "Snappy-Pub-Subnets"
}

# private subnets tags
private_subnet_tags = {
  Name = "Snappy-PVT-subnets"
}

# s3 bucket for the frontend
frontend_bucket_name = "snappy-frontend-223223"

# identifier for the database
cluster_identifier = "snappy-db"

# number of docdb instance
docdb_count = 1

# docdb instance class
docdb_class = "db.t3.medium"