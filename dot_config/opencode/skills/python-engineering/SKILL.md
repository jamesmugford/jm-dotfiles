---
name: python-engineering
description: >
  Mandatory Python engineering standards for creating, modifying, refactoring,
  debugging, or reviewing Python code. Use for all substantive Python work.
  Favors functional-core/imperative-shell architecture, pure and composable
  domain logic, explicit data flow, shallow control flow, strong typing,
  dependency injection at side-effect boundaries, high testability, and
  simple idiomatic Python over clever or stateful designs.
compatibility: OpenCode with Python projects
metadata:
  version: "1.0"
---

# Python Engineering

Apply these standards whenever creating, modifying, refactoring, debugging,
or reviewing Python.

The goal is not functional-programming purity. The goal is Python that is:

1. correct,
2. easy to reason about,
3. easy to test,
4. explicit about state and side effects,
5. simple to change,
6. strongly typed where useful,
7. idiomatic and readable.

Prefer boring, obvious code over clever code.

---

# 1. Functional core, imperative shell

Use **Functional Core / Imperative Shell** as the default architectural
direction.

Keep domain logic and data transformations as pure as reasonably possible.

Keep side effects near identifiable boundaries.

Examples of side effects include:

- filesystem access,
- network access,
- databases,
- subprocesses,
- environment variables,
- clocks,
- randomness,
- UUID generation,
- logging with behavioural significance,
- operating-system APIs,
- GUI interaction,
- hardware interaction.

Prefer:

```text
external world
     |
     v
thin adapter / orchestration
     |
     v
pure domain transformations
     |
     v
typed result
     |
     v
side-effecting adapter
```

Do not force every program into a particular directory structure solely to
match this diagram. Preserve an existing sensible architecture.

## Pure functions by default

Where practical, a domain function should:

- receive all information it needs through arguments,
- return its result explicitly,
- not mutate unrelated state,
- not perform hidden I/O,
- not consult mutable global state,
- produce the same result for the same inputs.

Prefer:

```python
def calculate_total(items: Sequence[Item], tax_rate: Decimal) -> Decimal:
    subtotal = sum(item.price for item in items)
    return subtotal * (Decimal("1") + tax_rate)
```

over a function that secretly reads configuration, queries a database,
updates global state, and calculates the result at the same time.

Pure functions should not be wrapped in classes merely to make them look
architectural.

---

# 2. Make dependencies explicit

Do not hide important dependencies deep inside business logic.

Prefer passing capabilities or collaborators into the code that needs them.

Good candidates for explicit dependencies include:

- clocks,
- random generators,
- external clients,
- repositories,
- filesystem interfaces,
- subprocess runners,
- operating-system integrations.

Construct concrete infrastructure near the application's composition root
rather than throughout the domain code.

Use a `Protocol`, callable, or small explicit interface when abstraction is
actually useful.

Avoid:

- global service locators,
- mutable singletons,
- implicit registries,
- module globals containing application state,
- constructing hard-coded external clients throughout domain code.

Do not introduce dependency-injection frameworks merely to satisfy this rule.
Ordinary function arguments and constructors are usually enough.

---

# 3. Prefer explicit data flow

A reader should normally be able to understand where data comes from and where
it goes by reading function signatures and return values.

Avoid hidden communication through:

- globals,
- ambient mutable state,
- side effects used as return values,
- giant generic `context` dictionaries,
- objects whose attributes are modified from distant parts of the program.

Prefer transformations of the form:

```python
result = transform(input_data)
```

over procedures whose meaningful output is a collection of unrelated mutations.

Mutation is not forbidden. Use local mutation when it is substantially clearer,
more efficient, or naturally represents the algorithm.

Do not contort straightforward Python merely to avoid all mutation.

---

# 4. Keep control flow flat

Prefer guard clauses and early returns.

Good:

```python
def process_user(user: User) -> Result:
    if not user.enabled:
        return Disabled()

    if not user.has_permission:
        return Denied()

    return process_enabled_user(user)
```

Avoid:

```python
def process_user(user: User) -> Result:
    if user.enabled:
        if user.has_permission:
            return process_enabled_user(user)
        else:
            return Denied()
    else:
        return Disabled()
```

Guidelines:

- keep the happy path visually obvious,
- avoid unnecessary `else` after an unconditional `return`, `raise`,
  `continue`, or `break`,
