# Guix development

## Baseline verified on 2026-09-13

The existing `orb-guix` alias in the user's dotfiles enters OrbStack's `guix-dev`
Docker container. The project reuses that container and its persistent Guix store.
The Mac checkout at `/Users/durant/Repos/ds/embodied-tamp` is mounted at
`/root/Repos/ds/embodied-tamp`.

- Container image: `metacall/guix@sha256:e028ebad915a2ff1e4b91680444600dd6712214cf2c7cb0bcb6ebd5fe8891afe`.
- Guest: Debian 13, Linux `x86_64`.
- Guix commit: `df2d121208127ac22f10e0f7c2f38d6c74e106a3`.
- Nonguix commit: `73baab37361b3a81f326aa3fdec78840f5acc577`.
- Project interpreter: Guix Python 3.12.12, built with GCC 14.3.0.
- `scripts/guix-shell.sh python3 --version` succeeds.
- Creating `.venv-guix` succeeds; the launcher selects its Python and pip.
- Drake and pytest are not installed yet. Import and Meshcat checks remain open.

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

Inside the project shell, the next dependency installation and checks are:

```sh
python -m pip install -e '.[dev]'
python -m pip check
python -c "import embodied_tamp; import pydrake; from pydrake.geometry import StartMeshcat"
```

For automation from this Mac, the equivalent entry is:

```sh
docker --context orbstack exec -w /root/Repos/ds/embodied-tamp guix-dev \
  sh -lc './scripts/guix-shell.sh python --version'
```

The project does not provision a container on other machines. Start with Guix
installed and working there. A fresh checkout recreates `.venv-guix`; do not copy
the virtual environment between machines or use its Linux binaries on macOS.

## Compatibility decisions

- A regular `guix shell --pure` supplies Python, pip, certificates, glibc, and the
  C++ runtime. `LD_LIBRARY_PATH` is set only within the project shell so upstream
  wheels can find libraries in its Guix profile. Actual Drake loading is still
  to be checked; additional native runtime inputs may be needed.
- Nested `guix shell --container --emulate-fhs` failed while mounting `/proc`
  with `Operation not permitted`. The launcher uses a regular shell and does not
  require changing the shared container's privileges.
- The user's container daemon uses `--disable-chroot`. Following the existing
  dotfiles workflow, the launcher passes `--no-grafts` to avoid the documented
  interrupted-graft issue. This choice is explicit and also applies elsewhere.
- Drake remains an upstream dependency. Guix is not in its official
  [supported configurations](https://drake.mit.edu/installation.html); runtime
  compatibility must be demonstrated here. Follow its
  [wheel installation guidance](https://drake.mit.edu/pip.html).
- The shell and channels pin the Guix portion. Python wheels are not yet pinned,
  and a pure shell does not isolate filesystem or network access like a container.
  This is not a fully hermetic Drake build.

## Next smallest milestone

Install `.[dev]` inside this environment, check native library loading, and verify
one minimal Meshcat visualization. Check browser access from the Mac: the existing
container has no published ports, so the appropriate OrbStack network address or
forwarding route needs to be verified. Then record Python wheel versions and the
exact working commands. No planner, robot comparison, or learning code is needed.
