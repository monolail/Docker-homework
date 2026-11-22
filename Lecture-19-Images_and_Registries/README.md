# Lecture 19: Images and Registries

공개 컨테이너 레지스트리(Google Container Registry, GCR)의 이미지를 활용한 Deployment 생성, 컨테이너 내부 환경 디버깅(`logs`, `exec`), NodePort Service 생성, 그리고 동적 레이블 부여 및 셀렉터 필터링을 검증한 실습입니다.

## 파일 구성

* `Lecture-19-Images_and_Registries.pdf`: 강의 자료
* `screen/`: 실습 단계별 터미널 수행 및 검증 캡처 이미지 (7장)

---

## 실습 내용 및 인증 스크린샷

### 1. 레지스트리 이미지 기반 Deployment 생성 (`gcr.io`)

Google Samples 레지스트리에 호스팅된 `kubernetes-bootcamp:v1` 이미지를 사용하여 Deployment를 생성합니다.

```bash
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
kubectl get deployments
kubectl get pods
```
* Deployment가 생성되고, Pod `kubernetes-bootcamp-66d5c96cb-66bkg`가 `ContainerCreating` 단계를 거쳐 구동 준비되는 상태를 확인합니다.

![Deployment 생성 및 Pod 상태](screen/스크린샷%202026-11-22%20181407.png)

---

### 2. Pod 로그 확인

```bash
kubectl logs kubernetes-bootcamp-66d5c96cb-66bkg
```
* 컨테이너 내부 Node.js 애플리케이션의 시작 로그(`Kubernetes Bootcamp App Started At: ... | Running On: ...`)를 확인합니다.

![Pod 시작 로그 확인](screen/스크린샷%202026-11-22%20181523.png)

---

### 3. 컨테이너 내부 셸 접속(`exec`) 및 소스코드/로컬 통신 검증

인터랙티브 셸(`bash`)로 Pod 컨테이너 내부에 직접 접속하여 소스코드를 점검하고 로컬 HTTP 요청을 테스트합니다.

```bash
kubectl exec -ti kubernetes-bootcamp-66d5c96cb-66bkg -- bash
cat server.js
curl http://localhost:8080
exit
```
* `cat server.js`: Node.js 기반의 경량 HTTP 서버 소스코드를 확인합니다.
* `curl http://localhost:8080`: 내부 웹서버로부터 `Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-... | v=1` 응답이 정상 출력됨을 확인합니다.

![컨테이너 내부 셸 접속 및 curl 검증](screen/스크린샷%202026-11-22%20181611.png)

---

### 4. NodePort Service 노출 및 서비스 검사

Deployment를 NodePort 서비스로 노출하여 클러스터 외부 접근 경로를 생성합니다.

```bash
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
kubectl get services
kubectl describe services/kubernetes-bootcamp
```
* Service `kubernetes-bootcamp`가 생성되었으며, NodePort `31906` 포트 및 타겟 엔드포인트(`10.244.0.13:8080`)가 정상 바인딩되었음을 확인합니다.

![Service 생성 및 엔드포인트 확인](screen/스크린샷%202026-11-22%20181648.png)

---

### 5. Pod 상세 정보 점검

```bash
kubectl describe pod kubernetes-bootcamp
```
* 실행 중인 파드의 상세 메타데이터, IP(`10.244.0.13`), 이미지 다이제스트, 상태 및 라이프사이클 이벤트를 확인합니다.

![Pod 상세 정보](screen/스크린샷%202026-11-22%20181728.png)

---

### 6. 동적 Label 부여 및 Label Selector 필터링

실행 중인 기존 Pod에 새로운 라벨(`Release=v1`)을 실시간으로 추가하고, 해당 라벨을 조건으로 필터링 조회를 수행합니다.

#### 1) 라벨 추가
```bash
kubectl label pod kubernetes-bootcamp-66d5c96cb-66bkg Release=v1
```
* 기존 파드에 `Release=v1` 라벨이 성공적으로 적용되었음을 확인합니다.

![라벨 추가](screen/스크린샷%202026-11-22%20181845.png)

#### 2) 라벨 셀렉터 조회
```bash
kubectl get pods -l Release=v1
```
* `-l Release=v1` 옵션으로 쿼리했을 때 해당 라벨이 부여된 파드가 필터링되어 출력됨을 확인합니다.

![라벨 기반 파드 조회](screen/스크린샷%202026-11-22%20181859.png)

---

### 7. 실습 리소스 정리

```bash
kubectl delete service kubernetes-bootcamp
kubectl delete deployment kubernetes-bootcamp
kubectl get pods
```
* 실습에 사용된 서비스 및 디플로이먼트를 완전히 삭제하고 클러스터 리소스를 정리합니다.
