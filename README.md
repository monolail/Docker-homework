# SWCON221 Microservice Programming - Docker & Kubernetes Practice

경희대학교 소프트웨어융합대학 **마이크로서비스 프로그래밍(SWCON221)** Docker 및 Kubernetes 실습 과제 저장소입니다.

각 강의노트(Lecture 06 ~ Lecture 19)의 내용 및 과제 요구사항에 맞추어 실제 실습을 완료한 코드, 설정 파일, 실행 스크립트, 실행 콘솔 결과 로그, 그리고 실습 인증 스크린샷을 정리하였습니다.

---

## 📁 디렉토리 구조 및 구성 파일

```plaintext
Docker-homework/
├── Lecture-06-Docker_Overview/
│   ├── Lecture-06-Docker_Overview.pdf           # 강의노트
│   ├── docker_test_drive.sh                     # Ubuntu, Alpine, Python 컨테이너 실습 스크립트
│   └── execution_log.txt                        # 실제 실행 콘솔 로그
│
├── Lecture-07-Docker_Hub_and_Dockerfile/
│   ├── Lecture-07-Docker_Hub_and_Dockerfile.pdf      # 강의노트
│   ├── Dockerfile                               # Python 애플리케이션 이미지 빌드 명세
│   ├── myapp.py                                 # Python 실습 애플리케이션
│   ├── .dockerignore                            # 불필요한 빌드 컨텍스트 제외 설정
│   ├── run.sh                                   # 이미지 빌드 및 컨테이너 실행 스크립트
│   └── execution_log.txt                        # 빌드 및 실행 콘솔 로그
│
├── Lecture-08-Build_and_Push_Images/
│   ├── Lecture-08-Build_and_Push_Images.pdf      # 강의노트
│   ├── Dockerfile                               # 경량 Web Server 이미지 빌드 명세
│   ├── webserver.py                             # 소켓 기반 Python HTTP 웹서버 (Port 9000)
│   ├── build_and_push.sh                        # 빌드, 로컬 테스트 및 Docker Hub 푸시 스크립트
│   └── execution_log.txt                        # 빌드/테스트 및 Hub 푸시 콘솔 로그
│
├── Lecture-09-Docker_Compose/
│   ├── Lecture-09-Docker_Compose.pdf            # 강의노트
│   ├── docker-compose.yml                       # Manager(Alpine) + Worker(Nginx) 멀티 컨테이너 명세
│   ├── run_compose.sh                           # Compose 서비스 기동, 검증 및 종료 스크립트
│   └── execution_log.txt                        # Compose 실행 및 HTTP 응답 검증 로그
│
├── Lecture-10-Docker_Storage/
│   ├── Lecture-10-Docker_Storage.pdf            # 강의노트
│   ├── storage_practice.sh                      # 볼륨 생성, Jenkins 마운트 및 영속성 테스트 스크립트
│   └── execution_log.txt                        # 볼륨 생성/검사 및 데이터 영속성 확인 콘솔 로그
│
├── Lecture-14-Microservices_and_Killercoda/
│   ├── Lecture-14-Microservices_and_Killercoda.pdf   # 강의노트
│   ├── killercoda_summary.md                    # 1~4단계 명령어 및 실습 핵심 요약
│   ├── killercoda_설명대본.docx                  # 녹화 및 발표용 설명 대본 문서
│   ├── killercoda_practice.sh                   # 1~4단계 전체 실습 자동화 및 검증 스크립트
│   └── execution_log.txt                        # Killercoda 환경 실제 실행 콘솔 로그
│
├── Lecture-16-Controllers/
│   ├── Lecture-16-Controllers.pdf               # 강의노트
│   ├── simple-pod.yaml                          # Nginx + Redis 멀티 컨테이너 Pod 매니페스트
│   ├── simple-replicaset.yaml                   # 3개 복제본 유지를 위한 ReplicaSet 매니페스트
│   ├── practice_controllers.sh                  # Pod 및 ReplicaSet 자가 치유 실습 스크립트
│   ├── execution_log.txt                        # 자가 치유 및 라벨 셀렉터 검증 콘솔 로그
│   └── screen/                                  # 실습 단계별 인증 스크린샷 7장
│
├── Lecture-17-Kubernetes_Objects_and_kubectl_Commands/
│   ├── Lecture-17-Kubernetes_Objects_and_kubectl_Commands.pdf # 강의노트
│   ├── simple-deployment.yaml                   # Nginx + Redis 3개 복제본 Deployment 매니페스트
│   ├── README.md                                # 실습 절차 및 검증 상세 설명
│   └── screen/                                  # 실습 단계별 인증 스크린샷 7장
│
├── Lecture-18-Services/
│   ├── Lecture-18-Services.pdf                  # 강의노트
│   ├── two-replicas-with-label.yaml             # eva-west & eva-east 2개 Deployment 매니페스트
│   ├── simple-service.yaml                      # 라벨 셀렉터 기반 NodePort Service 매니페스트
│   ├── clusterip_example.yaml                   # ClusterIP 예제 매니페스트
│   ├── nodeport_example.yaml                    # NodePort 예제 매니페스트
│   ├── README.md                                # 실습 절차 및 라우팅/DNS 검증 설명
│   └── screen/                                  # 실습 단계별 인증 스크린샷 5장
│
└── Lecture-19-Images_and_Registries/
    ├── Lecture-19-Images_and_Registries.pdf     # 강의노트
    ├── README.md                                # 실습 절차 및 exec/라벨링 검증 설명
    └── screen/                                  # 실습 단계별 인증 스크린샷 7장
```

