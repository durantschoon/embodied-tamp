#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

if [ "$#" -eq 0 ]; then
    set -- bash --noprofile --norc -i
fi

# Recipes can be called from inside this project's pure shell, where the outer
# Guix executable is intentionally absent from PATH. Reuse that environment.
if [ "${EMBODIED_TAMP_GUIX_ROOT:-}" = "$repo_root" ]; then
    if [ -f .venv-guix/bin/activate ]; then
        . .venv-guix/bin/activate
    fi
    exec "$@"
fi

# orb-guix's daemon uses --disable-chroot; its documented workflow disables
# grafts. A regular shell also avoids unsupported nested container mounts.
exec guix time-machine --no-grafts -C channels.scm -- shell \
    --no-grafts --pure -m manifest.scm -- \
    bash --noprofile --norc -c '
        set -eu
        export LD_LIBRARY_PATH="$GUIX_ENVIRONMENT/lib"
        export PYTHONNOUSERSITE=1
        export PIP_REQUIRE_VIRTUALENV=true
        export EMBODIED_TAMP_GUIX_ROOT="$PWD"
        if [ -f .venv-guix/bin/activate ]; then
            . .venv-guix/bin/activate
        fi
        exec "$@"
    ' embodied-tamp-guix "$@"
