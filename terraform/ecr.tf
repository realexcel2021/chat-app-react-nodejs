# Image for the backend application

resource "aws_ecr_repository" "be-repo" {
  name                 = "backend-service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

# Jenkins controller image
resource "aws_ecr_repository" "jenkins-controller-repo" {
  name                 = "jenkins-controller"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

# Jenkins agent image
resource "aws_ecr_repository" "jenkins-agent-repo" {
  name                 = "jenkins-agent"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}