- keep nesting shallow,
- extract a meaningful operation when nesting becomes difficult to follow,
- do not extract functions merely to satisfy an arbitrary line count.

Three or more levels of branching or looping should trigger a design review,
not an automatic extraction.

---

# 5. Prefer functions unless objects genuinely help

Functions plus well-defined data are the default.

Use classes when they genuinely represent one or more of:

- persistent state,
- identity,
- lifecycle,
- invariants,
- resource ownership,
- useful polymorphism,
- cohesive behaviour around state.

Avoid classes that exist only as namespaces:

```python
class StringUtils:
    @staticmethod
    def normalize(value: str) -> str:
        ...
```

Prefer:

```python
def normalize(value: str) -> str:
    ...
```

Be suspicious of unnecessary:

- `Manager`,
- `Service`,
- `Helper`,
- `Utils`,
- `Factory`,
- `Processor`

classes.

These names are not banned. They simply require a real abstraction behind
them rather than being containers for miscellaneous operations.

Prefer composition over inheritance.

Avoid deep inheritance hierarchies.

---

# 6. Model data explicitly

Represent important concepts with meaningful types rather than loose
dictionaries, tuples, strings, and combinations of booleans.

Use as appropriate:

- `dataclass`,
- frozen dataclasses,
- `NamedTuple`,
- `TypedDict`,
- `Enum`,
- `Literal`,
- unions,
- small value objects,
- `Protocol`.

Prefer immutable domain values when mutation serves no purpose.

For example, prefer an explicit status type over arbitrary magic strings.

Avoid boolean parameters when they obscure meaning:

```python
render(document, True, False)
```

Prefer named configuration or meaningful types when the distinction matters.

Do not create custom types for trivial values when ordinary Python types are
clearer.

---

# 7. Use strong, useful typing

Type important code.

At minimum, type:

- public interfaces,
- domain functions,
- architectural boundaries,
- reusable internal functions,
- complex return values.

Prefer precise types over `Any`.

Do not use `Any` merely to silence the type checker.

When untyped or untrusted data crosses a boundary:

1. accept it at the boundary,
2. validate or narrow it,
3. convert it into well-defined internal data,
4. keep the rest of the system typed.

Use the project's configured type checker and typing conventions.

Do not assume a Python syntax version newer than the project supports.

Prefer structural typing with `Protocol` where it removes unnecessary coupling.

Do not create elaborate generic type machinery when a simpler type communicates
the same thing more clearly.

---

# 8. Prefer declarative transformations when clearer

Use Python's expressive collection tools when they make the transformation
obvious:

- comprehensions,
- generator expressions,
- `any`,
- `all`,
- `sum`,
- `min`,
- `max`,
- `sorted`,
- appropriate `itertools` functions.

Good:

```python
active_names = [
    user.name
    for user in users
    if user.active
]
```

Do not mechanically convert loops into `map`, `filter`, `reduce`, or nested
functional pipelines.

Avoid:

```python
active_names = list(
    map(
        lambda user: user.name,
        filter(lambda user: user.active, users),
    )
)
```

when a comprehension is clearer.

An explicit loop is completely acceptable when it is the clearest form.

For example, prefer a straightforward loop when:

- multiple pieces of state evolve together,
- several conditions need meaningful names,
- early exit matters,
- exceptions need local handling,
- the transformation would otherwise become a dense expression.

---

# 9. Use lambdas sparingly

Do **not** prefer lambda functions merely because this skill favours functional
design.

Lambda is appropriate for tiny, immediately obvious operations such as:

```python
sorted(users, key=lambda user: user.name)
```

Prefer a named function when:

- the operation has domain meaning,
- it is reused,
- it contains non-trivial logic,
- naming it improves understanding,
- testing it independently is valuable,
- a lambda would need visual parsing to understand.

Functional architecture is about explicit transformations and controlled
effects, not about maximizing the number of lambdas.

---

# 10. Keep functions cohesive

Each function should have one coherent responsibility at one abstraction level.

Do not mix unrelated levels such as:

- parsing wire data,
- calculating domain rules,
- formatting terminal output,
- writing a file,

inside the same function when those concerns can naturally be separated.

However, do not atomize code into dozens of tiny functions that merely make
the execution path harder to follow.

Extract a function when doing so gives a meaningful concept a name or creates
a useful testable boundary.

