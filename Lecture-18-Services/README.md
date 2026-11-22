# Lecture 18: Services

Kubernetes Service의 핵심 기능인 라벨 셀렉터(`Label Selector`) 기반 트래픽 라우팅, 클러스터 내부 DNS 기반 Service Discovery, 그리고 로그 조회를 통한 라우팅 검증 실습입니다.

## 파일 구성

* `two-replicas-with-label.yaml`: 서로 다른 라벨(`release: west`, `release: east`)을 가진 2개의 Deployment 매니페스트 (총 4개 Pod)
* `simple-service.yaml`: `app: eva, release: west` 라벨만을 타겟으로 선별 연결하는 NodePort Service 매니페스트
* `clusterip_example.yaml`: ClusterIP 실습 예제 매니페스트
* `nodeport_example.yaml`: NodePort 실습 예제 매니페스트
* `Lecture-18-Services.pdf`: 강의 자료
* `screen/`: 실습 단계별 터미널 수행 및 검증 캡처 이미지 (5장)

---

## 실습 내용 및 인증 스크린샷

### 1. 라벨이 부여된 2개의 Deployment 배포 및 조회 (`two-replicas-with-label.yaml`)

`app: eva` 공통 라벨을 가지되, 각각 `release: west`와 `release: east`로 분리된 2개의 Deployment(각 2개 replica)를 배포합니다.

#### 1) 배포 및 라벨 셀렉터 기반 Pod 필터링
```bash
kubectl apply -f two-replicas-with-label.yaml
kubectl get pods -l app=eva
kubectl get pods -l release=west
kubectl get pods -l release=east
```
* `-l app=eva`로 총 4개 Pod(`eva-west` 2개, `eva-east` 2개)를 조회하고, `-l release=east`로 특정 릴리스 라벨을 가진 Pod만 선별 조회할 수 있음을 확인합니다.

![라벨 필터링 조회](screen/스크린샷%202026-11-22%20180821.png)

---

### 2. 라벨 셀렉터 기반 Service 배포 및 엔드포인트 바인딩 (`simple-service.yaml`)

`selector: { app: eva, release: west }`로 정의된 Service `eva`를 생성하여, 전체 4개의 Pod 중 `west` 라벨을 가진 2개의 Pod로만 서비스가 바인딩되는지 검증합니다.

```bash
kubectl apply -f simple-service.yaml
kubectl describe svc eva
```
* `Endpoints` 항목에 `east` 파드는 제외되고, `release: west` 파드의 IP(`10.244.0.10:80, 10.244.0.11:80`)만 엔드포인트로 등록된 것을 확인합니다.

![Service 엔드포인트 바인딩 확인](screen/스크린샷%202026-11-22%20180918.png)

---

### 3. Port-Forward를 통한 외부 접근 검증

```bash
kubectl port-forward service/eva 8080:80
curl http://localhost:8080
```
* 로컬 포트 8080을 서비스 `eva`의 80 포트로 포워딩한 후 전송한 HTTP 요청에 대해 Nginx 웹서버가 HTTP 200 OK로 정상 응답함을 확인합니다.

![포트포워딩 curl 접속 확인](screen/스크린샷%202026-11-22%20180955.png)

---

### 4. 클러스터 내부 DNS Service Discovery 테스트 (Alpine Pod)

클러스터 내부의 독립된 디버그 Pod에서 IP 주소가 아닌 서비스 이름(`eva`) 자체로 통신이 가능한지(Kubernetes 내장 CoreDNS 동작)를 검증합니다.

```bash
kubectl run -i -t --rm debug --image=alpine:latest --restart=Never -- sh
apk add curl
curl http://eva/
exit
```
* 별도의 IP 설정 없이도 서비스 이름 `http://eva/`만으로 서비스 discovery가 수행되어 Nginx 환영 페이지를 수신함을 확인합니다.

![내부 DNS Discovery 검증](screen/스크린샷%202026-11-22%20181041.png)

---

### 5. Nginx 액세스 로그 비교를 통한 라우팅 검증

트래픽이 Service의 라벨 셀렉터 설정대로 `west` 파드로만 전달되고 `east` 파드로는 전혀 전달되지 않았는지 양측의 로그를 비교합니다.

```bash
kubectl logs -l app=eva -l release=west -c nginx
kubectl logs -l app=eva -l release=east -c nginx
```
* `release: west` 파드에는 `GET / HTTP/1.1 200` 요청 기록(로컬 curl 및 alpine pod curl)이 적재된 반면, `release: east` 파드에는 웹 요청 기록이 전무함을 확인함으로써 라벨 기반 트래픽 격리를 완벽히 검증하였습니다.

![로그 비교 라우팅 검증](screen/스크린샷%202026-11-22%20181113.png)

---

### 6. 실습 리소스 정리

```bash
kubectl delete -f simple-service.yaml
kubectl delete -f two-replicas-with-label.yaml
kubectl get pods
```
* 생성된 Service와 2개의 Deployment를 일괄 삭제하여 리소스를 정리합니다.
