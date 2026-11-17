#!/bin/bash
# ==============================================================================
# SWCON221 Lecture 16 - Controllers & ReplicaSet Practice Script
# ==============================================================================

echo "=========================================="
echo "Part 1: Multi-Container Pod Practice (simple-pod.yaml)"
echo "=========================================="

echo ">>> 1-1. Initial Cluster Status"
kubectl get all

echo -e "\n>>> 1-2. Apply simple-pod.yaml"
kubectl apply -f simple-pod.yaml

echo -e "\n>>> 1-3. Waiting for Pod to be Ready (2/2 Containers)"
sleep 5
kubectl get all

echo -e "\n>>> 1-4. Execute Shell in 'nginx' Container"
kubectl exec -it my-little-pod -c nginx -- uname -a

echo -e "\n>>> 1-5. Check Redis Server Version in 'redis' Container"
kubectl exec -it my-little-pod -c redis -- redis-server --version

echo -e "\n>>> 1-6. Delete Multi-Container Pod"
kubectl delete -f simple-pod.yaml
kubectl get all

echo -e "\n=========================================="
echo "Part 2: ReplicaSet Practice (simple-replicaset.yaml)"
echo "=========================================="

echo ">>> 2-1. Apply simple-replicaset.yaml (replicas: 3)"
kubectl apply -f simple-replicaset.yaml

echo -e "\n>>> 2-2. Check Created ReplicaSet and Pods"
sleep 5
kubectl get all
kubectl get rs
kubectl describe rs/my-replicaset

echo -e "\n>>> 2-3. Inspect One of the Replicated Pods"
FIRST_POD=$(kubectl get pods -l app=my-little-pod -o jsonpath='{.items[0].metadata.name}')
echo "Selected Pod: $FIRST_POD"
kubectl get pod "$FIRST_POD" -o yaml | head -n 35

echo -e "\n>>> 2-4. Execute Commands inside Replicated Pod"
kubectl exec -it "$FIRST_POD" -c nginx -- uname -a
kubectl exec -it "$FIRST_POD" -c redis -- redis-server --version

echo -e "\n>>> 2-5. Test Self-Healing: Delete a Pod and Observe Auto-Recreation"
echo "Deleting pod $FIRST_POD..."
kubectl delete pod "$FIRST_POD"

echo "Checking cluster state immediately after deletion:"
kubectl get pods

echo -e "\n>>> 2-6. Label Selector Filtering"
echo "[Selector: app=my-little-pod]"
kubectl get pod,replicaset,deployment --selector app=my-little-pod

echo -e "\n[Selector: app=my-replicaset]"
kubectl get pod,replicaset,deployment --selector app=my-replicaset

echo -e "\n>>> 2-7. Cleanup ReplicaSet"
kubectl delete -f simple-replicaset.yaml
kubectl get all
