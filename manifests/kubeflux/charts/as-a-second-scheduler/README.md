# Chart to run Kubeflux scheduler plugin as a second scheduler in a local cluster

This charts is intended to install kubeflux scheduler to a local kind cluster with local registry (this is documented in kind documentation).

# Run pi test with one script

The `../../init_kind_cluster.sh` scriptcreates a local kind cluster and a local registry. By default it will create one master and one worker node.


# Run pi test step by step

```bash
  cd scheduler-plugins/manifests/kubeflux/
  ./run_pi_test.sh
```

## Steps

### 1. Start kind cluser

```bash
% scheduler-plugins/manifests/kubeflux/
./init_kind_cluster.sh
```

### 2 Build local image and push it to local registry

```bash
% scheduler-plugins/
make local-image

docker push localhost:5000/scheduler-plugins/kube-scheduler

```

### Deploy by Helm

The default Helm charts from scheduler-plugins need to be modified.

- `values.yaml`: change the `image` of `scheduler` to local image `localhost:5000/scheduler-plugins/kube-scheduler`
- `templates/deployment.yaml`: change command, it can be copied from `kubesched.yaml` from `flux-k8s/exmaples/pi`


```bash
% scheduler-plugins/manifests/kubeflux/charts/
helm install scheduler-plugins ./as-a-second-scheduler/
```

- Note for a 2 nodes cluster, the kubeflux is running on the worker node in namespace `scheduler-plugins`


## Difference between current scheduler-plugins and pre-built image

- `helm install scheduler-plugins ./as-a-second-scheduler/`
    - note the branch was based on `canopie-artifacts`, which could be wrong branch
    - TODO: give main branch a try.
- `quay.io/cmisale/kubeflux:latest`

```log
[JobSpec] JobSpec in YAML:
version: 1
resources:
- type: node
  count: 1
  with:
  - type: socket
    count: 1
    with:
    - type: slot
      count: 1
      label: default
      with:
      - type: core
        count: 8
        with:
        - type: controller-uid
          count: 0
        - type: job-name
          count: 0
        - type: app
          count: 0
attributes:
  system:
    duration: 3600
tasks:
- command: []
  slot: default
  count:
    per_slot: 1

Time elapsed:  0.000327469
Pod cannot be scheduled by KubeFlux, nodename  NONE
```
