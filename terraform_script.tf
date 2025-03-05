provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "container_registry" {
  provider      = google
  location      = var.region
  repository_id = var.repo_name
  format        = "DOCKER"

  description = "Docker container registry repository"
}

resource "google_artifact_registry_repository_iam_binding" "artifact_registry_permission" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.container_registry.repository_id

  role       = "roles/artifactregistry.writer" # Allows pushing images

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

resource "google_artifact_registry_repository_iam_binding" "artifact_registry_reader_permission" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.container_registry.repository_id

  role       = "roles/artifactregistry.reader" # Allows pulling images

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

resource "null_resource" "docker_push_combined" {
  depends_on = [
    google_artifact_registry_repository.container_registry
  ]
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = "export GOOGLE_APPLICATION_CREDENTIALS=\"${path.module}/terraform-key.json\" && gcloud auth activate-service-account --key-file=\"${path.module}/terraform-key.json\" && gcloud auth configure-docker us-central1-docker.pkg.dev --quiet && docker build -t compound-interest-api . && docker tag compound-interest-api us-central1-docker.pkg.dev/${var.project_id}/${var.repo_name}/app:v1 && docker push us-central1-docker.pkg.dev/${var.project_id}/${var.repo_name}/app:v1"
  }
}

resource "google_cloud_run_service" "compound_interest_api" {
  depends_on = [null_resource.docker_push_combined]
  name       = "compound-interest-api"
  location   = var.region

  template {
    spec {
      service_account_name = "terraform-service-account@aisl-443021.iam.gserviceaccount.com"
      containers {
        image = "us-central1-docker.pkg.dev/${var.project_id}/${var.repo_name}/app:v1"
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_policy" "public_access" {
  location    = google_cloud_run_service.compound_interest_api.location
  service     = google_cloud_run_service.compound_interest_api.name

  policy_data = <<EOT
{
  "bindings": [
    {
      "role": "roles/run.invoker",
      "members": ["allUsers"]
    }
  ]
}
EOT
}

# Define Variables
variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Region where the registry should be created"
  type        = string
  default     = "us-central1"
}

variable "repo_name" {
  description = "Name of the container registry repository"
  type        = string
  default     = "compount-interest-api"
}

variable "service_account_email" {
  description = "Service account email for Cloud Run"
  type        = string
  default     = "terraform-service-account@aisl-443021.iam.gserviceaccount.com"
}