Do not extract merely because a function exceeds an arbitrary number of lines.

---

# 11. Keep orchestration thin

Application-level orchestration may legitimately be imperative.

Its job should mostly be:

1. obtain input,
2. call domain/core operations,
3. invoke external capabilities,
4. handle the resulting outcome.

Do not hide significant business rules inside orchestration code merely
because orchestration is already imperative.

Push deterministic decisions toward independently testable functions.

---

# 12. Separate policy from mechanism

Where practical, separate:

- **what should happen** from
- **how the external system performs it**.

Domain code should not need to understand low-level HTTP, SQL, subprocess,
Wayland, filesystem, GUI, or hardware details merely to make a business or
application decision.

Adapters translate between external mechanisms and internal concepts.

Do not create an adapter abstraction when there is no meaningful boundary.

---

# 13. Treat testability as architectural feedback

Important behaviour should normally be testable without constructing the
entire application.

A pure domain function should usually require no mocks.

If a simple business rule requires many mocks, patches, globals, or fixtures
just to execute, reconsider the design.

Prefer, in roughly this order:

1. pure input/output tests,
2. real lightweight values,
3. small fakes or stubs,
4. mocks where interaction itself is the behaviour being tested.

Do not mock implementation details simply to achieve isolation.

Test observable behaviour.

Tests should survive harmless internal refactoring.

For bugs, when practical:

1. reproduce the bug with a failing regression test,
2. make the smallest coherent fix,
3. verify the regression test passes,
4. run the relevant wider test suite.

Use property-based testing when a pure transformation has useful invariants
or a large meaningful input space and the project already uses or can
reasonably use such tooling.

---

# 14. Make nondeterminism controllable

Time, randomness, environment state, and generated identifiers make tests
fragile when accessed implicitly throughout domain logic.

Prefer designs such as:

```python
def expire_sessions(
    sessions: Sequence[Session],
    now: datetime,
) -> list[Session]:
    ...
```

rather than calling the wall clock repeatedly from deep inside the operation.

Likewise, inject or pass randomness when deterministic testing matters.

Do not abstract nondeterminism unnecessarily if it has no effect on important
behaviour.

---

# 15. Handle errors deliberately

Do not use bare `except:`.

Catch the narrowest exception you can meaningfully handle.

Do not swallow failures silently.

Do not catch an exception only to immediately lose useful diagnostic context.

Use exception chaining where appropriate.

Expected domain outcomes do not automatically need to be exceptions.

Represent meaningful expected states explicitly when that makes callers easier
to reason about.

Do not build elaborate `Result` abstractions merely to imitate languages that
use algebraic result types if ordinary Python exceptions or unions are clearer.

---

# 16. Avoid boolean-state explosions

Be wary when several booleans combine to represent one logical state.

For example:

```python
is_started
is_finished
is_failed
is_cancelled
```

may permit impossible combinations.

When states are mutually exclusive or have meaningful transitions, model the
state explicitly with an enum, union, or appropriate state object.

Make invalid states difficult to represent where doing so remains simple.

---

# 17. Async only where it belongs

Use async for genuinely asynchronous concurrency and I/O.

Do not make pure computation asynchronous merely because the surrounding
application is async.

Avoid async spreading through the domain core without a genuine reason.

Do not introduce concurrency until it solves an observed requirement.

Keep async boundaries obvious.

---

# 18. Avoid speculative abstraction

Do not design for hypothetical future requirements unless the current task
requires them.

Prefer the smallest abstraction that cleanly represents the concepts that
actually exist.

A little duplication is often cheaper than the wrong abstraction.

Do not introduce:

- unnecessary base classes,
- plugin systems without plugins,
- generic repositories with one concrete operation,
- factories for trivial constructors,
- configuration layers for constants that do not need configuration,
- generic frameworks around a single use case.

Refactor toward an abstraction when repeated behaviour demonstrates the
abstraction rather than guessing it in advance.

---

# 19. Do not be clever

Avoid code whose main virtue is compactness.

Avoid:

- dense one-liners,
- deeply nested comprehensions,
- clever metaprogramming without a concrete need,
- unnecessary decorators,
- obscure operator tricks,
- excessive indirection,
- unexpected mutation,
- implicit control flow.

Readable intermediate variables are good.

