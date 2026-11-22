# Lecture 17: Kubernetes Objects and kubectl Commands

Kubernetes의 핵심 컨트롤러인 Deployment를 생성하고, NodePort Service 및 Port-forwarding을 통해 클러스터 외부에서 애플리케이션으로 접근하는 과정과 각 Pod의 가상 IP 할당 구조를 검증한 실습입니다.

## 파일 구성

* `simple-deployment.yaml`: Nginx 및 Redis 컨테이너와 emptyDir 볼륨을 포함하는 3개 복제본(replicas: 3) Deployment 매니페스트
* `Lecture-17-Kubernetes_Objects_and_kubectl_Commands.pdf`: 강의 자료
* `screen/`: 실습 단계별 터미널 수행 및 검증 캡처 이미지 (7장)

---

## 실습 내용 및 인증 스크린샷

### 1. Deployment 배포 및 상태 확인 (`simple-deployment.yaml`)

Nginx(Port 80)와 Redis 컨테이너로 구성된 파드 3개를 관리하는 Deployment를 생성하고 배포 상태를 점검합니다.

#### 1) Deployment 매니페스트 적용 및 상세 정보 확인
```bash
kubectl apply -f simple-deployment.yaml
kubectl describe deployment my-deployment
```
* Deployment의 메타데이터, 레이블(`app=my-deployment-example`), 파드 템플릿(Nginx, Redis) 및 RollingUpdate 전략 상태를 확인합니다.

![Deployment 상세 정보](screen/스크린샷%202026-11-22%20180136.png)

#### 2) Pod 구동 상태 확인
```bash
kubectl get pods
```
* 3개의 Pod(`my-deployment-5cfd49d7c8-...`)가 모두 `2/2` Ready 및 `Running` 상태로 정상 기동되었음을 확인합니다.

![Pod 구동 상태](screen/스크린샷%202026-11-22%20180216.png)

#### 3) Deployment 요약 상태 확인
```bash
kubectl get deployments
```
* `READY` 컬럼에 `3/3`, `UP-TO-DATE`에 `3`, `AVAILABLE`에 `3`이 표시되어 목표 상태와 현재 상태가 일치함을 확인합니다.

![Deployment 상태 확인](screen/스크린샷%202026-11-22%20180224.png)

---

### 2. NodePort Service를 통한 외부 노출

Deployment를 외부에 서비스하기 위해 NodePort 타입의 서비스를 생성합니다.

#### 1) NodePort Service 생성 및 서비스 목록 확인
```bash
kubectl expose deployment my-deployment --type=NodePort --name=my-nodeport --port 8080 --target-port=80
kubectl get svc
```
* Service `my-nodeport`가 타입 `NodePort`로 생성되었으며, ClusterIP `10.96.177.248`, 포트 매핑 `8080:30216/TCP`로 구성되었음을 확인합니다.

![Service 생성 및 목록 확인](screen/스크린샷%202026-11-22%20180309.png)

#### 2) Service 엔드포인트 상세 확인
```bash
kubectl describe svc my-nodeport
```
* `Endpoints` 항목에 실행 중인 3개 Pod의 IP 및 타겟 포트(`10.244.0.5:80, 10.244.0.6:80, 10.244.0.7:80`)가 자동으로 연결되었음을 검증합니다.

![Service 엔드포인트 확인](screen/스크린샷%202026-11-22%20180328.png)

---

### 3. Port-Forward 및 웹 서비스 접속 테스트

로컬 8080 포트를 `my-nodeport` 서비스의 8080 포트로 포워딩하여 HTTP 웹 요청을 테스트합니다.

```bash
kubectl port-forward service/my-nodeport 8080:8080
curl http://localhost:8080
```
* 포트포워딩 후 전송된 HTTP 요청에 대해 Nginx 컨테이너로부터 `StatusCode : 200` 및 `<title>Welcome to nginx!</title>` HTML 본문이 정상적으로 반환됨을 확인합니다.

![curl 접속 테스트](screen/스크린샷%202026-11-22%20180432.png)

---

### 4. Pod 내부 가상 IP 주소 확인

```bash
kubectl get pods --output=wide
```
* `--output=wide` 옵션으로 파드별 가상 IP 할당 현황(`10.244.0.5`, `10.244.0.6`, `10.244.0.7`)과 노드(`desktop-control-plane`) 배치를 확인합니다.

![Pod 내부 IP 확인](screen/스크린샷%202026-11-22%20180449.png)

---

### 5. 실습 리소스 정리

```bash
kubectl delete deployment my-deployment
kubectl delete service my-nodeport
kubectl get pods
```
* 실습을 마친 후 생성된 Deployment와 Service를 삭제하여 클러스터 자원을 반환합니다.
