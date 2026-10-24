#!/usr/bin/env bash
# 發佈新版：更新版本號 → commit → push，打開中的 app 會跳出「有新版本」按鈕
# 用法：scripts/release.sh "這次改了什麼（會顯示在更新按鈕上）"
set -euo pipefail
cd "$(dirname "$0")/.."
notes="${1:-}"
version=$(date "+%Y.%m.%d-%H%M")
sed -i '' "s/^const APP_VERSION='[^']*';/const APP_VERSION='${version}';/" index.html
grep -q "const APP_VERSION='${version}';" index.html
python3 -I -c 'import json,sys;json.dump({"version":sys.argv[1],"notes":sys.argv[2]},open("version.json","w"),ensure_ascii=False,indent=2)' "$version" "$notes"
git add -A
git commit -q -m "release ${version}${notes:+：$notes}"
git push -q
echo "released ${version}"
