# Run recipes from the checkout inside orb-guix or a Linux Guix session.

# List the available commands.
default:
    @just --list

# Create/update the project virtual environment with the pinned dependencies.
setup:
    ./scripts/guix-shell.sh python3 -m venv .venv-guix
    ./scripts/guix-shell.sh python -m pip install -c constraints-guix.txt -e '.[dev]'

# Enter the pinned development shell.
shell:
    ./scripts/guix-shell.sh

# Open the sphere demo; defaults allow viewing it from the Mac.
smoke host="*" port="7000":
    ./scripts/guix-shell.sh python experiments/meshcat_smoke.py --host {{ quote(host) }} --port {{ quote(port) }}

# Check the sphere geometry and HTTP server, then exit.
smoke-check:
    ./scripts/guix-shell.sh python experiments/meshcat_smoke.py --check-only

# Check dependencies and run the current noninteractive environment check.
check:
    ./scripts/guix-shell.sh python -m pip check
    just smoke-check

# Run pytest (currently exits with code 5 because no tests exist yet).
test:
    ./scripts/guix-shell.sh python -m pytest
