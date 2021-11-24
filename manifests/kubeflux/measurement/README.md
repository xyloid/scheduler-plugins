# Experiment on a Remote Cluster

## Overview

- related repositories:
    - flux-k8s:
        - `git@github.com:xyloid/flux-k8s.git`
        - branch: `dev_operator`
        - provides pi test docker images
            - `docker pull xuyilindocker/pi:latest`
            - `docker pull xuyilindocker/pi-segfault:latest`
    - flux-sched:
        - `git@github.com:xyloid/flux-sched.git`
        - branch: `measurement-dev`
        - time measurement in cpp code and go binding
        
    - scheduler-plugins:
        - `git@github.com:xyloid/scheduler-plugins.git`
        - branch: `dev-kubeflux-measurement`
        - `docker pull xuyilindocker/kubeflux:latest`
        - scripts for the experiment
            - setup connection
            - deploy kubeflux
            - run pi test


## Connect to Remote Cluster

- setup cluster [link](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
- use specified cluster [link](https://newbedev.com/configure-kubectl-command-to-access-remote-kubernetes-cluster-on-azure)

```bash
$ kubectl config --kubeconfig=ocp-perf-cluster.yaml set-cluster remote-cluster

$ kubectl describe nodes --kubeconfig=ocp-perf-cluster.yaml

$ kubectl get nodes --kubeconfig=ocp-perf-cluster.yaml

```

### A Simpler Way

Back up the current `~/.kube/config` file, then copy the content in `ocp-perf-cluster.yaml` to `config` file.

### Remove master label (could be optional in other cases)

- [link](https://stackoverflow.com/questions/34067979/how-to-delete-a-node-label-by-command-and-api)

```bash
kubectl label node 10.240.64.5 node-role.kubernetes.io/master- --kubeconfig=ocp-perf-cluster.yaml
```

## Run Pi Test with Default Scheduler

```bash
cd $PROJECT_ROOT/manifests/kubeflux/measurement

kubectl create -f ./pi-job-default.yaml 
```

## Install Kubeflux

```bash
cd $PROJECT_ROOT/manifests/kubeflux/charts

# install
helm install scheduler-plugins

# uninstall
helm uninstall scheduler-plugins

```

## Run Pi Test with Kubeflux

```bash
cd $PROJECT_ROOT/manifests/kubeflux/measurement

kubectl create -f ./pi-job-kubeflux.yaml 
```