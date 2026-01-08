# 빌드 테스트 가이드

## 개요
이 문서는 Docker 컨테이너 내에서 세 개의 테스트 프로젝트 빌드 성공 기준과 예상 출력을 설명합니다.

---

## Docker 환경 시작

### 컨테이너 시작
```bash
docker compose up -d --build
```

### 컨테이너 접속
```bash
docker compose exec dev bash
```

---

## Project 1: React + TypeScript (Vite)

### 기술 스택
- React 19.2.0
- TypeScript 5.9.3
- Vite 7.2.4

### 빌드 명령
```bash
cd /workspace/project1
npm install  # 최초 1회만 필요
npm run build
```

### 빌드 성공 기준

**종료 코드:** `0` (정상 종료)

**예상 출력:**
```
> project1@0.0.0 build
> vite build

vite v7.3.1 building client environment for production...
transforming...
✓ 32 modules transformed.
rendering chunks...
computing gzip size...
dist/index.html                   0.46 kB │ gzip:  0.29 kB
dist/assets/react-CHdo91hT.svg    4.13 kB │ gzip:  2.05 kB
dist/assets/index-COcDBgFa.css    1.38 kB │ gzip:  0.70 kB
dist/assets/index-BWMuc5b_.js   193.91 kB │ gzip: 60.94 kB
✓ built in 693ms
```

**성공 지표:**
- `✓ built in XXXms` 메시지 출력
- `dist/` 디렉토리 생성
- `dist/index.html` 및 `dist/assets/` 파일 생성
- 에러 메시지 없음

**빌드 결과물:**
- `dist/index.html` - 메인 HTML 파일
- `dist/assets/` - JavaScript, CSS, SVG 리소스

---

## Project 2: Java Spring Boot + Gradle

### 기술 스택
- Java 17 (OpenJDK)
- Spring Boot 3.2.1
- Gradle 8.5

### 빌드 명령
```bash
cd /workspace/project2
gradle build
```

### 빌드 성공 기준

**종료 코드:** `0` (정상 종료)

**예상 출력:**
```
Welcome to Gradle 8.5!

Here are the highlights of this release:
 - Support for running on Java 21
 - Faster first use with Kotlin DSL
 - Improved error and warning messages

For more details see https://docs.gradle.org/8.5/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)
> Task :compileJava
> Task :processResources
> Task :classes
> Task :resolveMainClassName
> Task :bootJar
> Task :jar
> Task :assemble
> Task :compileTestJava NO-SOURCE
> Task :processTestResources NO-SOURCE
> Task :testClasses UP-TO-DATE
> Task :test NO-SOURCE
> Task :check UP-TO-DATE
> Task :build

BUILD SUCCESSFUL in 17s
5 actionable tasks: 5 executed
```

**성공 지표:**
- `BUILD SUCCESSFUL in XXs` 메시지 출력
- 모든 Task가 성공적으로 완료 (에러 없음)
- `build/libs/` 디렉토리에 JAR 파일 생성
- 에러 메시지 없음

**빌드 결과물:**
- `build/libs/demo-0.0.1-SNAPSHOT.jar` - 실행 가능한 Spring Boot JAR
- `build/libs/demo-0.0.1-SNAPSHOT-plain.jar` - 일반 JAR

**주요 Task:**
- `:compileJava` - Java 소스 컴파일
- `:processResources` - 리소스 파일 처리
- `:bootJar` - Spring Boot 실행 가능 JAR 생성
- `:build` - 전체 빌드 프로세스

---

## Project 3: Node.js + Express

### 기술 스택
- Node.js 20.19.6
- Express 4.18.2

### 빌드 명령
```bash
cd /workspace/project3
npm install  # 최초 1회만 필요
npm run build
```

### 빌드 성공 기준

**종료 코드:** `0` (정상 종료)

**예상 출력:**
```
> project3@1.0.0 build
> echo 'Build successful'

Build successful
```

**성공 지표:**
- `Build successful` 메시지 출력
- 에러 메시지 없음

**참고:**
- 현재 프로젝트는 간단한 빌드 스크립트를 사용
- 실제 프로덕션 환경에서는 번들링, 트랜스파일링 등이 추가될 수 있음

---

## 공통 빌드 실패 시나리오 및 해결 방법

### 1. 종료 코드가 0이 아닌 경우
- **원인:** 컴파일 에러, 테스트 실패, 의존성 문제
- **해결:** 에러 로그를 확인하고 해당 이슈 수정

### 2. "command not found" 에러
- **원인:** 빌드 도구가 설치되지 않음
- **해결:** Docker 컨테이너가 정상적으로 빌드되었는지 확인

### 3. 의존성 설치 실패
- **원인:** 네트워크 문제, 패키지 저장소 접근 불가
- **해결:** 네트워크 연결 확인, 재시도

### 4. 메모리 부족
- **원인:** Java/Node.js 빌드 시 메모리 부족
- **해결:** Docker 메모리 할당량 증가

---

## 빌드 성공 체크리스트

### Project 1 (React + TypeScript)
- [ ] `npm install` 성공
- [ ] `npm run build` 성공 (종료 코드 0)
- [ ] `✓ built in` 메시지 확인
- [ ] `dist/` 디렉토리 생성 확인
- [ ] 에러 없음

### Project 2 (Java Spring Boot)
- [ ] `gradle build` 성공 (종료 코드 0)
- [ ] `BUILD SUCCESSFUL` 메시지 확인
- [ ] `build/libs/*.jar` 파일 생성 확인
- [ ] 모든 Task 성공
- [ ] 에러 없음

### Project 3 (Node.js + Express)
- [ ] `npm install` 성공
- [ ] `npm run build` 성공 (종료 코드 0)
- [ ] `Build successful` 메시지 확인
- [ ] 에러 없음

---

## 추가 유용한 명령어

### 빌드 결과물 확인
```bash
# Project 1
ls -la /workspace/project1/dist/

# Project 2
ls -la /workspace/project2/build/libs/

# Project 3
ls -la /workspace/project3/src/
```

### 전체 클린 빌드
```bash
# Project 1
cd /workspace/project1 && rm -rf dist node_modules && npm install && npm run build

# Project 2
cd /workspace/project2 && gradle clean build

# Project 3
cd /workspace/project3 && rm -rf node_modules && npm install && npm run build
```

### 빌드 도구 버전 확인
```bash
# Node.js & npm
node --version
npm --version

# Java & Gradle
java -version
gradle --version
```

---

## 성공적인 빌드 배포 기준 요약

| 프로젝트 | 종료 코드 | 주요 성공 메시지 | 결과물 경로 |
|---------|----------|----------------|------------|
| Project 1 | 0 | `✓ built in XXXms` | `dist/` |
| Project 2 | 0 | `BUILD SUCCESSFUL in XXs` | `build/libs/` |
| Project 3 | 0 | `Build successful` | `src/` |

모든 프로젝트가 위 기준을 충족하면 빌드 배포 성공입니다.
