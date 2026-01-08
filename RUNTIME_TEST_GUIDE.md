# 런타임 테스트 가이드

## 개요
Docker 컨테이너 내에서 세 개의 프로젝트를 동시에 실행하고 테스트하는 방법을 설명합니다.

---

## 아키텍처

```
testing.albl.cloud (http://172.17.0.1:9800)
           ↓
      [Nginx Proxy - Port 9800]
           ↓
    ┌──────┴──────┬──────────────┐
    ↓             ↓              ↓
[React:9801]  [Spring:8080]  [Express:3000]
    /         /api/spring    /api/express
```

---

## 서비스 시작

### 방법 1: 자동 시작 스크립트 사용 (권장)
```bash
docker compose exec dev bash -c "/workspace/start-all.sh" &
```

### 방법 2: 수동으로 각 서비스 시작
```bash
# 컨테이너 접속
docker compose exec dev bash

# Nginx 시작
nginx -c /workspace/nginx.conf

# Spring Boot 시작
cd /workspace/project2
java -jar build/libs/demo-0.0.1-SNAPSHOT.jar &

# Express 시작
cd /workspace/project3
npm start &

# React 시작
cd /workspace/project1
npm run dev &
```

---

## 테스트 엔드포인트

### 1. React 프론트엔드
**URL:** `http://testing.albl.cloud/`
**내부 포트:** 9801
**예상 응답:** React 앱 HTML 페이지

**테스트 방법:**
```bash
# 브라우저에서 접속
http://testing.albl.cloud/

# 또는 curl로 테스트
curl http://testing.albl.cloud/
```

**성공 기준:**
- HTML 응답 수신
- React 앱 화면 표시
- 개발자 도구에서 에러 없음

---

### 2. Spring Boot API
**URL:** `http://testing.albl.cloud/api/spring`
**내부 포트:** 8080
**Context Path:** `/api/spring`
**예상 응답:** `Hello from Spring Boot!`

**테스트 방법:**
```bash
curl http://testing.albl.cloud/api/spring
```

**예상 출력:**
```
Hello from Spring Boot!
```

**성공 기준:**
- HTTP 200 OK 응답
- 정확한 메시지 반환
- 응답 시간 < 1초

---

### 3. Express API
**URL:** `http://testing.albl.cloud/api/express`
**내부 포트:** 3000
**예상 응답:** JSON 형식

**테스트 방법:**
```bash
# 기본 엔드포인트
curl http://testing.albl.cloud/api/express

# Health check 엔드포인트
curl http://testing.albl.cloud/api/express/health
```

**예상 출력:**
```json
{
  "message": "Hello from Express!"
}
```

```json
{
  "status": "ok"
}
```

**성공 기준:**
- HTTP 200 OK 응답
- 올바른 JSON 형식
- Content-Type: application/json

---

## 서비스 상태 확인

### 실행 중인 프로세스 확인
```bash
docker compose exec dev bash -c "ps aux | grep -E 'nginx|java|node'"
```

**예상 출력:**
```
root  224  nginx: master process
root  226  java -jar build/libs/demo-0.0.1-SNAPSHOT.jar
root  271  node src/index.js
root  279  node .../vite
```

### 포트 리스닝 확인
```bash
docker compose exec dev bash -c "netstat -tlnp | grep -E '9800|8080|3000|5173'"
```

### 로그 확인
```bash
# Spring Boot 로그
docker compose exec dev bash -c "tail -f /tmp/spring-boot.log"

# Express 로그
docker compose exec dev bash -c "tail -f /tmp/express.log"

# React 로그
docker compose exec dev bash -c "tail -f /tmp/react.log"
```

---

## 통합 테스트 시나리오

### 시나리오 1: 모든 엔드포인트 순차 테스트
```bash
#!/bin/bash

echo "Testing React Frontend..."
curl -s http://testing.albl.cloud/ | head -5

echo -e "\nTesting Spring Boot API..."
curl -s http://testing.albl.cloud/api/spring

echo -e "\nTesting Express API..."
curl -s http://testing.albl.cloud/api/express

echo -e "\nTesting Express Health..."
curl -s http://testing.albl.cloud/api/express/health

echo -e "\nAll tests completed!"
```

### 시나리오 2: 성능 테스트
```bash
# 각 엔드포인트의 응답 시간 측정
echo "Spring Boot API:"
time curl -s http://testing.albl.cloud/api/spring > /dev/null

echo "Express API:"
time curl -s http://testing.albl.cloud/api/express > /dev/null
```

### 시나리오 3: 동시 요청 테스트
```bash
# 10개의 동시 요청
for i in {1..10}; do
  curl -s http://testing.albl.cloud/api/spring &
  curl -s http://testing.albl.cloud/api/express &
done
wait
echo "Concurrent requests completed"
```

---

## 트러블슈팅

### 문제 1: 서비스에 접근할 수 없음

**증상:**
```bash
curl: (7) Failed to connect
```

