# Lecture 16: Controllers

Kubernetes 컨트롤러 및 ReplicaSet의 동작 원리와 Multi-Container Pod 구성을 검증하기 위한 실습입니다.

## 파일 구성

* `simple-pod.yaml`: Nginx 및 Redis 컨테이너와 emptyDir 공유 볼륨을 포함하는 Multi-Container Pod 매니페스트
* `simple-replicaset.yaml`: 3개의 복제본 파드를 유지하도록 정의된 ReplicaSet 매니페스트
* `practice_controllers.sh`: 실습 재현용 명령어 스크립트
* `execution_log.txt`: 터미널 명령어 실행 결과 콘솔 로그
* `screen/`: 단계별 실습 수행 및 검증 캡처 이미지 (7장)
* `Lecture-16-Controllers.pdf`: 강의 자료

---

## 실습 내용 및 인증 스크린샷

### 1. Multi-Container Pod 실습 (`simple-pod.yaml`)

Nginx(Port 80)와 Redis 컨테이너가 동일 Pod 내에서 실행되며, `emptyDir` 볼륨(`redis-storage`)을 공유하도록 매니페스트를 작성하고 배포합니다.

#### 1) Pod 배포 및 상태 확인
```bash
kubectl apply -f simple-pod.yaml
kubectl get all
```
* `READY` 컬럼이 `0/2`에서 `2/2`로 전환되어 두 컨테이너가 모두 정상 구동됨을 확인합니다.

![Pod 생성 상태](screen/스크린샷%202026-11-17%20131343.png)

#### 2) Nginx 컨테이너 셸 접속 및 내부 확인
```bash
kubectl exec -it my-little-pod -c nginx -- sh
uname -a
exit
```
* `-c nginx` 옵션으로 Nginx 컨테이너 내부 셸에 진입하여 커널 및 OS 정보를 확인합니다.

![Nginx 컨테이너 내부 확인](screen/스크린샷%202026-11-17%20131430.png)

#### 3) Redis 컨테이너 버전 확인
```bash
kubectl exec -it my-little-pod -c redis -- redis-server --version
```
* `-c redis` 옵션으로 Redis 컨테이너에 접근하여 서버 버전(v=8.10.3)을 확인합니다.

![Redis 컨테이너 버전 확인](screen/스크린샷%202026-11-17%20131501.png)

#### 4) Multi-Container Pod 삭제
```bash
kubectl delete -f simple-pod.yaml
```

---

### 2. ReplicaSet 및 자가 치유(Self-Healing) 실습 (`simple-replicaset.yaml`)

복제본 3개(`replicas: 3`)를 선언하고 `app: my-little-pod` 라벨을 감시하는 ReplicaSet을 배포하여 컨트롤러의 상태 유지 능력을 검증합니다.

#### 1) ReplicaSet 배포
```bash
kubectl apply -f simple-replicaset.yaml
```

![ReplicaSet 생성](screen/스크린샷%202026-11-17%20131620.png)

#### 2) ReplicaSet 및 Pod 목록 확인
```bash
kubectl get rs
kubectl get pods
```
* ReplicaSet의 `DESIRED`, `CURRENT`, `READY`가 모두 3으로 표시되며, 3개의 Pod(`my-replicaset-574qn`, `gbnwr`, `t6w8z`)가 Running 상태임을 확인합니다.

![ReplicaSet 및 Pod 목록](screen/스크린샷%202026-11-17%20131640.png)

#### 3) 파드 강제 삭제를 통한 자가 치유(Self-Healing) 검증
```bash
kubectl delete pod my-replicaset-gbnwr
```
* 실행 중인 3개의 파드 중 하나(`my-replicaset-gbnwr`)를 강제로 삭제합니다.

![파드 강제 삭제](screen/스크린샷%202026-11-17%20131708.png)

#### 4) 자동 복구(부활) 및 라벨 셀렉터 조회 확인
```bash
kubectl get pods -l app=my-little-pod
```
* 파드가 삭제된 직후 ReplicaSet 컨트롤러가 선언된 개수(3개)를 충족하기 위해 새로운 파드(`my-replicaset-9l4pj`)를 15초 전에 자동 생성하여 총 3개의 파드를 그대로 유지하고 있음을 검증합니다.

![새 파드 자동 복구 확인](screen/스크린샷%202026-11-17%20131722.png)

#### 5) 리소스 전체 삭제 및 정리
```bash
kubectl delete -f simple-replicaset.yaml
kubectl get all
```
* ReplicaSet 컨트롤러 본체를 삭제하여 관리 대상이던 파드 3개까지 모두 정상적으로 완전 종료합니다.
