# Implementation Reference

Read this reference when writing or reviewing non-trivial function bodies,
control flow, mutation, classes, exceptions, dependencies, or documentation.

## Explicit data flow

A reader should normally understand where important data comes from and where
it goes by reading function signatures and return values.

Avoid hidden communication through:

- ambient mutable state,
- side effects used as return values,
- giant generic context dictionaries,
- objects whose attributes are modified from distant code,
- implicit registries that conceal dependencies.

Mutation is not forbidden. Local mutation is often the clearest way to express
an algorithm. Keep its scope small and ownership obvious.

## Flat control flow

Prefer guard clauses when they make the happy path easier to see:

```python
def process_user(user: User) -> Outcome:
    if not user.enabled:
        return Disabled()
    if not user.has_permission:
        return Denied()
    return process_enabled_user(user)
```

Avoid unnecessary `else` blocks after `return`, `raise`, `continue`, or
`break`. Three or more levels of branching or looping should prompt a design
review, not automatic function extraction.

Name a condition or operation when doing so explains intent. Do not split a
short coherent flow into tiny helpers that force readers to jump between files.

## Functions and objects

Prefer functions plus well-defined data for stateless transformations. Use a
class when it genuinely represents:

- persistent state or identity,
- lifecycle or resource ownership,
- invariants around mutable state,
- useful polymorphism,
- a required framework extension point.

Avoid classes used only as namespaces for unrelated static methods. Names such
as `Manager`, `Service`, `Helper`, `Utils`, `Factory`, and `Processor` are not
banned, but they should name a cohesive abstraction rather than miscellaneous
operations.

Prefer composition over deep inheritance except where a framework contract
requires inheritance.

## Cohesion and locality

Keep each function at a coherent abstraction level. Parsing wire data,
calculating a domain rule, formatting output, and writing a file are different
concerns when they can be separated naturally.

Extract code when the result:

- gives a meaningful concept a name,
- creates a useful test or ownership boundary,
- removes difficult nesting,
- is reused with the same semantics,
- keeps related behavior easier to understand.

Do not extract solely because of a line-count rule. A little duplication can be
cheaper than the wrong abstraction.

## Loops and declarative transformations

Use comprehensions, generator expressions, `any`, `all`, `sum`, `min`, `max`,
`sorted`, and `itertools` when they make a transformation obvious.

Prefer an explicit loop when:

- several pieces of state evolve together,
- early exit or local exception handling matters,
- conditions need meaningful names,
- a comprehension would become nested or dense,
- preserving laziness or performance is clearer in loop form.

Do not mechanically replace readable loops with `map`, `filter`, `reduce`, or
nested functional pipelines.

Use lambdas for tiny, immediate operations such as a simple sort key. Prefer a
named function when the operation has domain meaning, is reused, contains
non-trivial logic, or benefits from independent testing.

## Parameters and data shapes

Avoid positional boolean arguments that obscure meaning:

```python
render(document, True, False)
```

Try keyword-only parameters or an existing enum before creating a new settings
object. Introduce a dedicated configuration type only when several related
values form a meaningful concept.

Use precise return types for complex outcomes. Do not create a custom `Result`
framework when ordinary exceptions, unions, or explicit outcome types are
clearer.

## Exceptions

- Never swallow failures silently.
- Catch the narrowest exception that can be handled meaningfully.
- Preserve context with exception chaining where it adds information.
- Use bare `raise` to preserve the current traceback.
- Prefer context managers or `finally` for cleanup.
- Do not catch an exception only to log and discard essential diagnostics.

Avoid bare `except:` for normal handling. A rare cleanup or diagnostic block
may intentionally catch every exception only when it immediately re-raises;
use `finally` when it expresses the lifecycle more clearly.

Expected domain outcomes do not automatically need to be exceptions. Model
them explicitly when doing so makes caller behavior clearer.

## Dependencies

Prefer the standard library when it solves the problem clearly. Before adding a
dependency, determine:

- whether the project already has a suitable capability,
- whether the dependency removes meaningful complexity or risk,
- whether it supports the project's Python and platform constraints,
- whether it is maintained and appropriate for the trust boundary,
- how it affects packaging, startup, and deployment.

Do not reimplement substantial, security-sensitive, or protocol-heavy behavior
merely to avoid one established dependency. Do not add a package to save a few
obvious lines.

## Documentation and comments

Let names and structure carry most explanations. Comments should primarily
explain:

- why a workaround or constraint exists,
- external quirks and compatibility requirements,
- invariants and transaction assumptions,
- subtle trade-offs or non-obvious performance behavior.

Do not write comments that translate the following line into English. Document
public APIs according to the repository's established style.

## Simplicity

Avoid code whose main virtue is compactness:

- dense one-liners and nested comprehensions,
- clever metaprogramming without a concrete requirement,
- unnecessary decorators and factories,
- obscure operator tricks,
- unexpected mutation and implicit control flow,
- indirection that does not reduce complexity.

Readable intermediate variables and a few straightforward lines are usually
better than a compact expression that needs visual decoding.
