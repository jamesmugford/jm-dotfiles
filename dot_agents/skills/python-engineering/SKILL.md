---
name: python-engineering
description: >
  Python engineering workflow for substantive implementation, refactoring,
  debugging, review, test design, dependency changes, and Python project tooling.
  Use when changing or evaluating Python behavior, architecture, tests, or
  pyproject.toml. Do not use for simple explanations, file discovery, or tasks
  that merely use Python as a utility.
metadata:
  version: "2.0"
---

# Python Engineering

Use this skill to make focused, compatible, well-verified Python changes. Its
workflow requirements are mandatory. Its design advice is a set of defaults to
apply only when it fits the task, repository, and framework.

## Instruction hierarchy

Apply guidance in this order:

1. User requirements, authorized scope, and safety constraints.
2. Repository instructions and supported Python/runtime versions.
3. Public, persisted, and externally observable behavior.
4. Existing architecture, framework conventions, and configured tooling.
5. The workflow requirements and engineering defaults in this skill.

Generic preferences never justify unrelated refactoring, breaking a supported
contract, bypassing a framework extension point, or replacing established
project tooling.

In reviews, report correctness, security, compatibility, and maintainability
risks as findings. Label preference-based suggestions as optional rather than
presenting them as defects.

## Load detail only when needed

Keep the core workflow in this file. Read the relevant reference before making
decisions in that area:

- [Architecture](references/architecture.md): new components, substantial
  refactors, boundaries, data modeling, typing, resources, transactions,
  security, async design, or performance-sensitive work.
- [Implementation](references/implementation.md): non-trivial function bodies,
  control flow, mutation, classes, exceptions, dependencies, or documentation.
- [Testing](references/testing.md): bug fixes, test design, test doubles,
  nondeterminism, verification strategy, or failing checks.

Do not read every reference mechanically when only one is relevant.

## Required workflow

Apply only the steps relevant to the task mode. In a read-only review, inspect
and report findings; do not edit files or run mutating checks unless the user
requests it.

### 1. Discover repository constraints

Before substantive implementation decisions, inspect what is available:

- repository instruction files such as `AGENTS.md` or `CLAUDE.md`,
- supported Python versions,
- `pyproject.toml` and dependency or environment manager,
- existing architecture and framework patterns,
- formatter, linter, type checker, and test configuration,
- CI or task-runner commands,
- nearby tests, callers, and public interfaces.

Prefer repository-provided commands and conventions over generic defaults.

### 2. Define the change contract

Identify the behavior that must change and what must remain stable. Check, when
relevant:

- function signatures, imports, exceptions, and return values,
- command-line and configuration behavior,
- wire formats, serialized data, database schemas, and persisted state,
- framework-generated schemas or validation behavior,
- performance, ordering, transaction, and concurrency guarantees.

Do not add backward compatibility speculatively, but preserve shipped or
persisted contracts unless the task authorizes a breaking change.

### 3. Reproduce or establish a baseline

For a bug, reproduce it with the smallest useful failing test or command when
practical. For other changes, run a focused baseline check when it helps
distinguish existing behavior or failures from regressions.

### 4. Make the smallest coherent change

- Keep the change within the requested scope.
- Preserve sensible local architecture and naming.
- Put deterministic decisions in independently testable code when doing so
  creates a real reasoning or testing seam.
- Keep side effects, ownership, and transaction boundaries explicit.
- Avoid speculative abstractions, dependencies, and repository-wide cleanup.

### 5. Verify with project-aware checks

Run the narrowest configured checks that meaningfully cover the change, then
widen when risk warrants it. This can include formatting, linting, typing,
unit tests, integration tests, contract tests, or end-to-end checks.

Before running any check, consider whether it writes files or external state,
uses credentials, starts services, or invokes production-like integrations.
Use a safer or narrower mode when available.

Do not install tools or impose unconfigured defaults merely because they are
common Python tools. Do not run broad integration suites without considering
their services, cost, and side effects.

