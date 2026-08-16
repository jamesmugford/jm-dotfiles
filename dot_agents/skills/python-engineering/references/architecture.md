# Architecture Reference

Read this reference for new components, substantial refactors, side-effect
boundaries, data modeling, typing, resources, transactions, security, async
design, or performance-sensitive work.

## Functional core and imperative shell

Use this pattern when separating deterministic decisions from external effects
makes behavior easier to reason about or test:

```text
external input
    -> parsing and validation
    -> deterministic domain transformation
    -> typed outcome
    -> side-effecting adapter
```

A domain function should, where practical:

- receive required information through arguments,
- return its result explicitly,
- avoid hidden I/O and unrelated mutation,
- avoid consulting mutable global application state,
- produce the same result for the same input.

The pattern is not a directory template. Do not create layers merely to match
the diagram. I/O-heavy scripts, ETL pipelines, provisioning workflows, CRUD
handlers, and framework-managed code can remain primarily imperative when that
is the clearest representation of the operation.

Keep decisions that must share a database transaction or resource lifetime
together. Splitting policy from mechanism must not split an invariant across
unsafe transaction boundaries.

## Explicit dependencies

Good candidates for explicit dependencies include:

- clocks and random generators,
- external clients and repositories,
- filesystem and subprocess capabilities,
- identifier generation,
- operating-system or hardware integration.

Use ordinary arguments, constructors, callables, or a small `Protocol` when it
creates a useful seam. Construct concrete infrastructure near the composition
root.

Avoid:

- mutable application state in module globals,
- service locators and implicit registries,
- hard-coded external clients throughout domain logic,
- interfaces with only speculative consumers,
- a dependency-injection framework without a concrete need.

Repetition is one signal for abstraction, not a prerequisite. An external
ownership boundary, volatile integration, or framework contract can justify an
interface before multiple implementations exist.

## Framework-native design

Respect framework extension points and lifecycle rules. Do not wrap an ORM,
serializer, validator, task system, or web framework in generic repositories
and adapters merely to make the code appear architecture-neutral.

Framework classes are appropriate when the framework requires identity,
registration, descriptors, inheritance, metaclasses, or lifecycle callbacks.
Keep domain decisions separate only where that improves clarity without
causing duplicated models, lost validation, transaction leaks, or inefficient
queries.

## Data modeling and typing

Represent mutually exclusive states with an enum, union, or state object when
multiple booleans would permit impossible combinations. Use immutable values
when mutation serves no purpose, but do not create value objects for trivial
data that ordinary Python types express clearly.

Useful options include:

- dataclasses or frozen dataclasses,
- `NamedTuple` or `TypedDict`,
- `Enum` and `Literal`,
- unions and small value objects,
- `Protocol` for structural interfaces.

Treat typing as gradual. Follow the configured checker and the repository's
annotation baseline. Do not assume syntax newer than the supported Python
version.

Static annotations, `cast`, `TypedDict`, `Literal`, and `Protocol` do not
validate runtime input. Convert untrusted values into validated internal data
at boundaries. In annotation-driven frameworks, inspect whether an annotation
change alters schemas, validation, serialization, dependency injection, or ORM
mapping.

## Compatibility and migrations

Before changing an interface, inspect callers and consumers. Observable
contracts can include:

- signatures, import paths, return types, and exception behavior,
- command names, flags, exit codes, and output formats,
- environment variables and configuration keys,
- JSON, event, API, or message schemas,
- database structures and serialized or cached data,
- ordering, timing, transaction, and concurrency guarantees.

When a breaking change is authorized, provide the migration, versioning,
deprecation, or compatibility tests appropriate to the repository. Do not add
compatibility shims for hypothetical consumers.

## Resource and transaction ownership

Make ownership visible for files, sockets, database sessions, locks, tasks, and
temporary resources. Prefer context managers and structured lifecycle APIs.
Ensure cleanup runs on success, failure, and cancellation.

Keep transaction scope aligned with invariants. Avoid network calls while
holding database locks unless required and understood. Retry only operations
whose idempotency and failure semantics make retry safe.

## Async and concurrency

Use async for genuinely asynchronous I/O or concurrency, and honor async
interfaces required by frameworks. Do not make pure computation async solely
because its caller is async.

For asynchronous work:

- do not block the event loop with synchronous I/O or long computation,
- preserve cancellation rather than swallowing it,
- use timeouts where external operations can stall,
- prefer structured task ownership over fire-and-forget work,
- await or explicitly supervise background tasks,
- release resources during cancellation and shutdown,
- limit concurrency when downstream capacity is bounded.

Do not introduce threads, processes, or async concurrency without a concrete
throughput, latency, or responsiveness requirement.

## Trust boundaries and security

Validate syntax and semantics at trust boundaries. Depending on the task,
consider:

- authentication and authorization,
- parameterized SQL and query construction,
- subprocess argument separation and shell injection,
- safe parsing and deserialization,
- path traversal and symlink behavior,
- secrets in logs, errors, and persisted output,
- size, range, cross-field, and resource limits.

Security checks should match the threat model. Do not add elaborate defenses to
code that has no relevant trust boundary, but do not mistake type narrowing for
validation.

## Performance

Preserve important complexity and operational behavior. Watch for:

- eager materialization of large or streaming inputs,
- repeated iterator consumption,
- accidental quadratic loops,
- ORM N+1 queries or changed query counts,
- additional network round trips,
- unbounded concurrency or caches,
- unnecessary copies of large objects.

Profile or measure before adding performance-specific complexity. Keep a clear
implementation when performance is not a demonstrated constraint.
