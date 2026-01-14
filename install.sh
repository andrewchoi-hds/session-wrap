#!/bin/bash

# session-wrap 플러그인 설치 스크립트
# 사용법: curl -sL https://raw.githubusercontent.com/andrewchoi-hds/session-wrap/main/install.sh | bash

set -e

REPO="andrewchoi-hds/session-wrap"
BRANCH="main"

echo "📦 session-wrap 플러그인 설치 중..."

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

cp -r "$TMP_DIR/session-wrap-$BRANCH/.claude" .

# 버전 확인
VERSION=$(grep '"version"' .claude/settings.json | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')

echo ""
echo "✅ 설치 완료!"
echo ""
echo "   버전: v$VERSION"
echo "   위치: $(pwd)/.claude"
echo ""
echo "💡 사용법: /wrap 또는 \"세션 정리\" 입력"
echo ""