**해결 방법:**
```bash
# 1. 프로세스 확인
docker compose exec dev bash -c "ps aux | grep nginx"

# 2. nginx 재시작
docker compose exec dev bash -c "nginx -s reload"

# 3. 포트 확인
docker compose exec dev bash -c "netstat -tlnp | grep 9800"
```

### 문제 2: Spring Boot 시작 실패

**증상:**
로그에 에러 메시지 출력

**해결 방법:**
```bash
# 로그 확인
docker compose exec dev bash -c "tail -50 /tmp/spring-boot.log"

# Java 버전 확인
docker compose exec dev bash -c "java -version"

# 재시작
docker compose exec dev bash -c "pkill -f 'demo-0.0.1' && cd /workspace/project2 && java -jar build/libs/demo-0.0.1-SNAPSHOT.jar > /tmp/spring-boot.log 2>&1 &"
```

### 문제 3: Express 시작 실패

**증상:**
```
Error: Cannot find module 'express'
```

**해결 방법:**
```bash
# 의존성 재설치
docker compose exec dev bash -c "cd /workspace/project3 && npm install"

# 재시작
docker compose exec dev bash -c "cd /workspace/project3 && npm start > /tmp/express.log 2>&1 &"
```

### 문제 4: React 빌드 실패

**증상:**
```
vite: command not found
```

**해결 방법:**
```bash
# 의존성 재설치
docker compose exec dev bash -c "cd /workspace/project1 && npm install"

# Dev 서버 재시작
docker compose exec dev bash -c "cd /workspace/project1 && npm run dev > /tmp/react.log 2>&1 &"
```

### 문제 5: Nginx 설정 오류

**증상:**
```
nginx: [emerg] bind() to 0.0.0.0:9800 failed
```

**해결 방법:**
```bash
# 포트 사용 중인 프로세스 확인
docker compose exec dev bash -c "lsof -i :9800"

# 프로세스 종료 후 nginx 재시작
docker compose exec dev bash -c "nginx -s stop && nginx -c /workspace/nginx.conf"
```

---

## 서비스 중지

### 모든 서비스 중지
```bash
docker compose exec dev bash -c "pkill -f 'nginx|java|node'"
```

### 개별 서비스 중지
```bash
# Nginx
docker compose exec dev bash -c "nginx -s stop"

# Spring Boot
docker compose exec dev bash -c "pkill -f 'demo-0.0.1'"

# Express
docker compose exec dev bash -c "pkill -f 'node src/index.js'"

# React
docker compose exec dev bash -c "pkill -f 'vite'"
```

---

## 성공 기준 체크리스트

### 빌드 단계
- [ ] project1 빌드 성공 (`npm run build`)
- [ ] project2 빌드 성공 (`gradle build`)
- [ ] project3 의존성 설치 성공 (`npm install`)

### 런타임 단계
- [ ] Nginx 프로세스 실행 중
- [ ] Spring Boot 프로세스 실행 중
- [ ] Express 프로세스 실행 중
- [ ] React dev 서버 실행 중

### 엔드포인트 테스트
- [ ] `http://testing.albl.cloud/` - React 화면 표시
- [ ] `http://testing.albl.cloud/api/spring` - "Hello from Spring Boot!" 응답
- [ ] `http://testing.albl.cloud/api/express` - JSON 응답
- [ ] `http://testing.albl.cloud/api/express/health` - `{"status":"ok"}` 응답

### 성능 기준
- [ ] 각 API 응답 시간 < 1초
- [ ] 동시 요청 처리 가능
- [ ] 메모리 사용량 정상 범위

---

## 빠른 테스트 스크립트

[test/quick-test.sh](quick-test.sh) 파일을 생성하여 사용:

```bash
#!/bin/bash

echo "=== Quick Service Test ==="
echo

echo "[1/4] Testing React Frontend..."
REACT=$(curl -s -o /dev/null -w "%{http_code}" http://testing.albl.cloud/)
echo "React: HTTP $REACT"

echo "[2/4] Testing Spring Boot..."
SPRING=$(curl -s http://testing.albl.cloud/api/spring)
echo "Spring Boot: $SPRING"

echo "[3/4] Testing Express..."
EXPRESS=$(curl -s http://testing.albl.cloud/api/express)
echo "Express: $EXPRESS"

echo "[4/4] Testing Express Health..."
HEALTH=$(curl -s http://testing.albl.cloud/api/express/health)
echo "Health: $HEALTH"

echo
echo "=== Test Complete ==="
```

실행:
```bash
chmod +x quick-test.sh
./quick-test.sh
```

---

## 요약

| 서비스 | URL | 내부 포트 | 예상 응답 |
|--------|-----|----------|----------|
| React | `http://testing.albl.cloud/` | 5173 | HTML |
| Spring Boot | `http://testing.albl.cloud/api/spring` | 8080 | `Hello from Spring Boot!` |
| Express | `http://testing.albl.cloud/api/express` | 3000 | `{"message":"Hello from Express!"}` |
| Express Health | `http://testing.albl.cloud/api/express/health` | 3000 | `{"status":"ok"}` |

모든 엔드포인트가 정상 응답하면 빌드 및 런타임 테스트 성공입니다!