---

## 📌 강의별 실습 상세 내용

### 1. `Lecture-06-Docker_Overview` (Docker 기본 및 Test-Drive)
* **목표**: Docker CLI 기본 동작 이해 및 OS 컨테이너(Ubuntu, Alpine, Python) 생명주기 실습
* **주요 명령어 및 과업**:
  * `docker run hello-world` 기본 동작 확인
  * Ubuntu 컨테이너 백그라운드 구동 및 `/bin/bash` 셸 진입(`uname -a`, `ls -la`)
  * Alpine Linux 컨테이너 백그라운드 구동 및 `/bin/ash` 셸 진입
  * Python 컨테이너 구동 및 버전/코드 인터랙티브 실행

### 2. `Lecture-07-Docker_Hub_and_Dockerfile` (Dockerfile 기초)
* **목표**: `Dockerfile` 작성을 통한 나만의 컨테이너 이미지(`myapp`) 빌드 및 실행
* **주요 명령어 및 과업**:
  * `python:3-slim` 기반의 Dockerfile 작성 및 작업 디렉토리(`/app`) 설정
  * `myapp.py` 파일 복사 및 실행 명령(`CMD`) 정의
  * `docker build -t myapp .`로 커스텀 이미지 빌드
  * `docker run -it --rm --name py3 myapp`로 컨테이너 구동 및 반복문 출력 확인

### 3. `Lecture-08-Build_and_Push_Images` (이미지 빌드 및 배포)
* **목표**: Web Server 컨테이너 이미지 빌드, 로컬 서비스 검증 및 Docker Hub 원격 레지스트리 배포
* **주요 명령어 및 과업**:
  * Python 소켓 기반의 경량 HTTP 웹서버(`webserver.py`, Port 9000) 구현
  * Dockerfile 작성 및 메타데이터(`LABEL maintainer`) 명시
  * `docker run -d -p 9000:9000` 백그라운드 구동 후 `curl`을 통한 HTTP 200 OK 응답 확인
  * Docker Hub 원격 리포지토리(`monolail/mywebserver:1.0`)로 이미지 태깅 및 `docker push`

