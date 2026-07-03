#!/usr/bin/env bash
set -euo pipefail

# Build a DMG from the current project and publish it to GitHub Releases.
#
# Usage:
#   ./Scripts/release.sh
#   ./Scripts/release.sh --notes "Bug fixes and polish."
#   ./Scripts/release.sh --app ~/Downloads/The\ Pause.app
#   ./Scripts/release.sh --local-only
#
# Requires: xcodebuild, create-dmg, gh (GH_HOST=github.com)

readonly GITHUB_REPO="amtsh/The-Pause"
readonly APP_NAME="The Pause"
readonly DMG_FILENAME="ThePause.dmg"
readonly PROJECT="The Pause.xcodeproj"
readonly SCHEME="The Pause"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BUILD_DIR="${REPO_ROOT}/build/release"
ARCHIVE_PATH="${BUILD_DIR}/ThePause.xcarchive"
EXPORT_DIR="${BUILD_DIR}/export"
DMG_PATH="${BUILD_DIR}/${DMG_FILENAME}"
EXPORT_OPTIONS="${REPO_ROOT}/Supporting/ExportOptions.plist"

APP_PATH=""
RELEASE_NOTES=""
LOCAL_ONLY=0
NO_BUMP=0
DRY_RUN=0

VERSION=""
BUILD=""
TAG=""

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Build a DMG from the current project and upload it to GitHub Releases.
Auto-increments the build number before archiving. Does not commit or push.

Options:
  --notes TEXT    GitHub release notes (default: auto-generated).
  --app PATH      Skip archive/export; package this .app into the DMG.
  --no-bump       Skip build-number auto-increment (use with --app).
  --local-only    Build the DMG only; do not create or update a GitHub release.
  --dry-run       Print planned steps without building.
  -h, --help      Show this help.

Output:
  ${BUILD_DIR}/${DMG_FILENAME}
EOF
}

log() {
  printf '→ %s\n' "$*"
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

run() {
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

log_git_state() {
  if ! command -v git >/dev/null 2>&1 || ! git -C "${REPO_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return 0
  fi

  local commit branch status_line
  commit="$(git -C "${REPO_ROOT}" rev-parse --short HEAD)"
  branch="$(git -C "${REPO_ROOT}" rev-parse --abbrev-ref HEAD)"

  if [[ -n "$(git -C "${REPO_ROOT}" status --porcelain)" ]]; then
    status_line=" (working tree has uncommitted changes)"
  else
    status_line=""
  fi

  log "Building from ${branch}@${commit}${status_line}"
}

read_project_build_number() {
  local pbxproj="${REPO_ROOT}/${PROJECT}/project.pbxproj"
  grep -m1 'CURRENT_PROJECT_VERSION = ' "${pbxproj}" | sed -E 's/.*CURRENT_PROJECT_VERSION = ([0-9]+);/\1/'
}

bump_build_number() {
  local pbxproj="${REPO_ROOT}/${PROJECT}/project.pbxproj"
  local current_build new_build

  current_build="$(read_project_build_number)"
  [[ -n "${current_build}" ]] || die "Could not read CURRENT_PROJECT_VERSION from project.pbxproj"
  new_build=$((current_build + 1))

  log "Bumping build number ${current_build} → ${new_build}"
  run sed -i '' -E "s/CURRENT_PROJECT_VERSION = [0-9]+;/CURRENT_PROJECT_VERSION = ${new_build};/g" "${pbxproj}"
}

build_app() {
  log "Archiving ${APP_NAME}..."
  run mkdir -p "${BUILD_DIR}"
  run xcodebuild archive \
    -project "${REPO_ROOT}/${PROJECT}" \
    -scheme "${SCHEME}" \
    -configuration Release \
    -archivePath "${ARCHIVE_PATH}" \
    CODE_SIGN_STYLE=Automatic

  log "Exporting Developer ID build..."
  run rm -rf "${EXPORT_DIR}"
  run xcodebuild -exportArchive \
    -archivePath "${ARCHIVE_PATH}" \
    -exportPath "${EXPORT_DIR}" \
    -exportOptionsPlist "${EXPORT_OPTIONS}"

  APP_PATH="${EXPORT_DIR}/${APP_NAME}.app"
  [[ -d "${APP_PATH}" ]] || die "Expected exported app at ${APP_PATH}"
}

create_dmg() {
  [[ -d "${APP_PATH}" ]] || die "App not found: ${APP_PATH}"

  log "Creating DMG..."
  run rm -f "${DMG_PATH}"
  run create-dmg \
    --volname "${APP_NAME}" \
    --window-pos 200 120 \
    --window-size 600 400 \
    --icon-size 100 \
    --icon "${APP_NAME}.app" 150 185 \
    --hide-extension "${APP_NAME}.app" \
    --app-drop-link 450 185 \
    --overwrite \
    "${DMG_PATH}" \
    "${APP_PATH}"
}

read_version_info() {
  local info_plist="${APP_PATH}/Contents/Info.plist"

  VERSION="$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${info_plist}")"
  BUILD="$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${info_plist}")"
  TAG="v${VERSION}"

  log "Packaged ${APP_NAME} ${VERSION} (build ${BUILD})"
}

