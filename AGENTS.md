# AGENTS.md — The Pause

Instructions for AI agents working in this repo. Follow these workflows when the user asks to ship, release, publish, or push updates.

## Project

- **App:** The Pause — macOS menu bar mindfulness app (SwiftUI, `LSUIElement`)
- **Repo:** https://github.com/amtsh/The-Pause
- **Branch:** `main` (not `master`)
- **Distribution:** Direct download via GitHub Releases + Sparkle auto-update (not App Store)
- **Scheme / target:** `The Pause`
- **Bundle ID:** `amitshinde.The-Pause`

## Key files

| File | Purpose |
|---|---|
| `Scripts/release.sh` | Build DMG, auto-increment build, upload to GitHub Releases |
| `Supporting/ExportOptions.plist` | Developer ID export for `xcodebuild -exportArchive` |
| `Supporting/SparkleKeys.plist` | `SUFeedURL`, `SUPublicEDKey` (public key only) |
| `appcast.xml` | Sparkle update feed (served from `main` via raw GitHub URL) |
| `The Pause.xcodeproj/project.pbxproj` | `MARKETING_VERSION`, `CURRENT_PROJECT_VERSION` |

## Versioning

| Field | Xcode setting | Sparkle / release |
|---|---|---|
| Marketing version | `MARKETING_VERSION` / Version | GitHub tag `v{version}` (e.g. `v1.0`) |
| Build number | `CURRENT_PROJECT_VERSION` / Build | Sparkle compares **build**, not marketing version |

- **Same version, new build:** `./Scripts/release.sh` re-uploads DMG to existing `v1.0` release.
- **New marketing version:** Bump Version in Xcode first (e.g. `1.0` → `1.1`), commit if user asks, then run release script → creates `v1.1`.

## Prerequisites (verify before releasing)

```bash
# GitHub CLI — must target github.com (not Spotify GHE)
GH_HOST=github.com gh auth status

# Build tools
which xcodebuild create-dmg

# Sparkle sign_update (after at least one Xcode build)
find ~/Library/Developer/Xcode/DerivedData -path "*/The_Pause-*/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update" | head -1
```

Install missing tools:
- `brew install create-dmg`
- `GH_HOST=github.com gh auth login`

Sparkle private signing key must be in Keychain (never commit it). Public key in `Supporting/SparkleKeys.plist` is safe to commit.

## Agent workflows

### 1. User pushes code only (no release)

Do **not** run the release script unless asked.

```bash
git add <files>
git commit -m "..."
git push origin main
```

Only commit when the user explicitly asks.

### 2. User asks to release / ship / publish

Run the full release flow below. Execute steps yourself; do not only print instructions.

#### Step A — Ensure code is ready

- If there are uncommitted changes the user wants included, commit and push to `main` first (only if user asked to commit).
- For a **new marketing version**, bump `MARKETING_VERSION` in `The Pause.xcodeproj/project.pbxproj` (all targets) or tell user to set it in Xcode → General → Version.

#### Step B — Build and publish DMG

From repo root:

```bash
./Scripts/release.sh --notes "Brief release notes."
```

This will:
1. Auto-increment `CURRENT_PROJECT_VERSION` in `project.pbxproj` (local only — not committed by script)
2. Archive + export Developer ID build
3. Create `build/release/ThePause.dmg`
4. Create or update GitHub release `v{MARKETING_VERSION}` and upload the DMG

Useful flags:
- `--local-only` — DMG only, no GitHub upload
- `--app PATH` — skip build, package existing `.app`
- `--no-bump` — skip build-number increment (with `--app`)
- `--dry-run` — show steps without building

If `gh` fails with 401: user must run `GH_HOST=github.com gh auth login`.

#### Step C — Update Sparkle appcast (required for auto-update)

The release script does **not** update `appcast.xml`. Agents must do this after every release:

```bash
SIGN_UPDATE=$(find ~/Library/Developer/Xcode/DerivedData -path "*/The_Pause-*/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update" 2>/dev/null | head -1)
"$SIGN_UPDATE" build/release/ThePause.dmg
stat -f%z build/release/ThePause.dmg
```

Prepend a new `<item>` to `appcast.xml` (keep older items). Set:
- `sparkle:version` → build number from exported app
- `sparkle:shortVersionString` → marketing version
- `sparkle:minimumSystemVersion` → `26.5`
- `url` → `https://github.com/amtsh/The-Pause/releases/download/v{VERSION}/ThePause.dmg`
- `sparkle:edDSASignature` and `length` from `sign_update` output
- `sparkle:releaseNotesLink` → `https://github.com/amtsh/The-Pause/releases/tag/v{VERSION}`

Then commit and push **only if the user asked to commit/push**:

```bash
git add appcast.xml
git commit -m "Update appcast for build {N}."
git push origin main
```

Sparkle feed URL: https://raw.githubusercontent.com/amtsh/The-Pause/main/appcast.xml

#### Step D — Confirm

Verify:
- GitHub release asset: `https://github.com/amtsh/The-Pause/releases/tag/v{VERSION}`
- Raw appcast loads and has the new item with correct signature and length

### 3. User asks to push local changes

Follow user git rules: `git status`, `git diff`, `git log`, draft message, commit, push. Do not push unless asked.

Note: `release.sh` modifies `project.pbxproj` (build bump) locally. If user wants that persisted, commit the pbxproj change separately.

## What NOT to commit

- Sparkle **private** key / `.p8` App Store Connect keys
- Certificates (`.p12`, `.cer`)
- `build/` directory (gitignored)
- Secrets or credentials

Safe to commit: `ExportOptions.plist`, `SparkleKeys.plist` (public key only), `appcast.xml`.

## Release checklist (for agents)

```
[ ] Code on main (committed/pushed if user requested)
[ ] Marketing version correct for intended GitHub tag
[ ] ./Scripts/release.sh completed successfully
[ ] appcast.xml updated with sign_update signature + length + build
[ ] appcast.xml pushed to main (if user requested push)
[ ] GitHub release has ThePause.dmg attached
```

## Common user phrases → action

| User says | Agent does |
|---|---|
| "push my changes" | git commit + push (no release) |
| "release" / "ship it" / "publish" | `./Scripts/release.sh` + appcast update |
| "new version 1.2" | bump `MARKETING_VERSION`, release, update appcast |
| "build dmg only" | `./Scripts/release.sh --local-only` |

## Build manually (fallback)

If `release.sh` fails, equivalent steps:

```bash
cd "/Users/ashinde/Developer/xcode/The Pause"
xcodebuild archive -project "The Pause.xcodeproj" -scheme "The Pause" -configuration Release -archivePath build/release/ThePause.xcarchive
xcodebuild -exportArchive -archivePath build/release/ThePause.xcarchive -exportPath build/release/export -exportOptionsPlist Supporting/ExportOptions.plist
create-dmg --volname "The Pause" --overwrite build/release/ThePause.dmg "build/release/export/The Pause.app"
GH_HOST=github.com gh release upload v1.0 build/release/ThePause.dmg --clobber --repo amtsh/The-Pause
```

## App architecture (for context)

- `The Pause/The_PauseApp.swift` — entry, `MenuBarExtra`, `UpdaterManager`
- `The Pause/ContentView.swift` — main UI
- `The Pause/UpdaterManager.swift` — Sparkle `SPUStandardUpdaterController`
- `The Pause/LaunchAtLogin.swift` — `SMAppService.mainApp`

Do not add unrelated features when executing release tasks.
