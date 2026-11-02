#!/bin/bash
set -e
set -o pipefail

# Read-only checks: no temporary files are created, so no cleanup trap is needed.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
skill_root="$(cd -- "$script_dir/.." && pwd)"
python_bin="${PYTHON:-python3}"
echo "Checking code-to-4plus1 package structure and local links" >&2
"$python_bin" - "$skill_root" <<'PY'
import json
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

root = Path(sys.argv[1]).resolve()
issues = []
required = [
    'SKILL.md', 'README.md', 'references/evidence-policy.md',
    'references/discovery.md', 'references/scenario-physical.md',
    'references/logical-process.md', 'references/development.md',
    'references/incremental-update.md', 'references/quality-gates.md',
    'templates/pages.md', 'templates/traceability.md',
    'examples/readable-excerpt.md',
]
for name in required:
    if not (root / name).is_file():
        issues.append(f'Missing resource: {name}')
entry_path = root / 'SKILL.md'
entry = entry_path.read_text(encoding='utf-8') if entry_path.is_file() else ''
header = re.match(r'\A---\r?\n(.*?)\r?\n---(?:\r?\n|$)', entry, re.S)
if not header:
    issues.append('Missing frontmatter')
else:
    # This package uses plain, single-line frontmatter values.
    fields = dict(re.findall(r'^(name|description):\s*(.+)$', header[1], re.M))
    if fields.get('name') != root.name:
        issues.append('Skill name does not match directory')
    description = fields.get('description', '')
    if not description or len(description) > 1024 or 'Use when' not in description:
        issues.append('Description must include Use when and be at most 1024 characters')
links = 0
files = list(root.rglob('*.md'))
for path in files:
    text = path.read_text(encoding='utf-8')
    for target in re.findall(r'\]\(([^)]+)\)', text):
        target = target.strip('<>')
        parts = urlsplit(target)
        if parts.scheme or not parts.path:
            continue
        links += 1
        resolved = (path.parent / unquote(parts.path)).resolve()
        if not resolved.is_relative_to(root) or not resolved.is_file():
            issues.append(f'Invalid local link in {path.relative_to(root)}: {target}')
for phrase in ['场景和物理视图必须合并组织', '开发视图必须同时具备架构说明和详细设计']:
    if phrase not in entry:
        issues.append(f'Missing core rule: {phrase}')
print(json.dumps({'ok': not issues, 'markdown_files': len(files),
                  'local_links_checked': links, 'issues': issues}, ensure_ascii=False))
sys.exit(1 if issues else 0)
PY
