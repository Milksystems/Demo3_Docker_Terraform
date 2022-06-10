resource "aws_ecr_repository" "aws-ecr" {
  name = "ecr"
  tags = {
    Name  = "ecr"
  }
}

resource "null_resource" "build" {
  provisioner "local-exec" {
    working_dir = "C:/Users/foolg/OneDrive/Desktop/New folder/app"
    command = "make build"
    environment = {
      TAG               = var.image_tag
      REPO_REGION       = var.region
      ECR_REPO_URL      = var.ecr_repository_url
    }
  }
}