Classify failures honestly as introduced, pre-existing, environmental, flaky,
or unrelated. Fix introduced failures. Report other failures and any checks
that could not be run; they do not automatically invalidate an otherwise
correct focused change. Redact credentials, tokens, and sensitive values from
reported commands and output.

### 6. Review the result

Before finishing, ask:

1. Does the change satisfy the requested behavior without breaking contracts?
2. Is important state and data flow visible rather than hidden globally?
3. Are side effects, resources, transactions, and async tasks safely owned?
4. Is the implementation simpler than plausible alternatives?
5. Do tests cover the behavior at the appropriate boundaries?
6. Were relevant configured checks run and their results reported accurately?

Simplify accidental complexity before declaring the work complete.

## Engineering defaults

### Architecture

Prefer a functional core and imperative shell when the code contains
deterministic decisions that benefit from isolation. Do not force this pattern
onto small scripts, I/O workflows, CRUD code, or framework-native designs where
extra layers would obscure behavior.

Make important dependencies explicit through ordinary parameters,
constructors, callables, or small protocols when an abstraction is genuinely
useful. Avoid service locators, mutable singletons, hidden registries, and a DI
framework introduced solely to satisfy this preference.

Prefer functions plus explicit data unless objects genuinely represent state,
identity, lifecycle, invariants, resource ownership, or useful polymorphism.
Prefer composition over deep inheritance, while respecting framework-required
base classes and callbacks.

### Data and typing

Model important states and concepts explicitly. Use dataclasses, enums,
`TypedDict`, unions, `Literal`, `Protocol`, or ordinary Python types when they
make invalid states and interfaces easier to understand.

Apply gradual static typing according to the repository's baseline. Type new
or materially changed public interfaces, boundaries, and complex logic where
useful. Do not add broad annotation churn or use `Any` merely to silence a
checker.

Type hints are not runtime validation. Parse and validate untrusted input at
trust boundaries. Remember that annotations can affect runtime behavior in
frameworks such as Pydantic, FastAPI, SQLAlchemy, and dataclasses.

### Control flow and state

Keep the happy path visible with guard clauses and shallow nesting. Prefer
explicit return values and local state over communication through unrelated
mutation or ambient globals.

Local mutation and straightforward loops are acceptable when they are clearer
or more efficient than an immutable or declarative alternative. Do not trade
readability for functional-programming purity.

Keep code that changes together understandable together. Extract a function or
module when it names a meaningful concept, creates a useful boundary, or
reduces genuine complexity, not to satisfy arbitrary size limits.

### Reliability and safety

Catch only exceptions that can be handled meaningfully. Preserve diagnostic
context and tracebacks. Use context managers or `finally` for deterministic
cleanup, and keep operations that must be atomic inside an appropriate
transaction boundary.

For async code, avoid blocking the event loop, propagate cancellation, use
timeouts where operations can stall, and give background tasks explicit
ownership and cleanup. Keep interface-required functions async even when their
current body is simple.

At trust boundaries, consider authorization, parameterized SQL, subprocess
argument handling, safe deserialization, path traversal, secrets, and semantic
validation as relevant to the task.

Preserve asymptotic complexity, laziness, query counts, and memory behavior.
Measure before introducing performance-driven complexity.

## Testing defaults

Choose tests by risk rather than treating one level as universally superior:

- pure unit tests for deterministic transformations,
- integration tests for adapters, transactions, framework wiring, and real
  serialization behavior,
- contract tests for external assumptions and significant fakes,
- end-to-end tests for critical user-visible workflows.

Test observable behavior rather than private implementation details. Prefer
real lightweight values and small fakes; use mocks when interaction itself is
the behavior under test.

For bugs, add a regression test when practical. Use property-based testing when
meaningful invariants and input spaces justify it and the project already uses
or can reasonably support the approach.

## Priority when defaults compete

Prefer, in order:

1. authorized task behavior and safety,
2. compatibility and persisted contracts,
3. repository and framework constraints,
4. correctness and explicit behavior,
5. appropriate verification and testability,
6. simplicity, readability, and locality,
7. functional purity and terseness.

The desired result is idiomatic Python whose behavior, state transitions, and
operational risks are easy for another engineer to understand.
