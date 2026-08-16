# Testing and Verification Reference

Read this reference for bug fixes, test design, test doubles, nondeterminism,
verification strategy, or failing checks.

## Select tests by risk

Different test levels answer different questions:

- Unit tests exercise deterministic behavior quickly and precisely.
- Integration tests validate adapters, database behavior, transaction scope,
  serializers, framework wiring, and real resource interactions.
- Contract tests validate assumptions shared with external services and keep
  significant fakes aligned with reality.
- End-to-end tests validate critical user-visible workflows across boundaries.

These levels are complementary. A pure unit test does not prove that SQL
constraints, serialization, framework registration, or HTTP assumptions work.
An end-to-end test alone may make a small domain rule difficult to diagnose.

Choose the narrowest level that can fail for the behavior at risk, then add
boundary coverage where integration is part of that risk.

## Test observable behavior

Tests should survive harmless refactoring. Assert public outcomes, state
transitions, persisted effects, emitted messages, or required interactions
rather than private helper calls and incidental implementation order.

Prefer, as appropriate:

- pure input/output examples,
- real lightweight values,
- small fakes or stubs,
- mocks when the interaction itself is the behavior being specified.

Excessive patching and mocks are architectural feedback. If a simple rule needs
many mocks merely to execute, consider whether hidden dependencies or mixed
concerns are making the code difficult to test.

Do not replace necessary integration coverage with a fake. Give important
fakes contract tests or shared behavioral tests when drift would be costly.

## Bug fixes

When practical:

1. Reproduce the bug with a focused failing test or command.
2. Confirm the failure represents the reported behavior rather than a setup
   error.
3. Make the smallest coherent fix.
4. Run the regression test.
5. Run relevant neighboring and wider checks according to risk.

When a regression test is impractical, explain why and verify the behavior by
the strongest safe alternative available.

## Nondeterminism

Time, randomness, environment state, generated identifiers, network behavior,
and scheduling make tests fragile when accessed implicitly throughout domain
logic.

Pass deterministic values or small capabilities into important logic when
control matters. For example, pass `now` into an expiration calculation rather
than reading the wall clock repeatedly inside it.

Do not abstract nondeterminism that has no effect on meaningful behavior. Keep
real integration tests for the adapter that reads the clock, environment, or
external service.

For async tests, avoid sleeps as synchronization. Await explicit events,
conditions, or task completion. Test cancellation, timeout, and cleanup behavior
when those paths affect correctness.

## Property-based testing

Use property-based testing when a transformation has meaningful invariants or a
large input space that examples cover poorly, and when the project already uses
or can reasonably support the tooling.

Good properties describe behavior, such as round-trip preservation,
monotonicity, idempotency, bounds, or equivalence to a trusted implementation.
Do not add property tests that merely restate the implementation.

## Discover verification commands

Inspect the repository before choosing commands. Useful sources include:

- `AGENTS.md`, `CLAUDE.md`, and project documentation,
- `pyproject.toml`, lockfiles, and environment-manager configuration,
- CI workflows,
- `Makefile`, `justfile`, `tox.ini`, and `noxfile.py`,
- existing contributor documentation and neighboring tests.

Use the project's environment manager so checks run with the intended Python
and dependencies. Prefer targeted commands first, such as the changed test
module or package, then widen when the change has broader risk.

Common tools such as Ruff, Pyright, Mypy, and Pytest are appropriate only when
the repository configures or deliberately adopts them. Their presence on
`PATH` does not establish the correct configuration or environment.

Do not install or impose tooling during a focused change without user approval
or a new-project requirement.

## Interpret failures

Do not equate every failing command with a regression. Determine whether a
failure is:

- introduced by the change,
- pre-existing in the baseline,
- caused by a missing service, dependency, credential, or platform feature,
- flaky or timing-dependent,
- unrelated to the changed scope.

Fix introduced failures before finishing. Report other failures with the
sanitized command and relevant evidence. Redact credentials, tokens, private
paths, and other sensitive values. Do not hide failures, and do not claim a
check passed when it did not run.

An unrelated or environmental failure does not automatically make a focused
change incomplete if the changed behavior was verified appropriately and the
limitation is clear.

## New projects

For a genuinely new Python project, establish an appropriate formatter,
linter, type checker, and test runner early. Choose tools that fit the target
Python versions and deployment environment rather than mechanically installing
a fixed stack.

Document the canonical commands so future changes use the same environment and
verification path.