default_release_notes() {
  if [[ -n "${RELEASE_NOTES}" ]]; then
    printf '%s' "${RELEASE_NOTES}"
    return 0
  fi

  if command -v git >/dev/null 2>&1 && git -C "${REPO_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local commit
    commit="$(git -C "${REPO_ROOT}" rev-parse --short HEAD)"
    printf '%s %s (build %s)\n\nBuilt from commit %s.' "${APP_NAME}" "${VERSION}" "${BUILD}" "${commit}"
    return 0
  fi

  printf '%s %s (build %s).' "${APP_NAME}" "${VERSION}" "${BUILD}"
}

gh_release_exists() {
  env GH_HOST=github.com gh release view "${TAG}" --repo "${GITHUB_REPO}" >/dev/null 2>&1
}

publish_github_release() {
  local notes
  notes="$(default_release_notes)"

  if gh_release_exists; then
    log "Updating GitHub release ${TAG}..."
    run env GH_HOST=github.com gh release upload "${TAG}" \
      "${DMG_PATH}" \
      --clobber \
      --repo "${GITHUB_REPO}"
    log "Release updated: https://github.com/${GITHUB_REPO}/releases/tag/${TAG}"
    return 0
  fi

  log "Creating GitHub release ${TAG}..."
  run env GH_HOST=github.com gh release create "${TAG}" \
    "${DMG_PATH}" \
    --title "${APP_NAME} ${VERSION}" \
    --notes "${notes}" \
    --repo "${GITHUB_REPO}"
  log "Release created: https://github.com/${GITHUB_REPO}/releases/tag/${TAG}"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --notes)
        [[ $# -ge 2 ]] || die "--notes requires a value"
        RELEASE_NOTES="$2"
        shift 2
        ;;
      --app)
        [[ $# -ge 2 ]] || die "--app requires a path"
        APP_PATH="$2"
        shift 2
        ;;
      --no-bump)
        NO_BUMP=1
        shift
        ;;
      --local-only)
        LOCAL_ONLY=1
        shift
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        die "Unknown option: $1"
        ;;
    esac
  done
}

main() {
  parse_args "$@"

  require_command xcodebuild
  require_command create-dmg

  cd "${REPO_ROOT}"
  log_git_state

  if [[ -z "${APP_PATH}" ]]; then
    if [[ "${NO_BUMP}" -eq 0 ]]; then
      bump_build_number
    fi
    build_app
  else
    log "Using existing app: ${APP_PATH}"
    [[ -d "${APP_PATH}" ]] || die "App not found: ${APP_PATH}"
    run mkdir -p "${BUILD_DIR}"
  fi

  create_dmg

  if [[ "${DRY_RUN}" -eq 1 ]]; then
    log "Dry run complete. DMG would be at ${DMG_PATH}"
    exit 0
  fi

  read_version_info
  log "Done. DMG: ${DMG_PATH}"

  if [[ "${LOCAL_ONLY}" -eq 1 ]]; then
    exit 0
  fi

  require_command gh
  publish_github_release
}

main "$@"