### 4. `Lecture-09-Docker_Compose` (멀티 컨테이너 오케스트레이션)
* **목표**: `docker-compose.yml`을 활용하여 다중 컨테이너 서비스를 정의하고 일괄 제어
* **주요 명령어 및 과업**:
  * Alpine 기반의 `manager` 서비스와 Nginx 기반의 `worker1`(Port 8001:80), `worker2`(Port 8002:80) 정의
  * `docker compose config`를 통한 문법 및 서비스 구조 검증
  * `docker compose up -d`로 공통 브리지 네트워크와 3개 서비스 컨테이너 생성 및 기동
  * 포트 8001 및 8002로 HTTP 요청을 전송하여 정상 서비스 응답 확인

### 5. `Lecture-10-Docker_Storage` (Docker 볼륨 및 데이터 영속성)
* **목표**: Docker 명명된 볼륨(`Named Volume`)을 생성하고, 컨테이너 재생성 시에도 데이터가 보존되는 영속성 검증
* **주요 명령어 및 과업**:
  * `docker volume create myvol-1`로 전용 볼륨 생성 및 `docker volume inspect` 상세 확인
  * Jenkins 컨테이너(`jenkins/jenkins:lts`)에 볼륨 마운트 (`-v myvol-1:/var/jenkins_home`)
  * 초기 관리자 비밀번호(`initialAdminPassword`) 생성 및 설치 구성 상태 확인
  * 기존 컨테이너를 중지/삭제한 후, 동일한 `myvol-1` 볼륨을 새 복제 컨테이너(`jenkins-production-copy`)에 연결하여 데이터가 그대로 유지됨을 검증
  * 실습 종료 후 볼륨 및 리소스 정리

### 6. `Lecture-14-Microservices_and_Killercoda` (쿠버네티스 & Killercoda 실습)
* **목표**: Killercoda 인터랙티브 환경에서 Kubernetes 기본 컴포넌트(Node, Deployment, Pod, Service)의 생성, 프록시 통신, 탐색 및 NodePort 외부 노출 실습
* **주요 명령어 및 과업**:
  * **1단계 (클러스터 확인)**: `kubectl version`, `cluster-info`, `get nodes`로 controlplane 노드 상태 확인
  * **2단계 (앱 배포 및 프록시)**: `kubectl create deployment kubernetes-bootcamp`, `kubectl proxy`, 로컬 8001 프록시 및 API를 통한 Pod 접근 검증
  * **3단계 (앱 탐색 및 디버깅)**: `kubectl describe pods`, `kubectl logs`, `kubectl exec -ti ... -- bash` 셸 진입 후 `server.js` 소스 및 내부 curl 응답 확인
  * **4단계 (서비스 노출 및 레이블링)**: `kubectl expose deployment ... --type="NodePort"`, NodePort 및 Endpoints/ClusterIP 접속 테스트, `kubectl label pods`로 레이블 추가 및 필터링, 서비스 삭제 후 외부 접속 차단 및 파드 내부 통신 지속 검증

### 7. `Lecture-16-Controllers` (컨트롤러 및 ReplicaSet 자가 치유 실습)
* **목표**: Multi-Container Pod 및 ReplicaSet을 직접 작성·배포하고, 파드 장애 시 컨트롤러가 파드 수를 자동으로 복구하는 자가 치유(Self-Healing) 및 라벨 셀렉터 실습 (실제 실습 캡처 포함)
* **주요 명령어 및 과업**:
  * **Part 1 (멀티 컨테이너 Pod)**: `simple-pod.yaml`을 직접 작성하여 Nginx + Redis + shared volume(`emptyDir`)으로 구성된 Pod를 배포하고, `kubectl exec`를 통해 각 컨테이너 내부 환경 및 redis 버전을 개별 확인
  * **Part 2 (ReplicaSet & 자가 치유)**: `simple-replicaset.yaml`을 작성하여 3개의 파드 복제본(`replicas: 3`)을 배포하고, 임의의 파드 1개를 강제 삭제(`kubectl delete pod`)했을 때 ReplicaSet 컨트롤러가 즉각 새로운 파드를 생성하여 3개를 유지하는 자가 치유 기능 검증
  * **Part 3 (라벨 셀렉터 조회 및 정리)**: `--selector app=my-little-pod`, `--selector app=my-replicaset` 옵션을 통해 라벨 기반 리소스 필터링을 실습하고 전체 리소스 정리
  * **실습 인증 스크린샷**: `screen/` 폴더 내에 실습 과정 캡처 이미지(7장) 수록

