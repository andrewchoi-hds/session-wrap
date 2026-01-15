# CLAUDE.md - Claude Plugins

## 프로젝트 개요

Claude Code 플러그인 모음입니다.

| 스킬 | 설명 |
|------|------|
| `/wrap` | 세션 마무리 - 문서화, 자동화 기회, 배운 것, 다음 할 일 정리 |
| `/ui` | Fresh UI - AI 뻔한 디자인 탈피, 개성있는 UI 생성 |

## 설치

```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-plugins/main/install.sh | bash
```

자세한 설치 가이드는 [README.md](README.md) 참조.

## 플러그인 구조

```
.claude/
├── agents/           # 5개 분석 에이전트 (session-wrap용)
│   ├── doc-updater.md
│   ├── automation-scout.md
│   ├── learning-extractor.md
│   ├── followup-suggester.md
│   └── duplicate-checker.md
├── commands/
│   ├── wrap.md       # /wrap 스킬 정의
│   └── ui.md         # /ui 스킬 정의
└── settings.json     # 에이전트 & 스킬 설정
```

---

## Fresh UI (/ui)

AI의 뻔한 디자인을 탈피하고 개성있는 UI를 생성합니다.

### 레벨 시스템

| 레벨 | 안정성 | 개성 | 실험 | 용도 |
|------|--------|------|------|------|
| **common** | 90 | 30 | 10 | 클라이언트, 프로덕션 |
| **balance** | 60 | 50 | 40 | 일반 프로젝트 (기본값) |
| **rare** | 40 | 80 | 60 | 포트폴리오, 차별화 필요 |
| **unique** | 20 | 90 | 90 | 실험작, 아트 프로젝트 |

### 자연어 트리거

```
"UI 만들어줘"              → balance
"독특한 UI로 만들어줘"       → rare
"실험적으로 디자인해줘"      → unique
"기본적으로 만들어"         → common
```

### 피하는 AI 패턴 예시

- 파란 그라데이션, 보라-핑크
- 모든 것 중앙 정렬
- shadow-lg + rounded-2xl 남발
- Inter 폰트 + 16px 균일

---

## Session Wrap (/wrap)

### 에이전트 개발 패턴

### Phase 기반 워크플로우

복잡한 작업은 Phase로 나눠서 설계합니다:

| Phase | 실행 방식 | 목적 |
|-------|----------|------|
| Phase 1 | 병렬 | 독립적인 분석 작업 (4개 에이전트) |
| Phase 2 | 순차 | Phase 1 결과 검증 (duplicate-checker) |
| Phase 3 | 대화 | 사용자 선택 (AskUserQuestion) |

### 에이전트 역할 분리 (Single Responsibility)

하나의 에이전트 = 하나의 명확한 책임:
- `doc-updater`: 문서 업데이트 제안만
- `automation-scout`: 자동화 기회 탐지만
- `learning-extractor`: 배운 것 추출만
- `followup-suggester`: 다음 할 일만
- `duplicate-checker`: 중복 검증만

### 에이전트 파일 구조

```markdown
# [에이전트명] 에이전트

[한 줄 설명]

## 목적
[무엇을 하는지]

## 출력 형식
[구조화된 출력 템플릿]

## 사용 가능한 도구
- Read / Glob / Grep

## 지침
1. [단계별 가이드]

## 주의사항
- 한국어로 출력하세요
```

### 스킬 정의 베스트 프랙티스

### 파일 구조

```markdown
# /[명령어] - [설명]

## 설명
[언제 사용하는지, 트리거 목록]

## 실행 흐름
### Phase 1: [단계명]
### Phase 2: [단계명]
### Phase 3: [단계명]

## 구현
[의사 코드]

## 출력
[출력 예시]
```

### 트리거 설계 원칙

다양한 표현 지원:
- 명령어: `/wrap`
- 한국어: "세션 정리", "마무리해줘", "오늘은 여기까지"
- 영어: "wrap up session", "end session"
- 축약: "랩", "랩업"

### 다국어 지원 패턴

### 현재 지원

트리거 65개+ (한국어/영어):

| 유형 | 예시 |
|------|------|
| 기본 | 세션 정리, 세션 마무리, wrap up session |
| 요청 | 마무리해줘, 정리해주세요 |
| 대화 | 이제 정리하자, 오늘은 여기까지 |
| 어미 변형 | 정리하자, 정리할까, 마무리할까요 |
| 띄어쓰기 변형 | 세션정리, 작업마무리 |
| 영어 변형 | wrap it up, let's wrap, done for today |
| 혼합 | wrap 해줘, 세션 wrap |

### 다국어 출력

- `[LANG: ko]` 태그 → 한국어 출력
- `[LANG: en]` 태그 → 영어 출력
- 트리거 언어에 따라 자동 감지

---

## 향후 개선

### P1 (높음)
- [x] 동적 언어 감지 - 사용자 언어에 맞춰 응답
- [x] 트리거 패턴 개선 - 변형 표현 매칭 (65개+)

### P2 (중간)
- [x] Phase 3 사용자 선택 완성
- [x] 출력 형식 개선 - 테이블 기반 구조화
- [ ] README 개선

### P3 (낮음)
- [ ] 일본어/중국어 지원
- [ ] 성능 최적화
