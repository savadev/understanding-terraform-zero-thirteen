provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

resource "helm_release" "consul" {
  name       = "hashicorp"
  chart      = "consul"
  repository = "https://helm.releases.hashicorp.com"
  version    = "0.24.1"

  set {
    name  = "global.datacenter"
    value = var.project_name
  }

  set {
    name  = "connectInject.enabled"
    value = true
  }

  set {
    name  = "client.enabled"
    value = true
  }

  set {
    name  = "syncCatalog.enabled"
    value = true
  }

  set {
    name  = "server.disruptionBudget.enabled"
    value = true
  }

  set {
    name  = "server.disruptionBudget.maxEnabled"
    value = 0
  }
}
