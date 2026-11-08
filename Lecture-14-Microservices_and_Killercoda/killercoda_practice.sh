#!/bin/bash
# ==============================================================================
# SWCON221 Lecture 14 - Microservices and Killercoda Practice (Steps 1 ~ 4)
# ==============================================================================

echo "=========================================="
echo "1단계: Create a Kubernetes cluster"
echo "=========================================="
kubectl version
kubectl cluster-info
kubectl get nodes

echo -e "\n=========================================="
echo "2단계: Deploy an app"
echo "=========================================="
kubectl get nodes
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
sleep 5
kubectl get deployments

# Proxy 백그라운드 구동 (테스트용)
kubectl proxy --port=8001 &
PROXY_PID=$!
sleep 2

curl http://localhost:8001/version

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo "Name of the Pod: $POD_NAME"

# Pod 메타데이터 JSON 및 웹서버 응답 확인
curl -s http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/ | head -n 20
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME:8080/proxy/

echo -e "\n=========================================="
echo "3단계: Explore your app"
echo "=========================================="
kubectl get pods
kubectl describe pods "$POD_NAME"
kubectl logs "$POD_NAME"
kubectl exec "$POD_NAME" -- env

echo "--- Check container internal server.js and local curl ---"
kubectl exec "$POD_NAME" -- cat server.js
kubectl exec "$POD_NAME" -- curl -s http://localhost:8080

echo -e "\n=========================================="
echo "4단계: Expose your app publicly"
echo "=========================================="
kubectl get services
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
kubectl get services
kubectl describe services/kubernetes-bootcamp

export NODE_PORT="$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')"
echo "NODE_PORT=$NODE_PORT"

# 3가지 접근 경로 확인
ENDPOINT_IP=$(kubectl get endpoints kubernetes-bootcamp -o jsonpath='{.subsets[0].addresses[0].ip}')
CLUSTER_IP=$(kubectl get service kubernetes-bootcamp -o jsonpath='{.spec.clusterIP}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "1) Endpoints IP ($ENDPOINT_IP:8080):"
curl http://$ENDPOINT_IP:8080
echo "2) Cluster IP ($CLUSTER_IP:8080):"
curl http://$CLUSTER_IP:8080
echo "3) Node IP ($NODE_IP:$NODE_PORT):"
curl http://$NODE_IP:$NODE_PORT

echo -e "\n--- Labeling practice ---"
kubectl get pods -l app=kubernetes-bootcamp
kubectl label pods "$POD_NAME" version=v1
kubectl get pods -l version=v1

echo -e "\n--- Delete Service and Check Isolation ---"
kubectl delete service -l app=kubernetes-bootcamp
kubectl get services

echo "External access check (should fail or timeout):"
curl --connect-timeout 3 http://$NODE_IP:$NODE_PORT || echo "Connection failed as expected!"

echo "Internal container health check (should succeed):"
kubectl exec "$POD_NAME" -- curl -s http://localhost:8080

# Clean up proxy
kill $PROXY_PID 2>/dev/null || true