### 8. `Lecture-17-Kubernetes_Objects_and_kubectl_Commands` (Deployment 및 외부 서비스 노출)
* **목표**: Deployment 리소스 생성, NodePort Service 노출 및 Port-forwarding을 통한 외부 접근성 검증, 파드별 가상 IP 할당 구조 확인
* **주요 명령어 및 과업**:
  * `simple-deployment.yaml` 적용으로 3개 복제본(Nginx + Redis) 배포
  * `kubectl describe deployment` 및 `kubectl get deployments/pods`로 배포 상태 검증
  * `kubectl expose deployment`로 NodePort(포트 8080 -> 컨테이너 80) 서비스 생성 및 파드 엔드포인트 자동 연결 확인
  * `kubectl port-forward service/my-nodeport 8080:8080` 포워딩 후 `curl`을 통해 HTTP 200 OK Nginx 환영 응답 확인
  * `kubectl get pods --output=wide`를 통한 파드별 내부 가상 IP 주소 및 노드 매핑 확인
  * **실습 인증 스크린샷**: `screen/` 폴더 내에 실습 과정 캡처 이미지(7장) 수록

### 9. `Lecture-18-Services` (라벨 셀렉터 라우팅 및 클러스터 내부 DNS)
* **목표**: Label Selector에 따른 정밀 트래픽 분기, CoreDNS 기반 Service Discovery 동작 검증, 컨테이너 로그 비교를 통한 라우팅 검증
* **주요 명령어 및 과업**:
  * `two-replicas-with-label.yaml` 배포로 `eva-west`(2개) 및 `eva-east`(2개) 디플로이먼트 구동 후 `-l app=eva`, `-l release=west/east` 라벨 필터링 조회
  * `simple-service.yaml`(`selector: {app: eva, release: west}`) 배포 후 `describe svc eva`를 통해 오직 `west` 파드 2개의 IP만 엔드포인트로 등록됨을 검증
  * `port-forward`를 통한 서비스 접근 및 HTTP 정상 응답 확인
  * 임시 `alpine` 디버그 Pod 구동 후 클러스터 내부 도메인 이름(`curl http://eva/`)을 통한 CoreDNS 기반 서비스 디스커버리 검증
  * `kubectl logs`로 `release=west` 파드에만 GET 요청 로그가 적재되고 `release=east`에는 요청이 도달하지 않음을 교차 검증
  * **실습 인증 스크린샷**: `screen/` 폴더 내에 실습 과정 캡처 이미지(5장) 수록

### 10. `Lecture-19-Images_and_Registries` (원격 레지스트리 이미지 배포 및 파드 운영)
* **목표**: Google Container Registry(GCR) 이미지 기반 Deployment 배포, `exec` 셸을 통한 내부 점검 및 로컬 통신 테스트, 동적 라벨링 및 셀렉터 쿼리
* **주요 명령어 및 과업**:
  * `gcr.io/google-samples/kubernetes-bootcamp:v1` 이미지로 Deployment 생성 및 파드 기동 점검
  * `kubectl logs`를 통한 Node.js 애플리케이션 시작 로그 확인
  * `kubectl exec -ti ... -- bash`로 파드 내부 접속 후 `server.js` 소스코드 확인 및 로컬 8080 포트 HTTP 통신 검증
  * `kubectl expose`로 NodePort 서비스 생성 및 서비스 엔드포인트 바인딩 확인
  * `kubectl describe pod`로 메타데이터 확인 후, `kubectl label pod`로 신규 라벨(`Release=v1`) 동적 부여 및 `-l Release=v1` 필터링 쿼리
  * **실습 인증 스크린샷**: `screen/` 폴더 내에 실습 과정 캡처 이미지(7장) 수록
