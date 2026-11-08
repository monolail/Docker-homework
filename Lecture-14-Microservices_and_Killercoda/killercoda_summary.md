# Killercoda Kubernetes 실습 정리 (1~4단계)

Killercoda 쿠버네티스 플레이그라운드 환경에서 수행한 실습 단계별 명령어 및 설명 정리 문서입니다.

---

## 1단계: Create a Kubernetes cluster (클러스터 생성 및 확인)
* **목표**: 이미 구성된 Killercoda 클러스터 상태 및 노드 확인
* **실행 명령어**:
  ```bash
  kubectl version
  kubectl cluster-info
  kubectl get nodes
  ```

---

## 2단계: Deploy an app (애플리케이션 배포)
* **목표**: 구글 샘플 컨테이너 배포 및 프록시를 통한 파드 통신 확인
* **실행 명령어**:
  ```bash
  # 1. 노드 준비 확인 및 디플로이먼트 생성
  kubectl get nodes
  kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
  kubectl get deployments

  # 2. [Tab 2] 백그라운드 프록시 실행
  kubectl proxy

  # 3. [Tab 1] 프록시 API 버전 확인
  curl http://localhost:8001/version

  # 4. 파드 이름 환경변수 등록 및 확인
  export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
  echo Name of the Pod: $POD_NAME

  # 5. 파드 메타데이터 JSON 확인
  curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/

  # 6. 프록시를 통해 파드 내부 웹서버 직접 요청 (Hello Kubernetes bootcamp! 확인)
  curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME:8080/proxy/
  ```

---

## 3단계: Explore your app (애플리케이션 탐색 및 디버깅)
* **목표**: 파드 상태, 로그, 환경변수 확인 및 컨테이너 내부 대화형 셸 접속
* **실행 명령어**:
  ```bash
  # 1. 파드 상태 및 상세 정보 확인
  kubectl get pods
  kubectl describe pods

  # 2. 파드 이름 환경변수 확인 및 프록시 재확인
  export POD_NAME="$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')"
  echo Name of the Pod: $POD_NAME
  curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME:8080/proxy/

  # 3. 파드 컨테이너 표준 출력 로그 확인
  kubectl logs "$POD_NAME"

  # 4. 컨테이너 내부 환경변수 확인
  kubectl exec "$POD_NAME" -- env

  # 5. 파드 컨테이너 내부 bash 접속 및 Node.js 코드 확인
  kubectl exec -ti $POD_NAME -- bash
  # [컨테이너 내부]
  cat server.js
  curl http://localhost:8080
  exit
  ```

---

## 4단계: Expose your app publicly (서비스 외부 노출 및 레이블 실습)
* **목표**: NodePort 서비스 생성, 외부 접속 테스트, 레이블링 및 서비스 삭제 후 격리 검증
* **실행 명령어**:
  ```bash
  # 1. 현재 파드 및 서비스 목록 확인
  kubectl get pods
  kubectl get services

  # 2. NodePort 타입으로 서비스 노출
  kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
  kubectl get services
  kubectl describe services/kubernetes-bootcamp

  # 3. 할당된 NodePort 확인
  export NODE_PORT="$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')"
  echo "NODE_PORT=$NODE_PORT"

  # 4. 3가지 방식을 통한 HTTP 접속 테스트
  # 1) Endpoints IP:8080
  curl $(kubectl get endpoints kubernetes-bootcamp -o jsonpath='{.subsets[0].addresses[0].ip}'):8080
  # 2) Cluster IP:8080
  curl $(kubectl get service kubernetes-bootcamp -o jsonpath='{.spec.clusterIP}'):8080
  # 3) Node IP:$NODE_PORT
  curl $(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'):$NODE_PORT

  # 5. 레이블(Label) 조회 및 추가
  kubectl describe deployment
  kubectl get pods -l app=kubernetes-bootcamp
  kubectl get services -l app=kubernetes-bootcamp

  export POD_NAME="$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')"
  echo "Name of the Pod: $POD_NAME"

  # version=v1 레이블 추가
  kubectl label pods "$POD_NAME" version=v1
  kubectl describe pods "$POD_NAME"
  kubectl get pods -l version=v1

  # 6. 서비스 삭제 및 격리 상태 검증
  kubectl delete service -l app=kubernetes-bootcamp
  kubectl get services

  # 외부 접속 실패 확인 (연결 거부)
  curl $(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'):$NODE_PORT

  # 파드 자체는 여전히 정상 동작 중임을 확인
  kubectl exec -ti $POD_NAME -- curl http://localhost:8080
  ```
