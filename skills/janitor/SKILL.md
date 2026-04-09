---
name: janitor
description: >-
  Refactor a codebase toward Clean Architecture — fix dependency violations,
  separate layers, extract domain logic, push infrastructure outward. Use when:
  the user asks to "janitor" code, refactor toward clean architecture, reorganize
  layers, fix dependency rule violations, separate concerns, or decouple business
  logic from infrastructure.
allowed-tools: Read, Grep, Glob, Edit, Write, Bash, Agent
---

# Janitor — Clean Architecture Refactoring

> Dependencies flow inward. The Domain layer knows nothing about the outside world.

Read **`references/clean-architecture-guide.md`** before starting.

## Workflow

### 1. Audit

- Map where entities, business logic, persistence, and presentation code live
- Trace import directions, list dependency rule violations
- Present a **ranked list** (highest-impact first) with `file:line` references

### 2. Plan

- For each violation: what moves where, what becomes an interface, what gets injected
- Flag breaking changes — **get user sign-off before executing**

### 3. Execute (one layer at a time)

1. **Domain** — extract entities, value objects, core rules. Define repository/service interfaces here. Strip infrastructure imports. Verify zero outward dependencies.
2. **Application** — create use cases that orchestrate domain logic. Define port interfaces. Use DTOs at boundaries.
3. **Infrastructure** — move persistence, external clients, framework code outward. Implement the interfaces from Domain/Application. Wire dependency injection.
4. **Presentation** — controllers call application use cases only. Map request/response shapes at the boundary.

Run tests after each step.

### 4. Verify

- No circular or outward-pointing dependencies remain
- Linter/build passes, all existing tests still green

## Hard Rules

- **Incremental moves only** — one boundary at a time, tests between each
- **Never delete or break existing tests**
- **Do not rename public APIs** unless necessary to fix a violation
- **No speculative abstractions** — only extract interfaces with a concrete need
- **Keep existing folder names** — do not rename folders to Clean Architecture jargon (`usecases/`, `infrastructure/`, `domain/`, `adapters/`, `ports/`, etc.). The goal is to follow the architecture *functionally* — correct the dependency directions and separate concerns within the project's existing naming conventions. Only create new folders when there is no reasonable existing location for the code.
- **Get user sign-off** on the plan before executing changes
