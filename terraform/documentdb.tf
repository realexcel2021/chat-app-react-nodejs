
# subnet group for the document database
resource "aws_docdb_subnet_group" "default" {
  name       = "db-subnet-group"
  subnet_ids = module.vpc.database_subnets

  tags = {
    Name = "Snappy-DB-subnet-group"
  }
}

# the database cluster 

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "docdb"
  master_username         = "snappydb"
  master_password         = aws_secretsmanager_secret_version.password.secret_string
  backup_retention_period = 1
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_docdb_subnet_group.default.name
}

# the database instance to associate to the cluster

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.docdb_count
  identifier         = "snappy-cluster-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.docdb_class
}

