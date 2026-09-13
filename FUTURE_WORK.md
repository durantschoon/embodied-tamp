# Future work

These directions remain relevant to the research question, but are **outside the
first six-week milestone**. They are not scheduled implementation tasks. Revisit
them after the two-embodiment geometric comparison is reproducible and a later
request explicitly expands scope.

## Learning embodiment-specific symbolic predicates

Research question: can continuous experience reveal symbolic conditions describing
when a shared abstract task is geometrically feasible for a particular embodiment?

Questions to investigate later include how to condition predicates on embodiment,
what continuous evidence supports their meaning, how to represent uncertainty,
and whether they generalize to held-out tasks or robots.

For now, use manually specified task semantics and numerical geometric checks.
Do not add predicate learners, feature pipelines, learning datasets, or ML dependencies.

## Learning or refining planning operators

Research question: can failed geometric refinements improve the preconditions or
effects of high-level operators while retaining a shared task representation?

Future work must distinguish actual geometric limitations from numerical solver
failures before treating failures as evidence. Other open questions include when
to revise a shared operator versus an embodiment-specific condition, and how to
evaluate whether a revision helps on new cases.

For now, record and explain geometric outcomes. Do not build an operator learner,
automatic operator updates, symbolic planner, or failure-driven learning loop.

## Eventual ROS 2 integration

Research question: how will the shared task and geometric refinement interface
connect to physical robots with measured state, calibration error, and execution
uncertainty?

Revisit ROS 2 only with a concrete hardware experiment and an explicit scope
decision. No ROS packages, bridges, hardware drivers, or speculative middleware
interfaces belong in the current milestone.

## Before expanding scope

Finish and explain the simple comparison first. Use its evidence and limitations
to select a focused next research question, define an evaluation, and update
`README.md` and `AGENTS.md` to reflect the new scope before implementation.
