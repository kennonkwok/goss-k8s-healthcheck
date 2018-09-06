# goss-k8s-healthcheck
Quick and easy healthcheck for kubernetes clusters

## Introduction

### What is Goss?
Goss (http://goss.rocks) is a YAML based serverspec alternative tool for validating a server’s configuration. It eases the process of writing tests by allowing the user to generate tests from the current system state. Once the test suite is written they can be executed, waited-on, or served as a health endpoint.

### What is goss-k8s-healthcheck?
goss-k8s-healthcheck is a starting point for deploying goss to a kubernetes cluster for running `kubectl` commands for inspecting a running cluster. Additionally, it exposes a small webservice that returns the healthcheck results in JSON format via the `/healthz` endpoint.

## Usage

### configuration
This repo includes a `goss-configmap.yaml` with a sample configuration.  The image is preconfigured with goss and the deployment manifest creates a service account with a limited role for making read-only API requests.  To customize the health checks, edit the configmap.

    apiVersion: v1
    data:
      goss.yaml: |
        command:
          kubectl cluster-info:
            exit-status: 0
            stderr: []
            timeout: 3000
          kubectl get componentstatus:
            exit-status: 0
            stderr: []
            timeout: 3000
          kubectl get nodes:
            exit-status: 0
            stderr: []
            timeout: 3000
          kubectl get pods --all-namespaces:
            exit-status: 0
            stderr: []
            timeout: 3000
    kind: ConfigMap
    metadata:
      name: goss-configmap
      namespace: goss

### using `goss-deployment`
    kubectl apply -f goss-deployment.yaml

This will set up the namespace, serviceaccount, role, and service for the goss healthcheck. Edit as needed to change deployment details or allow more permissions in the role.