# embodied-tamp

A Python research and learning project on embodiment and task and motion planning
(TAMP), using Drake / pydrake and Meshcat.

**Status: initial scaffold only.** No simulation, robot models, geometric refiner,
planner, or experimental results have been implemented.

## Research question

How can one high-level task representation transfer across robots with different
embodiments when geometric feasibility differs between them?

The working distinction is between a shared description of **what to achieve**
and the embodiment-specific geometry needed to achieve it. The first milestone
explores this distinction with a small, manually specified example.

## Current milestone: the first six weeks

1. Learn enough Drake and the MIT Robotic Manipulation stack to work productively.
2. Build one simple simulation setup and evaluate it with two robot embodiments.
3. Give both embodiments the same abstract action and task parameters.
4. Demonstrate different geometric refinement outcomes caused by their geometry.
5. Document a reproducible comparison and what was learned.

A tentative starting experiment is `reach(target)`: move the end effector into a
named target region in the shared scene. The task contains no robot joint values.
Two simple arms with different link lengths would make reach differences easy to
inspect. The robot pair and target constraints remain to be chosen during learning.

For this milestone, geometric refinement can be as small as finding a joint
configuration satisfying the target and joint limits, plus any explicitly modeled
collision constraints. A feasible configuration alone does not demonstrate a
collision-free path or successful dynamic execution.

The completion evidence should include:

- The same scene, abstract action, target, and success criteria for both robots;
  document exactly which embodiment properties change.
- A control target that both can reach and a discriminating target where the
  outcomes differ, with numerical checks and Meshcat views.
- Solver status, constraint residuals, and a geometric explanation of the
  difference. An unsuccessful solver run alone is not proof of infeasibility.
- A command to repeat the comparison from a fresh checkout and a short report.

## Non-goals

- Implementing a planner or a general TAMP framework in this scaffold.
- Building symbolic search or a general planning language during the first milestone.
- Learning predicates, discovering abstractions, or learning/refining operators.
- Adding ML dependencies, training pipelines, or datasets for learning.
- ROS 2, hardware integration, and physical robot deployment.
- Forking Drake, building a simulator, or adding generic plugin/configuration systems.

Longer-term ideas are parked in [FUTURE_WORK.md](FUTURE_WORK.md). They are research
directions, not an implementation backlog for the first milestone.

## Planned progression

This is a learning plan, not implemented functionality or a fixed delivery promise.

| Week | Focus | Intended evidence |
| --- | --- | --- |
| 1 | Set up Drake; work through relevant MIT manipulation examples. | Environment notes and a small exploratory notebook. |
| 2 | Learn systems, contexts, frames, model loading, and Meshcat. | One simple scene and explained visualization. |
| 3 | Select two embodiments with a clear geometric difference. | Model provenance and a shared scene specification. |
| 4 | Specify one abstract action; use Drake geometry/IK to refine it. | Explicit target constraints and numerical success criteria. |
| 5 | Run the shared task with both embodiments and examine failures. | Control and discriminating cases with recorded outcomes. |
| 6 | Repeat from a clean environment and write up the comparison. | Reproduction instructions, evidence, limitations, and next questions. |

## Setup: Guix

Development uses the existing `orb-guix` environment. On the development Mac,
this alias enters OrbStack's `guix-dev` container, which already mounts the checkout:

```sh
orb-guix
cd /root/Repos/ds/embodied-tamp
./scripts/guix-shell.sh python3 -m venv .venv-guix
./scripts/guix-shell.sh
```

The launcher uses the pinned `channels.scm` and `manifest.scm`, supplies Python
3.12 and native libraries, and activates `.venv-guix` when it exists. The initial
shell, interpreter, and virtual environment have been verified. The next setup
step inside that shell is:

```sh
python -m pip install -e '.[dev]'
python -c "import embodied_tamp; import pydrake; from pydrake.geometry import StartMeshcat"
```

Drake installation and visualization have not yet been verified. This is a
Guix-managed interpreter/native environment with upstream Python wheels, not a
native Guix package definition for Drake. See
[Guix development notes](notes/guix-development.md) for the verified baseline,
portability instructions, and remaining checks. Guix is not listed among Drake's
[officially supported configurations](https://drake.mit.edu/installation.html).

The distribution dependency is named `drake`; its Python imports use `pydrake`.
Use the upstream package, following Drake's
[pip installation guidance](https://drake.mit.edu/pip.html).
Visualization will use Drake's Meshcat integration, as shown in its
[rendering tutorial](https://drake.mit.edu/tutorials/rendering_multibody_plant.html).
No separate Meshcat package is declared.

Optional notebook tools:

```sh
python -m pip install -e '.[dev,notebooks]'
jupyter lab
```

The MIT [Robotic Manipulation Drake chapter](https://manipulation.csail.mit.edu/drake.html)
is the starting learning reference. Course notebooks may need the separate
`manipulation` helper package or additional dependencies. Those are deferred until
a specific example needs them; review dependencies against the no-ML scope before
adding them. The notebook extra here installs JupyterLab and its Python kernel only.

Pytest is configured for `tests/`. Once behavior and tests are added, run:

```sh
python -m pytest
```

There are no tests yet; pytest currently reports no tests collected (exit code 5).
No Drake runtime or simulation validation is claimed by this scaffold.

To continue elsewhere, clone this repository on a Linux machine with Guix, enter
the checkout, and run the same launcher/bootstrap commands. The launcher resolves
the checkout path itself; it does not require OrbStack or `/root/Repos`.

## Repository layout

```text
AGENTS.md                Scope and working rules for future coding sessions
FUTURE_WORK.md           Deferred research directions
pyproject.toml          Package, dependency, and pytest configuration
manifest.scm            Guix interpreter and native runtime dependencies
channels.scm            Pinned Guix channel revisions
scripts/guix-shell.sh   Project development shell
src/embodied_tamp/       Importable package; currently a docstring only
tests/                  Future behavioral and geometric regression tests
notebooks/              Learning exercises and exploratory analysis
models/                 Small model assets and their provenance
experiments/            Future runnable comparisons and input configurations
notes/                  Learning log, decisions, and curated findings
```

Each currently empty work area has a short README explaining its role. Prefer
small Python functions and explicit parameters. Move reusable notebook code into
the package only when there is code worth reusing.

## Reproducibility goals

These are requirements for the eventual comparison, not guarantees of the scaffold:

- Record the git revision, Python/Drake and other dependency versions, OS, and
  architecture. Guix channels are pinned. Python wheel versions are not pinned yet;
  commit tested constraints and installation instructions once Drake works.
- Record robot model sources, versions or checksums, licenses, units, coordinate
  frames, base transforms, and joint limits. Track small inputs in the repository.
- Record task parameters, initial conditions, solver/options, constraint tolerances,
  and simulation time step when applicable. Seed any random sampling explicitly.
- Provide a script runnable from a fresh checkout without hidden notebook state.
  Make numerical checks runnable without opening Meshcat.
- Store generated output under `experiments/outputs/` (gitignored). Keep small,
  curated results and reproduction notes under `notes/` with links to any large
  artifacts and their checksums.
- Repeat numerical checks with documented tolerances; separate solver failure,
  analytically established infeasibility, and untested motion/dynamics claims.

## License

[BSD 3-Clause](LICENSE).
