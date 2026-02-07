# BabyCareAI 성능 최적화 가이드

## 개요
이 문서는 BabyCareAI API의 성능 최적화 전략과 실행 결과를 설명합니다.

## 성능 목표
- **대시보드 API**: 300ms 이하
- **일반 API**: 200ms 이하
- **GPT 질문 API**: 5초 이하 (외부 API 의존)

## 데이터베이스 인덱스

### 필수 인덱스

#### babies 테이블
```sql
-- 기본 키 (이미 존재)
PRIMARY KEY (id)

-- 사용자별 아이 조회
CREATE INDEX IF NOT EXISTS idx_babies_user_id ON babies(user_id);
CREATE INDEX IF NOT EXISTS idx_babies_user_is_active ON babies(user_id, is_active);
```

#### feeding_records 테이블
```sql
-- 기본 키 (이미 존재)
PRIMARY KEY (id)

-- 아이별 수유 기록 조회 (가장 자주 사용)
CREATE INDEX IF NOT EXISTS idx_feeding_records_baby_user 
ON feeding_records(baby_id, user_id);

-- 날짜 범위 조회
CREATE INDEX IF NOT EXISTS idx_feeding_records_baby_date 
ON feeding_records(baby_id, recorded_at DESC);

-- 수유 타입 필터링
CREATE INDEX IF NOT EXISTS idx_feeding_records_baby_type_date 
ON feeding_records(baby_id, feeding_type, recorded_at DESC);

-- 대시보드 최신 기록 조회
CREATE INDEX IF NOT EXISTS idx_feeding_records_baby_latest 
ON feeding_records(baby_id, user_id, recorded_at DESC);
```

#### baby_care_records 테이블
```sql
-- 기본 키 (이미 존재)
PRIMARY KEY (id)

-- 아이별 육아 기록 조회
CREATE INDEX IF NOT EXISTS idx_care_records_baby_user 
ON baby_care_records(baby_id, user_id);

-- 날짜 범위 조회
CREATE INDEX IF NOT EXISTS idx_care_records_baby_date 
ON baby_care_records(baby_id, recorded_at DESC);

-- 기록 타입 필터링
CREATE INDEX IF NOT EXISTS idx_care_records_baby_type_date 
ON baby_care_records(baby_id, record_type, recorded_at DESC);

-- 대시보드 최신 기록 조회
CREATE INDEX IF NOT EXISTS idx_care_records_baby_latest 
ON baby_care_records(baby_id, user_id, recorded_at DESC);
```

#### gpt_conversations 테이블
```sql
-- 기본 키 (이미 존재)
PRIMARY KEY (id)

-- 아이별 대화 기록 조회
CREATE INDEX IF NOT EXISTS idx_gpt_conversations_baby_user 
ON gpt_conversations(baby_id, user_id);

-- 최신 대화 조회
CREATE INDEX IF NOT EXISTS idx_gpt_conversations_baby_created 
ON gpt_conversations(baby_id, created_at DESC);
```

## 쿼리 최적화 전략

### 1. N+1 쿼리 방지

#### 문제
```python
# BAD: N+1 query problem
for baby in babies:
    latest_feeding = get_latest_feeding(baby.id)  # N queries
```

#### 해결
```python
# GOOD: Single query with aggregation
SELECT 
    b.*,
    (
        SELECT json_build_object(
            'id', f.id,
            'recorded_at', f.recorded_at,
            'feeding_type', f.feeding_type
        )
        FROM feeding_records f
        WHERE f.baby_id = b.id
        ORDER BY f.recorded_at DESC
        LIMIT 1
    ) as latest_feeding
FROM babies b
WHERE b.user_id = $1
```

### 2. 페이지네이션 최적화

#### LIMIT/OFFSET 방식 (현재 구현)
```python
# 간단하지만 큰 offset에서 성능 저하
SELECT * FROM feeding_records
WHERE baby_id = 1
ORDER BY recorded_at DESC
LIMIT 50 OFFSET 1000;  # Slow for large offsets
```

#### 커서 기반 페이지네이션 (추천)
```python
# 더 빠르고 일관된 성능
SELECT * FROM feeding_records
WHERE baby_id = 1
  AND recorded_at < $cursor_date
ORDER BY recorded_at DESC
LIMIT 50;
```

### 3. 대시보드 쿼리 최적화

#### 전략
1. **필요한 컬럼만 선택**
```python
# BAD
SELECT * FROM feeding_records

# GOOD
SELECT id, recorded_at, feeding_type, amount
FROM feeding_records
```

