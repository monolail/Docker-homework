# SWCON221 Microservice Programming - Docker Practice & Homework

경희대학교 소프트웨어융합대학 **마이크로서비스 프로그래밍(SWCON221)** Docker 실습 과제 저장소입니다.

각 강의노트(Lecture 06 ~ Lecture 10)의 내용 및 과제 요구사항에 맞추어 실제 실습을 완료한 코드, 설정 파일, 실행 스크립트, 그리고 실행 콘솔 결과 로그를 정리하였습니다.

---

## 📁 디렉토리 구조 및 구성 파일

```plaintext
Docker-homework/
├── Lecture-06-Docker_Overview/
│   ├── Lecture-06-Docker_Overview.pdf      # 강의노트
│   ├── docker_test_drive.sh                # Ubuntu, Alpine, Python 컨테이너 실습 스크립트
│   └── execution_log.txt                   # 실제 실행 콘솔 로그
│
├── Lecture-07-Docker_Hub_and_Dockerfile/
│   ├── Lecture-07-Docker_Hub_and_Dockerfile.pdf # 강의노트
│   ├── Dockerfile                          # Python 애플리케이션 이미지 빌드 명세
│   ├── myapp.py                            # Python 실습 애플리케이션
│   ├── .dockerignore                       # 불필요한 빌드 컨텍스트 제외 설정
│   ├── run.sh                              # 이미지 빌드 및 컨테이너 실행 스크립트
│   └── execution_log.txt                   # 빌드 및 실행 콘솔 로그
│
├── Lecture-08-Build_and_Push_Images/
│   ├── Lecture-08-Build_and_Push_Images.pdf # 강의노트
│   ├── Dockerfile                          # 경량 Web Server 이미지 빌드 명세
│   ├── webserver.py                        # 소켓 기반 Python HTTP 웹서버 (Port 9000)
│   ├── build_and_push.sh                   # 빌드, 로컬 테스트 및 Docker Hub 푸시 스크립트
│   └── execution_log.txt                   # 빌드/테스트 및 Hub 푸시 콘솔 로그
│
├── Lecture-09-Docker_Compose/
│   ├── Lecture-09-Docker_Compose.pdf       # 강의노트
│   ├── docker-compose.yml                  # Manager(Alpine) + Worker(Nginx) 멀티 컨테이너 명세
│   ├── run_compose.sh                      # Compose 서비스 기동, 검증 및 종료 스크립트
│   └── execution_log.txt                   # Compose 실행 및 HTTP 응답 검증 로그
│
└── Lecture-10-Docker_Storage/
    ├── Lecture-10-Docker_Storage.pdf       # 강의노트
    ├── storage_practice.sh                 # 볼륨 생성, Jenkins 마운트 및 영속성 테스트 스크립트
    └── execution_log.txt                   # 볼륨 생성/검사 및 데이터 영속성 확인 콘솔 로그
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
