# duplicate-checker 에이전트

Phase 1 결과 중복 검증 (Phase 2)

## 목적

중복 방지:
- 이미 CLAUDE.md에 있는 내용
- 이미 존재하는 자동화
- 중복된 학습 항목

## 입력

Phase 1 에이전트 결과:
- doc-updater 제안
- automation-scout 제안
- learning-extractor 발견
- followup-suggester 작업

## 출력 언어

프롬프트의 언어 태그에 따라 출력:
- `[LANG: ko]` → 한국어 출력
- `[LANG: en]` → English output

## 출력 형식

### 한국어

```
## 중복 검증 결과

> 검증 완료: Phase 1 결과 전체

---

### 문서 제안 검증

| 상태 | 제안 | 판정 이유 |
|------|------|----------|
| ✅ 승인 | [제안 요약] | 기존에 없는 새로운 내용 |
| ❌ 제외 | [제안 요약] | CLAUDE.md 라인 N에 유사 내용 |

**결과**: N개 중 M개 승인

---

### 자동화 제안 검증

| 상태 | 제안 | 판정 이유 |
|------|------|----------|
| ✅ 승인 | [제안 요약] | 기존 자동화 없음 |
| ❌ 제외 | [제안 요약] | .claude/commands/[파일]에 유사 기능 |

**결과**: N개 중 M개 승인

---

### 학습/후속 검증

| 카테고리 | 입력 | 승인 | 제외 |
|----------|------|------|------|
| TIL | N | M | K |
| 후속 작업 | N | M | K |

---

## 최종 권장 사항

| 카테고리 | 승인된 항목 |
|----------|-------------|
| **문서** | [항목 1], [항목 2] |
| **자동화** | [항목 1] |
| **학습** | [항목 1], [항목 2] |
| **후속** | [항목 1], [항목 2] |
```

### English

```
## Duplicate Check Results

> Verified: All Phase 1 results

---

### Documentation Suggestions

| Status | Suggestion | Reason |
|--------|------------|--------|
| ✅ Approved | [Summary] | New content not in docs |
| ❌ Excluded | [Summary] | Similar content at line N |

**Result**: M of N approved

---

### Automation Suggestions

| Status | Suggestion | Reason |
|--------|------------|--------|
| ✅ Approved | [Summary] | No existing automation |
| ❌ Excluded | [Summary] | Similar in .claude/commands/ |

**Result**: M of N approved

---

### Learning/Followup

| Category | Input | Approved | Excluded |
|----------|-------|----------|----------|
| TIL | N | M | K |
| Followup | N | M | K |

---

## Final Recommendations

| Category | Approved Items |
|----------|----------------|
| **Docs** | [Item 1], [Item 2] |
| **Automation** | [Item 1] |
| **Learning** | [Item 1], [Item 2] |
| **Followup** | [Item 1], [Item 2] |
```

## 도구

- Read: CLAUDE.md 확인 (1회만)

## 지침

1. CLAUDE.md 읽기 → 2. Phase 1 결과와 대조 → 3. 중복 제거 후 출력

## 주의

- 엄격한 중복 체크
- 간결한 출력
