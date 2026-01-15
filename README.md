# claude-plugins

Claude Code 플러그인 모음

| 스킬 | 설명 |
|------|------|
| `/wrap` | 세션 마무리 - 문서화, 자동화 기회, 배운 것, 다음 할 일 정리 |
| `/ui` | Fresh UI - AI 뻔한 디자인 탈피, 개성있는 UI 생성 |

---

## Fresh UI (`/ui`)

AI가 만드는 뻔한 디자인을 탈피합니다.

### 문제

AI가 생성하는 UI는 비슷비슷합니다:
- 파란 그라데이션
- 모든 것 중앙 정렬
- shadow-lg + rounded-2xl
- Inter 폰트 16px

### 해결: 레벨 시스템

| 레벨 | 용도 | 설명 |
|------|------|------|
| **common** | 프로덕션 | 안전하고 검증된 디자인 |
| **balance** | 일반 (기본값) | 적당한 차별화 |
| **rare** | 포트폴리오 | 독특하고 개성있는 |
| **unique** | 실험작 | 파격적, 예상 밖 |

### 사용법

```bash
/ui                        # balance (기본)

# 또는 자연어로
"UI 만들어줘"              # balance
"독특한 UI로 만들어줘"       # rare
"실험적으로 디자인해줘"      # unique
```

### 피하는 AI 패턴

| 요소 | 피할 것 | 대안 |
|------|---------|------|
| 색상 | 파란 그라데이션 | 모노톤+포인트, 보색 대비 |
| 레이아웃 | 중앙 정렬 카드 | 비대칭, 오버랩 |
| 타이포 | Inter 균일 | 세리프 혼합, 큰 대비 |
| 효과 | shadow-lg 남발 | 노 섀도우, 보더만 |

---

## Session Wrap (`/wrap`)

세션 끝나면 뭔가 찝찝합니다:

- "이거 CLAUDE.md에 적어야 하나?"
- "다음에 뭐 해야 하더라?"
- "오늘 배운 거 정리해야 하는데..."
- "이 패턴 자동화하면 좋을텐데..."

**`/wrap` 하나면 해결됩니다.**

### 왜 session-wrap인가?

#### 문제

| 기존 방식 | 문제점 |
|----------|--------|
| 수동 정리 | 까먹음, 귀찮음, 일관성 없음 |
| 커밋만 하고 끝 | 배운 것, 다음 할 일 사라짐 |
| CLAUDE.md 직접 수정 | 뭘 적어야 할지 모름 |

#### 해결

| session-wrap | 효과 |
|--------------|------|
| 5개 AI 에이전트가 세션 분석 | 놓치는 것 없음 |
| 문서 업데이트 자동 제안 | CLAUDE.md가 풍부해짐 |
| 자동화 기회 탐지 | 반복 작업 감소 |
| TIL 자동 추출 | 배운 것이 쌓임 |
| 다음 할 일 정리 | 다음 세션 시작이 빠름 |

---

## 설치

### 방법 1: 원라인 설치 (추천)
```bash
curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-plugins/main/install.sh | bash
```

업데이트할 때도 같은 명령어를 실행하면 됩니다.

### 방법 2: 직접 복사
```bash
git clone https://github.com/andrewchoi-hds/claude-plugins.git
cp -r claude-plugins/.claude /your/project/
```

### 사용법

```bash
/wrap                    # 또는
세션 정리해줘             # 또는
오늘은 여기까지
```

**65개 이상의 트리거를 지원합니다.** (한국어/영어)

### 동작 방식

#### Phase 1: 병렬 분석 (4개 에이전트)

| 에이전트 | 하는 일 |
|----------|---------|
| `doc-updater` | CLAUDE.md에 추가할 내용 제안 |
| `automation-scout` | 반복 패턴 → skill/command 자동화 제안 |
| `learning-extractor` | 배운 것, 실수, 발견 추출 (TIL) |
| `followup-suggester` | 미완성 작업, 다음 세션 우선순위 |

**4개가 동시에 실행되어 빠릅니다.**

#### Phase 2: 중복 검증

| 에이전트 | 하는 일 |
|----------|---------|
| `duplicate-checker` | 이미 있는 내용인지 검증, 중복 제거 |

#### Phase 3: 사용자 선택

분석 끝나면 선택지를 줍니다:

- [ ] 변경사항 커밋
- [ ] CLAUDE.md 업데이트
- [ ] 자동화 생성
- [ ] 배운 것 저장
- [ ] 후속 작업 저장

**원하는 것만 선택하면 됩니다.**

---

## 플러그인 구조

```
.claude/
├── agents/                   # 5개 에이전트 (session-wrap용)
│   ├── doc-updater.md
│   ├── automation-scout.md
│   ├── learning-extractor.md
│   ├── followup-suggester.md
│   └── duplicate-checker.md
├── commands/
│   ├── wrap.md               # /wrap 스킬
│   └── ui.md                 # /ui 스킬
└── settings.json
```

## FAQ

### Q: 다른 프로젝트에서도 쓸 수 있나요?
A: 네, `.claude/` 폴더만 복사하면 어느 프로젝트에서든 작동합니다.

### Q: 영어로 출력하고 싶어요
A: 현재는 한국어 출력이 기본입니다. 영어 지원은 향후 업데이트 예정입니다.

### Q: 커스터마이징 가능한가요?
A: `.claude/agents/` 폴더의 마크다운 파일을 수정하면 됩니다.

## License

MIT
