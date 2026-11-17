# Lecture 16: Controllers

Kubernetes 컨트롤러 및 ReplicaSet의 동작 원리와 Multi-Container Pod 구성을 검증하기 위한 실습입니다.

## 파일 구성

* `simple-pod.yaml`: Nginx 및 Redis 컨테이너와 emptyDir 공유 볼륨을 포함하는 Multi-Container Pod 매니페스트
* `simple-replicaset.yaml`: 3개의 복제본 파드를 유지하도록 정의된 ReplicaSet 매니페스트
* `practice_controllers.sh`: 실습 재현용 명령어 스크립트
* `execution_log.txt`: 터미널 명령어 실행 결과 콘솔 로그
* `screen/`: 단계별 실습 수행 및 검증 캡처 이미지 (7장)
* `Lecture-16-Controllers.pdf`: 강의 자료

## 실습 내용 및 명령어

### 1. Multi-Container Pod 실습 (`simple-pod.yaml`)
* Nginx(Port 80)와 Redis 컨테이너가 동일 Pod 내에서 실행되며, `emptyDir` 볼륨(`redis-storage`)을 공유하도록 구성.
* 배포 및 상태 확인:
  ```bash
  kubectl apply -f simple-pod.yaml
  kubectl get all
  ```
  `READY` 항목이 `2/2`로 전환되어 두 컨테이너가 모두 정상 구동됨을 확인.
* 컨테이너별 개별 접근 및 검증:
  ```bash
  kubectl exec -it my-little-pod -c nginx -- uname -a
  kubectl exec -it my-little-pod -c redis -- redis-server --version
  ```
* 리소스 정리:
  ```bash
  kubectl delete -f simple-pod.yaml
  ```

### 2. ReplicaSet 및 자가 치유(Self-Healing) 실습 (`simple-replicaset.yaml`)
* 복제본 3개(`replicas: 3`)를 선언하고 `app: my-little-pod` 라벨을 감시하도록 설정.
* 배포 및 확인:
  ```bash
  kubectl apply -f simple-replicaset.yaml
  kubectl get rs
  kubectl get pods
  ```
* 자가 치유 동작 검증:
  ```bash
  kubectl delete pod <POD_NAME>
  kubectl get pods
  ```
  임의의 파드 1개를 강제 삭제한 직후, ReplicaSet 컨트롤러가 선언된 상태(3개)를 유지하기 위해 즉시 새 파드를 생성함을 확인.
* 라벨 셀렉터 조회:
  ```bash
  kubectl get pods -l app=my-little-pod
  kubectl get rs -l app=my-replicaset
  ```
* 리소스 정리:
  ```bash
  kubectl delete -f simple-replicaset.yaml
  ```