A few extra straightforward lines are preferable to one difficult expression.

---

# 20. Preserve locality

Code that changes together should generally be understandable together.

Do not scatter a simple operation across many abstraction layers without a
clear architectural reason.

Avoid forcing readers to jump between five files to understand a trivial
transformation.

Architecture should reduce cognitive load, not merely increase the number of
layers.

---

# 21. Respect project conventions

Before making substantive changes, inspect the repository.

Determine, where available:

- supported Python version,
- package/dependency manager,
- `pyproject.toml`,
- existing architecture,
- formatter,
- linter,
- type checker,
- test framework,
- test layout,
- CI commands,
- repository instructions,
- established naming and public API conventions.

Follow existing sensible conventions rather than imposing arbitrary new ones.

Project-specific instructions override generic preferences in this skill when
they explicitly conflict.

Do not perform unrelated repository-wide refactoring while completing a
focused task.

---

# 22. Dependencies

Prefer the standard library when it solves the problem cleanly.

Do not avoid a well-established dependency merely to save one dependency if
reimplementing it would create significant complexity or risk.

Before adding a dependency, ask:

- Does the project already contain something suitable?
- Is the dependency solving enough complexity to justify itself?
- Is the dependency maintained and appropriate for the project's constraints?

Do not introduce a new package solely because it saves a few obvious lines.

---

# 23. Documentation and comments

Names should carry most of the explanation.

Comments should primarily explain:

- why something is necessary,
- non-obvious constraints,
- external quirks,
- invariants,
- subtle trade-offs.

Do not write comments that merely translate the following line of Python into
English.

Document public APIs and non-obvious behaviour according to the repository's
existing documentation style.

---

# 24. Verification is part of implementation

Do not claim that a change is complete based only on visual inspection.

First discover the repository's existing verification commands.

Use repository-provided commands where available, including those defined in:

- `AGENTS.md`,
- `pyproject.toml`,
- CI configuration,
- `Makefile`,
- `justfile`,
- `tox`,
- `nox`,
- task-runner configuration,
- project documentation.

Run the checks relevant to the changed code.

Where the project already uses them, this will commonly include:

- formatter verification,
- linting,
- static type checking,
- unit/integration tests.

If a project has no established equivalents and the tools are already
available, reasonable Python defaults are:

```text
ruff format --check .
ruff check .
pyright
pytest
```

Do not install or impose new project tooling merely because those defaults are
listed here.

For a new Python project, establish appropriate formatting, linting, type
checking, and testing early rather than waiting until the project is large.

Do not declare success while relevant checks are failing.

If a check cannot be run, state that clearly rather than pretending it passed.

---

# 25. Required self-review

Before considering substantial Python work complete, review the changed design.

For each substantial changed function or component, ask:

1. Can the important logic be pure?
2. Is it performing I/O that belongs at a boundary?
3. Does it read or modify hidden state?
4. Are important dependencies explicit?
5. Is the data flow obvious from parameters and return values?
6. Is mutation necessary or merely convenient?
7. Can guard clauses make the control flow flatter?
8. Is nesting unnecessarily deep?
9. Is a class being used where functions plus typed data would be simpler?
10. Is an abstraction solving a real current problem?
11. Can important behaviour be tested without excessive mocking?
12. Are invalid states representable unnecessarily?
13. Are types precise enough to communicate intent?
14. Is there a straightforward loop that is clearer than a clever expression?
15. Is a lambda obscuring a meaningful operation?
16. Is async or concurrency actually required?
17. Could another engineer understand the code without tracing distant state?
18. Have relevant formatter, lint, type, and test checks been run?

If the review identifies unnecessary complexity, simplify before finishing.

---

# 26. Priority when rules compete

These principles are guidelines toward good engineering, not syntax games.

When principles conflict, prefer in this order:

1. correctness,
2. explicit behaviour,
3. testability,
4. simplicity,
5. readability,
6. consistency with the existing project,
7. functional purity,
8. terseness.

A simple explicit loop is better than an obscure functional pipeline.

A small amount of local mutation is better than a convoluted immutable design.

A cohesive stateful object is better than pretending genuinely stateful
behaviour is stateless.

Idiomatic Python is more important than mimicking Haskell, Rust, Scala, or
another language.

The desired outcome is code whose behaviour and state transitions are easy
for both humans and future coding agents to reason about.
