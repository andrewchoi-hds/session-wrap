#!/bin/bash

# Claude Plugins 설치 스크립트 (/wrap, /ui)
# 사용법: curl -sL https://raw.githubusercontent.com/andrewchoi-hds/claude-plugins/main/install.sh | bash

set -e

REPO="andrewchoi-hds/claude-plugins"
BRANCH="main"

echo "📦 Claude Plugins 설치 중..."

# 임시 디렉토리 생성
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# GitHub에서 다운로드
echo "⬇️  다운로드 중..."
curl -sL "https://github.com/$REPO/archive/refs/heads/$BRANCH.zip" -o "$TMP_DIR/plugin.zip"

# 압축 해제
unzip -q "$TMP_DIR/plugin.zip" -d "$TMP_DIR"

# .claude 폴더 복사
if [ -d ".claude" ]; then
    echo "🔄 기존 .claude 폴더 업데이트..."
    rm -rf .claude
fi

cp -r "$TMP_DIR/claude-plugins-$BRANCH/.claude" .

# 버전 확인
VERSION=$(grep '"version"' .claude/settings.json | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')

echo ""
echo "✅ 설치 완료!"
echo ""
echo "   버전: v$VERSION"
echo "   위치: $(pwd)/.claude"
echo ""
echo "💡 사용법:"
echo "   /wrap - 세션 마무리 (문서화, 배운 것, 다음 할 일)"
echo "   /ui   - Fresh UI 디자인 (AI 뻔한 패턴 탈피)"
echo ""
