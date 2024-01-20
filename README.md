> ## NOTICE to mentors
> I've had error with default kind_cluster module and flux `Kubernetes version v1.25.3 does not match >=1.26.0-0`.
> So I've spent some time and created my own module
> [github.com/dkzippa/tf-kind-cluster](https://github.com/dkzippa/tf-kind-cluster). 
> Now it works correctly.
>


# Terraform Flux on Kind cluster

This Terraform module creates Kind culster, deploys Flux on it. 
Flux deploys Kbot App with Helm and promotions all changes to the same cluster


## Preparation steps:
- set aliases
    - `alias k='kubectl'`
    - `alias tf=terraform`

- install fluxcd cli from https://fluxcd.io/flux/cmd/


## Local cluster usage with Kind:

- check plan:
    - `export TF_VAR_GITHUB_OWNER=...`
    - `tf plan -var GITHUB_TOKEN=...` # ! not in exported variable TF_VAR_GITHUB_TOKEN, as it is sensitive data
- apply:
    - `tf apply -var GITHUB_TOKEN=...` 

- check flux deployed and running correctly:    
    - `k get all -A`
    - `alias k-flux='k --kubeconfig .terraform/modules/kind_cluster/kind-config -n flux-system'`
    - `k-flux get po -w`
    - `k-flux get all`

- check all is correct 
    - `flux get all`
    - `flux logs -f`

- add secret to application
    - `k create secret generic kbot -n kbot-demo --from-literal=token=...`

- create ns for the app
    - add ns.yaml to flux repo in clusters/kbot-demo folder
    ```yaml
    apiVersion: v1
    kind: Namespace
    metadata:
    name: kbot-demo
    ```
    - run reconcile faster than default 10m `flux reconcile source git flux-system`

- create resources Source and Helm Release
    - `flux create source git kbot --url=https://github.com/dkzippa/prometheus-kbot --branch=main --namespace=kbot-demo --export`
    - add content to clusters/kbot-demo/kbot-gr.yaml

    - `flux create helmrelease kbot --source=GitRepository/kbot --chart="./helm" --interval=1m --namespace=kbot-demo --export`
    - add content to clusters/kbot-demo/kbot-hr.yaml

    - check all with `flux logs -f`

    - 
    








# TODO:
1) pass from TF to Flux repo a) Git source and 2) HelmRelease files
2) pass from -var(or TF_VAR_) to Flux kbot secret to create it in Kubernetes (`flux create secret ...`)
...
