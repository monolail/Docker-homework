# SWCON221 Microservice Programming - Docker Homework

경희대학교 소프트웨어융합대학 **마이크로서비스 프로그래밍(SWCON221)** Docker 관련 실습 과제 저장소입니다.

강의노트 번호 및 주제 순서에 따라 과제 결과물(소스 코드 및 실습 녹화 영상)을 정리하였습니다.

---

## 📁 과제 디렉토리 구조

```plaintext
Docker-homework/
├── Lecture-06-Docker_Overview/
│   └── lecture6_2022105488_이호준.mp4
│
├── Lecture-07-Docker_Hub_and_Dockerfile/
│   ├── Dockerfile
│   ├── myapp.py
│   └── lecture7_2022105488_이호준.mp4
│
├── Lecture-08-Build_and_Push_Images/
│   ├── Dockerfile
│   ├── webserver.py
│   └── lecture08_2022105488_이호준.mp4
│
├── Lecture-09-Docker_Compose/
│   ├── docker-compose.yml
│   └── lecture09_2022105488_이호준.mp4
│
└── Lecture-10-Docker_Storage/
    └── lecture10_2022105488_이호준.mp4
```

---

## 📌 강의별 과제 세부 내용

### 1. `Lecture-06-Docker_Overview`
* **주제**: Docker 개요 및 기본 환경 실습
* **구성 파일**:
  * `lecture6_2022105488_이호준.mp4`: 실습 시연 녹화 영상

### 2. `Lecture-07-Docker_Hub_and_Dockerfile`
* **주제**: Docker Hub 활용 및 Dockerfile 작성 기초
* **구성 파일**:
  * `Dockerfile`: Python 기반 컨테이너 이미지 빌드 스크립트
  * `myapp.py`: 컨테이너 내부 실행용 Python 애플리케이션
  * `lecture7_2022105488_이호준.mp4`: 실습 시연 녹화 영상

### 3. `Lecture-08-Build_and_Push_Images`
* **주제**: Docker 이미지 빌드 및 Docker Hub 푸시, 웹서버 컨테이너 배포
* **구성 파일**:
  * `Dockerfile`: Python HTTP 웹서버 이미지 빌드 스크립트
  * `webserver.py`: 소켓 기반 파이썬 경량 HTTP 웹서버 코드
  * `lecture08_2022105488_이호준.mp4`: 실습 시연 녹화 영상

### 4. `Lecture-09-Docker_Compose`
* **주제**: Docker Compose를 활용한 다중 컨테이너 환경 구성
* **구성 파일**:
  * `docker-compose.yml`: Manager(Alpine) 및 Worker(Nginx) 다중 컨테이너 서비스 정의 파일
  * `lecture09_2022105488_이호준.mp4`: 실습 시연 녹화 영상

### 5. `Lecture-10-Docker_Storage`
* **주제**: Docker 볼륨 및 스토리지 마운트 실습
* **구성 파일**:
  * `lecture10_2022105488_이호준.mp4`: 실습 시연 녹화 영상

---

> **Note**: 동영상 파일(`.mp4`)은 대용량 파일 관리 도구인 **Git LFS (Large File Storage)**를 통해 버전 관리되고 있습니다.
