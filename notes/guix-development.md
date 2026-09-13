# Guix development

## Baseline verified on 2026-09-13

The existing `orb-guix` alias in the user's dotfiles enters OrbStack's `guix-dev`
Docker container. The project reuses that container and its persistent Guix store.
The Mac checkout at `/Users/durant/Repos/ds/embodied-tamp` is mounted at
`/root/Repos/ds/embodied-tamp`.

- Container image: `metacall/guix@sha256:e028ebad915a2ff1e4b91680444600dd6712214cf2c7cb0bcb6ebd5fe8891afe`.
- Base container: Debian 13; the dotfiles configuration specifies `linux/amd64`
  and its system shell reports `x86_64`. The Guix interpreter reports `aarch64`
  / `linux-aarch64`, and pip selects ARM64 wheels. Record the interpreter's
  architecture when reproducing Python results rather than inferring it from
  the outer container shell.
- Guix commit: `df2d121208127ac22f10e0f7c2f38d6c74e106a3`.
- Nonguix commit: `73baab37361b3a81f326aa3fdec78840f5acc577`.
- Project interpreter: Guix Python 3.12.12, built with GCC 14.3.0.
- Python packages: Drake 1.57.0, pytest 9.1.1, pip 25.0.1; complete baseline
  runtime/development versions are in `constraints-guix.txt`.
- `scripts/guix-shell.sh python3 --version` succeeds.
- Creating `.venv-guix` succeeds; the launcher selects its Python and pip.
- Drake geometry and multibody imports pass; `python -m pip check` passes.
- A fresh temporary virtual environment successfully installs `.[dev]` with
  `constraints-guix.txt`, passes `pip check`, and passes the Meshcat smoke check.
  This reuses the same Guix store and pip download cache; it is not validation
  on a second machine or from an empty store.
- `experiments/meshcat_smoke.py --check-only` passes: a sphere is retained in the
  Meshcat scene tree and the server returns its viewer HTML over HTTP.
- The Mac receives HTTP 200 and the viewer HTML at `http://guix-dev.orb.local:7000/`
  while the script runs with `--host '*' --port 7000`.
- Browser automation had no available browser connection, so actual browser
  rendering and WebSocket display have not been visually verified.

`channels.scm` captures the existing channel set, including its authentication
introductions. This project's manifest uses Guix packages only; Nonguix is retained
to match the existing environment. The launcher uses `guix time-machine`, so a
later global `guix pull` does not silently change the project channels.

## Enter the environment

On this Mac:

```sh
orb-guix
cd /root/Repos/ds/embodied-tamp
```

On another Linux machine with a working Guix installation:

```sh
git clone https://github.com/durantschoon/embodied-tamp.git
cd embodied-tamp
```

From either checkout, create the virtual environment once and enter the shell:

```sh
./scripts/guix-shell.sh python3 -m venv .venv-guix
./scripts/guix-shell.sh
```

The launcher defaults to a plain Bash shell so personal shell startup files do
not replace the selected Python or libraries. `exit` returns to the outer shell.
To execute one command, pass it to the launcher, for example:

```sh
./scripts/guix-shell.sh python --version
```

Inside the project shell, install and check the validated dependency set:

```sh
python -m pip install -c constraints-guix.txt -e '.[dev]'
python -m pip check
python experiments/meshcat_smoke.py --check-only
```

For automation from this Mac, the equivalent entry is:

```sh
docker --context orbstack exec -w /root/Repos/ds/embodied-tamp guix-dev \
  sh -lc './scripts/guix-shell.sh python --version'
```

The project does not provision a container on other machines. Start with Guix
installed and working there. A fresh checkout recreates `.venv-guix`; do not copy
the virtual environment between machines or use its Linux binaries on macOS.

## View the environment smoke scene

Inside the Guix project shell, run:

```sh
python experiments/meshcat_smoke.py --host '*' --port 7000
```

Open `http://guix-dev.orb.local:7000/` from the Mac and look for a blue sphere above
the ground grid. Keep the process running to retain the scene; press Enter or
Ctrl-C to stop. This uses the existing OrbStack network without changing container
ports or the user's dotfiles. A GET request works; Meshcat returned 404 to an HTTP
HEAD probe, so use GET when checking reachability.

On native Linux, omit `--host '*'` and use the printed localhost URL. The host
override permits access from outside the container. `--check-only` requires no
interactive browser and exits after checking the scene tree and viewer response.

## Compatibility decisions

- A regular `guix shell --pure` supplies Python, pip, certificates, glibc, the
  C++ runtime, and basic shell/Git tools. `LD_LIBRARY_PATH` is set only within the
  project shell so upstream wheels can find libraries in its Guix profile.
- The first Drake import failed on `libglib-2.0.so.0`; Drake's diagnostic also
  listed X11 and SM dependencies. Adding `glib`, `libx11`, and `libsm` to the
  manifest fixed native loading. No Drake source or wheel files were patched.
- Git is included because pip's editable-package inspection consults Git even
  when generating a freeze with editable packages excluded.
- Nested `guix shell --container --emulate-fhs` failed while mounting `/proc`
  with `Operation not permitted`. The launcher uses a regular shell and does not
  require changing the shared container's privileges.
- The user's container daemon uses `--disable-chroot`. Following the existing
  dotfiles workflow, the launcher passes `--no-grafts` to avoid the documented
  interrupted-graft issue. This choice is explicit and also applies elsewhere.
- Drake remains an upstream dependency. Guix is not in its official
  [supported configurations](https://drake.mit.edu/installation.html); runtime
  compatibility is checked here for the listed baseline. Follow its
  [wheel installation guidance](https://drake.mit.edu/pip.html).
- The channels pin the Guix portion; `constraints-guix.txt` pins installed Python
  runtime/development wheel versions. It does not lock wheel hashes, pip's
  isolated build dependencies, or optional notebook packages. Other platforms
  still need their own validation. A pure shell also does not isolate filesystem
  or network access like a container; this is not a fully hermetic Drake build.

## Next smallest milestone

Visually confirm the sphere in a browser, then build one tiny Drake scene that
teaches `MultibodyPlant`, `SceneGraph`, frames, and contexts. Keep the geometric
comparison for a later step. There is still no robot simulation, planner, or
learning code, and no pytest test suite is claimed by this environment check.
