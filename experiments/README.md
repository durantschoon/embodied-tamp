# Experiments

This directory will hold the first comparison script and its small input
configurations. No experiment or planner is implemented yet.

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
