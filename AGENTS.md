# embodied-tamp agent instructions

## Project purpose

This repository studies embodiment-aware task and motion planning.

The long-term research question is how shared high-level task representations
can transfer across robot embodiments whose geometric feasibility conditions differ.

## Current scope

The current milestone is deliberately small:

- Python
- Drake / pydrake
- Meshcat
- simulation only
- two simplified embodiments
- one shared abstract task/action
- embodiment-dependent geometric feasibility

## Explicit non-goals for the current milestone

Do not introduce unless specifically requested:

- ROS 2
- physical robot drivers
- reinforcement learning
- neural policies
- vision-language models
- learned predicates
- operator learning
- PDDL infrastructure unless a concrete need emerges
- distributed robotics infrastructure
- custom locomotion controllers

Prefer the smallest implementation that demonstrates the research phenomenon.

## Architecture principle

Keep high-level planning separate from embodiment-specific geometric refinement.

Prefer:

task abstraction
    -> refinement / feasibility
    -> Drake geometry and motion planning
    -> simulation

Later physical execution may occur through ROS 2, but ROS 2 is not part of the
current milestone.

## Development principles

- Keep dependencies minimal.
- Prefer readable research code over framework-heavy abstractions.
- Add tests for geometric/planning logic.
- Make experiments reproducible.
- Do not modify or fork Drake unless absolutely necessary.
- Before expanding project scope, explain why the existing architecture is insufficient.

## Development environment

- Use the existing `orb-guix` setup for development and validation.
- On this Mac, it enters OrbStack's `guix-dev` container; the checkout is mounted
  at `/root/Repos/ds/embodied-tamp`.
- Use `scripts/guix-shell.sh` for the project environment. Keep Guix inputs in
  `manifest.scm` and channel revisions in `channels.scm`.
- Expose routine commands as small `justfile` recipes. Use `just <name>` for an
  interactive experiment and `just <name>-check` for its noninteractive check.
  Add recipes only for implemented experiments; keep `just check` noninteractive.
- Keep upstream Python wheels in `.venv-guix/`, separate from any macOS environment.
- Use `constraints-guix.txt` for the validated runtime/development wheel versions.
- Run `just check` inside `orb-guix` or the project shell to check dependencies,
  the native runtime, and the Meshcat server. It does not test robot behavior.
- Document verified setup steps and limitations in `notes/guix-development.md`.
