# Chart to run Kubeflux scheduler plugin as a second scheduler in a local cluster

This charts is intended to install kubeflux scheduler to a local kind cluster with local registry (this is documented in kind documentation).

The `../../init_kind_cluster.sh` the script that creates a local kind cluster and a local registry. By default it will create one master and one worker node.



## Steps

### 1. Start kind cluser

```bash
./init_kind_cluster.sh
```

### 2 Build local image and push it to local registry

```bash

make local-image

docker push localhost:5000/scheduler-plugins/kube-scheduler

```

### Deploy by Helm

The default Helm charts from scheduler-plugins need to be modified.

- `values.yaml`: change the `image` of `scheduler` to local image `localhost:5000/scheduler-plugins/kube-scheduler`
- `templates/deployment.yaml`: change command, it can be copied from `kubesched.yaml` from `flux-k8s/exmaples/pi`


```bash
helm install scheduler-plugins ./as-a-second-scheduler/
```

