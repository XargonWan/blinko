#!/usr/bin/env bash
set -euo pipefail

# produce a flatpak bundle from the manifest defined under flatpak/
# usage: ./build-flatpak.sh

# base directory is the repo root (script may be run from anywhere)
script_dir="$(dirname "$0")"
manifest="$script_dir/com.blinko.app.yml"
builddir="$script_dir/build-dir"
output="${script_dir}/com.blinko.app.flatpak"

rm -rf "$builddir"

# build the application into a local repository
# ensure flathub remotes are available for dependency resolution
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# build application into local repository, installing deps from flathub and beta
flatpak-builder --force-clean --repo="$builddir/repo" --install-deps-from=flathub --install-deps-from=flathub-beta "$builddir" "$manifest"

# create a bundle containing the runtime + app
flatpak build-bundle "$builddir/repo" "$output" com.blinko.app --runtime

echo "generated $output"