2. **서브쿼리 최적화**
```python
# Use indexed columns in WHERE clauses
WHERE baby_id = $1 
  AND user_id = $2 
  AND recorded_at >= $start_date
```

3. **집계 쿼리 최적화**
```python
# Use covering indexes
CREATE INDEX idx_feeding_summary 
ON feeding_records(baby_id, recorded_at, feeding_type, amount);
```

### 4. 날짜 범위 쿼리 최적화

```python
# Use DATE_TRUNC for daily aggregations
SELECT 
    DATE_TRUNC('day', recorded_at) as date,
    COUNT(*) as count,
    SUM(amount) as total_amount
FROM feeding_records
WHERE baby_id = $1
  AND recorded_at >= $start_date
  AND recorded_at <= $end_date
GROUP BY DATE_TRUNC('day', recorded_at)
ORDER BY date DESC;
```

## 애플리케이션 레벨 최적화

### 1. 데이터베이스 연결 풀링
```python
# Supabase client already uses connection pooling
# No additional configuration needed
```

### 2. 쿼리 결과 선택적 로딩
```python
# Only fetch needed fields
.select("id, name, birth_date")
.select("id, recorded_at, feeding_type, amount")
```

### 3. 배치 작업
```python
# Batch insert for multiple records
records = [
    {"baby_id": 1, "feeding_type": "breast_milk"},
    {"baby_id": 1, "feeding_type": "formula"},
]
client.table("feeding_records").insert(records).execute()
```

### 4. 조건부 쿼리
```python
# Only query what's needed
if feeding_type:
    query = query.eq("feeding_type", feeding_type)
if start_date:
    query = query.gte("recorded_at", start_date)
```

## 캐싱 전략 (향후 개선)

### 1. Redis 캐싱
```python
# Cache frequently accessed data
@cache(ttl=300)  # 5 minutes
async def get_dashboard_data(baby_id: int):
    # Expensive query
    pass
```

### 2. 애플리케이션 레벨 캐싱
```python
from functools import lru_cache

@lru_cache(maxsize=128)
def get_baby_info(baby_id: int):
    # Infrequently changing data
    pass
```

## 모니터링 및 프로파일링

### 1. Supabase 쿼리 성능 분석
```sql
-- Enable query statistics
EXPLAIN ANALYZE
SELECT * FROM feeding_records
WHERE baby_id = 1
ORDER BY recorded_at DESC
LIMIT 50;
```

### 2. 애플리케이션 로깅
```python
import time

start = time.time()
result = await repository.get_records()
elapsed = time.time() - start

if elapsed > 0.2:  # 200ms threshold
    logger.warning(f"Slow query: {elapsed}s")
```

### 3. APM 도구 (추천)
- Sentry: 에러 추적 및 성능 모니터링
- New Relic: 상세 성능 분석
- DataDog: 인프라 및 애플리케이션 모니터링

## 성능 테스트 체크리스트

- [ ] 인덱스 확인 및 생성
- [ ] N+1 쿼리 문제 해결
- [ ] 대시보드 쿼리 최적화
- [ ] 페이지네이션 성능 확인
- [ ] 느린 쿼리 식별 및 개선
- [ ] 부하 테스트 수행
- [ ] 모니터링 설정

## 부하 테스트 (향후)

### Locust를 사용한 부하 테스트
```python
from locust import HttpUser, task, between

class BabyCareUser(HttpUser):
    wait_time = between(1, 3)
    
    @task
    def get_dashboard(self):
        self.client.get("/api/v1/baby-care-ai/babies/1/dashboard")
    
    @task
    def list_feeding_records(self):
        self.client.get("/api/v1/baby-care-ai/babies/1/feeding-records")
```

### 목표 부하
- **동시 사용자**: 100명
- **평균 응답 시간**: 200ms
- **에러율**: < 1%

## 결론

성능 최적화는 지속적인 프로세스입니다. 정기적으로:
1. 느린 쿼리 모니터링
2. 인덱스 사용 확인
3. 부하 테스트 수행
4. 사용자 피드백 수집

## 참고 자료
- [Supabase Performance Guide](https://supabase.com/docs/guides/performance)
- [PostgreSQL Index Guide](https://www.postgresql.org/docs/current/indexes.html)
- [FastAPI Performance Tips](https://fastapi.tiangolo.com/deployment/concepts/)
