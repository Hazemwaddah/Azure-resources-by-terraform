

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = local.resource_group_name
  dns_prefix          = "example-dns-prefix"

  default_node_pool {
    name           = "examplepool"
    node_count     = 2
    vm_size        = "Standard_B2s"
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  linux_profile {
    admin_username = "adminuser"

    ssh_key {
      key_data = file("/home/hazem/Github/Azure_Resources/CodiLime-AKS/Codi_key.pub")
    }
  }  
}

data "azurerm_public_ip" "example" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.example.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.example.node_resource_group
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.example.kube_config.0.host
  username               = azurerm_kubernetes_cluster.example.kube_config.0.username
  password               = azurerm_kubernetes_cluster.example.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "nginx-deployment"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginxdemos/hello:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name = "my-web-app"
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}



/*
resource "kubernetes_ingress" "example" {
  metadata {
    name = "example-ingress"
    namespace = "my-namespace"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "www.example.com"

      http {
        path {
          path = "/testpath"
          backend {
            service_name = "my-service"
            service_port = "80"
          }
        }
      }
    }

    tls {
      hosts = ["www.example.com"]
      secret_name = "example-tls"
    }
  }
}
*/
