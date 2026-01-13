# /wrap - 세션 마무리

세션 마무리 - 문서 업데이트, 자동화 기회, 다음 할 일을 분석합니다.

## 설명

다음과 같은 상황에서 이 스킬을 사용하세요:
- "세션 정리", "마무리해줘", "오늘 끝"
- "이제 정리하자", "오늘은 여기까지"
- "커밋할거 있어", "뭐 기록해야해"
- "/wrap", "wrap up session"

## 언어 감지

에이전트 실행 전에 사용자 언어를 감지하세요:

### 감지 규칙

| 트리거 유형 | 언어 태그 | 예시 |
|------------|----------|------|
| 한국어 트리거 | `[LANG: ko]` | 세션 정리, 마무리해줘, 랩업 |
| 영어 트리거 | `[LANG: en]` | wrap up, end session, done for today |
| 혼합 트리거 | `[LANG: ko]` | wrap 해줘, 세션 wrap |

### 적용 방법

1. 사용자의 트리거/메시지 언어 확인
2. 에이전트 프롬프트 끝에 언어 태그 추가
3. 모든 출력을 해당 언어로 통일

## 실행 흐름

### Phase 1: 병렬 분석 (4개 에이전트)

Task 도구를 사용하여 4개 에이전트를 **동시에** 실행:

1. **doc-updater** (subagent_type: `session-wrap:doc-updater`)
   - 프롬프트: "이 세션을 분석하고 CLAUDE.md와 context.md 업데이트를 제안하세요. [LANG: {감지된 언어}]"

2. **automation-scout** (subagent_type: `session-wrap:automation-scout`)
   - 프롬프트: "이 세션에서 자동화 기회를 분석하세요. [LANG: {감지된 언어}]"

3. **learning-extractor** (subagent_type: `session-wrap:learning-extractor`)
   - 프롬프트: "이 세션에서 배운 것을 추출하세요. [LANG: {감지된 언어}]"

4. **followup-suggester** (subagent_type: `session-wrap:followup-suggester`)
   - 프롬프트: "이 세션에서 후속 작업을 식별하세요. [LANG: {감지된 언어}]"

### Phase 2: 중복 검증

Phase 1 완료 후 실행:

5. **duplicate-checker** (subagent_type: `session-wrap:duplicate-checker`)
   - 프롬프트: Phase 1 결과 전체 + "[LANG: {감지된 언어}]"

### Phase 3: 사용자 선택 및 실행

#### Step 3.1: 결과 요약 제시

검증된 결과를 카테고리별로 요약:

```
# 세션 마무리

> 분석 완료 | 언어: {ko/en}

---

## 요약

| 카테고리 | 발견 | 승인 |
|----------|------|------|
| 문서 업데이트 | N개 | M개 |
| 자동화 기회 | N개 | M개 |
| 배운 것 | N개 | M개 |
| 다음 할 일 | N개 | M개 |

---

[각 에이전트의 상세 결과]
```

#### Step 3.2: 선택 요청

AskUserQuestion 사용:

```
질문: "어떤 작업을 수행할까요?" / "What would you like to do?"

옵션 (multiSelect: true):
1. 커밋 생성 / Create commit
2. CLAUDE.md 업데이트 / Update CLAUDE.md
3. 자동화 생성 / Create automation
4. TIL.md 저장 / Save to TIL.md
5. TODO.md 저장 / Save to TODO.md
```

#### Step 3.3: 선택 실행

**1. 커밋 생성 선택시:**
```
1. git status로 변경사항 확인
2. 변경사항이 있으면:
   - git add .
   - git commit -m "세션 정리: [요약]"
3. 결과 출력
```

**2. CLAUDE.md 업데이트 선택시:**
```
1. CLAUDE.md 읽기
2. 승인된 제안을 적절한 섹션에 추가
3. Edit 도구로 저장
4. 추가된 내용 출력
```

**3. 자동화 생성 선택시:**
```
1. 자동화 유형 확인 (skill/command/agent)
2. .claude/commands/ 또는 .claude/agents/에 파일 생성
3. settings.json에 등록 (필요시)
4. 생성된 파일 목록 출력
```

**4. TIL.md 저장 선택시:**
```
1. TIL.md 존재 확인 (없으면 생성)
2. 오늘 날짜 섹션에 항목 추가:
   ## 2026-01-13
   - **[주제]**: [내용]
3. 저장
4. 추가된 내용 출력
```

**5. TODO.md 저장 선택시:**
```
1. TODO.md 존재 확인 (없으면 생성)
2. 우선순위별로 작업 추가:
   ### P0 (즉시)
   - [ ] [작업]
   ### P1 (이번 주)
   - [ ] [작업]
3. 저장
4. 추가된 내용 출력
```

#### Step 3.4: 완료 메시지

```
## 세션 마무리 완료

수행된 작업:
- [x] 커밋 생성 (abc1234)
- [x] CLAUDE.md 업데이트 (3개 섹션)
- [ ] 자동화 생성 (건너뜀)
- [x] TIL.md 저장 (2개 항목)
- [ ] TODO.md 저장 (건너뜀)

다음 세션에서 뵙겠습니다! / See you next session!
```

## 출력 형식

### 한국어 (LANG: ko)

```
# 세션 마무리

> 분석 완료 | 언어: 한국어

---

## 요약

| 카테고리 | 발견 | 승인 |
|----------|------|------|
| 문서 업데이트 | N개 | M개 |
| 자동화 기회 | N개 | M개 |
| 배운 것 | N개 | M개 |
| 다음 할 일 | N개 | M개 |

---

## 문서 업데이트 제안
[doc-updater 결과]

## 자동화 기회
[automation-scout 결과]

## 배운 것
[learning-extractor 결과]

## 다음 할 일
[followup-suggester 결과]

---

무엇을 할까요?
```

### English (LANG: en)

```
# Session Wrap-up

> Analysis complete | Language: English

---

## Summary

| Category | Found | Approved |
|----------|-------|----------|
| Documentation | N | M |
| Automation | N | M |
| Learnings | N | M |
| Follow-ups | N | M |

---

## Documentation Suggestions
[doc-updater results]

## Automation Opportunities
[automation-scout results]

## Learnings
[learning-extractor results]

## Follow-up Tasks
[followup-suggester results]

---

What would you like to do?
```

## 주의사항

- Phase 1은 반드시 병렬로 실행하세요 (효율성)
- Phase 2는 Phase 1 완료 후 실행하세요 (의존성)
- 언어 태그를 반드시 에이전트에 전달하세요
- 사용자 선택을 존중하세요 (강제 X)
- 각 작업은 실패해도 다른 작업에 영향 없음
