# Experiments

`meshcat_smoke.py` validates the Drake environment by displaying one static sphere.
It is not a robot simulation, planner, or embodiment comparison.

From the checkout inside `orb-guix` or the Guix project shell:

```sh
just smoke-check
just smoke
```

The first command checks that Meshcat retains the sphere and serves its viewer
page, then exits. The second holds the scene open until Enter or Ctrl-C. On this
Mac, view it at `http://guix-dev.orb.local:7000/`. Native Linux users can run
`just smoke localhost`. Use `just smoke '*' 7001` to select another port.
Browser rendering needs a separate visual check.

Future experiments follow the same convention: `just <name>` for the interactive
demo, `just <name>-check` for the noninteractive check. Only add the pair when
the experiment is implemented. `just` lists the current recipes.

This directory will later hold the first comparison script and its small input
configurations.

Use one shared scene and abstract action with two embodiments. Include a control
case both can solve and a target that exposes their geometric difference. Keep
task parameters and numerical success criteria fixed across robots.

Each experiment should document its command, environment, model sources, initial
conditions, solver settings, tolerances, and expected outputs. Record solver
status and numerical constraint checks as well as Meshcat views. Solver failure
alone does not establish infeasibility.

Write generated output to `experiments/outputs/`, which is gitignored. Store small
curated results and explanations in `notes/`. Use plain scripts and explicit
parameters; no experiment tracking or configuration framework is needed.
