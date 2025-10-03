resource "aws_ecr_repository" "backend_repo" {
  name = "${var.project_name}-backend"
}
