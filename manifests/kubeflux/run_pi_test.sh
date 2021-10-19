#!/bin/bash

CLUSTER_NAME="xyl-kind"

PROJECT_ROOT=$(git rev-parse --show-toplevel)

echo $PROJECT_ROOT



echo "Step 1: Start kind cluster"

cd $PROJECT_ROOT/flux-k8s/examples/pi/ 

kind delete cluster --name $CLUSTER_NAME

./init_kind_cluster.sh

echo "Step 2: build pi test"

make build-image && make push-image-local



echo "Step 3: Build kubeflux image"

cd $PROJECT_ROOT/

make local-image

docker push localhost:5000/scheduler-plugins/kube-scheduler



echo "Step 4: Install kubeflux"

cd $PROJECT_ROOT/manifests/kubeflux/charts/

helm install scheduler-plugins ./as-a-second-scheduler/ 

echo ""
echo -n "kubeflux is starting"

while true;
do 
    # pay attention to the namespace parameters, it could be changed based on your settings.
    POD_STATUS=`echo $(kubectl get pod -l component=scheduler -n scheduler-plugins -o jsonpath="{.items[0].status.phase}")`
    if [ $POD_STATUS == "Running" ]; 
    then
        echo " kubeflux is running"
        echo ""
        break
    fi
    echo -n " ."
    sleep 1
done

echo ""
echo  "kubeflux podname:" $(kubectl get pod -l component=scheduler -n scheduler-plugins -o jsonpath="{.items[0].metadata.name}")
echo ""



echo "Step 5: Deploy Pi test"

cd $PROJECT_ROOT/flux-k8s/examples/pi/ 

kubectl create -f ./pi-job-default.yaml
kubectl create -f ./pi-job-kubeflux.yaml


# Task 2 

# echo "Step 5: Deploy pi test with default and kubeflux scheduler"

# cd $PROJECT_ROOT/flux-k8s/examples/pi/ 

# kubectl create -f ./pi-job-default.yaml
# kubectl create -f ./pi-job-kubeflux.yaml


INTERVAL=3
COUNT=5

echo ""
echo "Check pods"
echo ""

for i in $(eval echo {1..$COUNT})
do
    sleep $INTERVAL
    echo "check $i"
    kubectl get pods
    echo ""
done