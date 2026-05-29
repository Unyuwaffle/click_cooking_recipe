# Click Cooking Recipe Server

식재료 이미지 업로드, YOLO 기반 식재료 인식, PostgreSQL 기반 레시피 추천을 처리하는 FastAPI 서버 소스코드.

## 구성

```text
app/                  FastAPI 서버 소스코드
database_schema.sql   PostgreSQL 테이블 구조
requirements.txt      실행에 필요한 Python 패키지
```

## 실행에 필요한 외부 파일 및 설정

- YOLO 모델 가중치 파일(`best.pt`)은 실행 환경에 별도로 배치.
- 데이터베이스 접속 정보는 코드에 포함하지 않고 `DATABASE_URL` 환경변수로 설정.
- 업로드 이미지, 로그 파일, 가상환경 폴더, 실제 서버 주소, 실제 DB 접속 정보는 제출본에 포함하지 않음.

## 주요 API

```text
GET  /
GET  /api/v1/health
POST /api/v1/upload
POST /api/v1/recipes/search
```
