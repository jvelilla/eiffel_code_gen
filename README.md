# Eiffel LLM Codegen — Project Overview

This repository contains a set of rules and examples used to generate valid, idiomatic, contract-driven Eiffel code with large language models (LLMs). It documents strict formatting, naming, and Design by Contract (DBC) conventions so generated Eiffel is real, compilable, and maintainable.

**Contents:**
- **`Eiffel.md`**: Core rules and templates for generating Eiffel code (class templates, escaping rules, agents, once classes, loops, contracts, and more).
- **`Agents.md`**: Guidelines for AI agents used in Eiffel code generation (agent behaviour, output modes, safety and DBC expectations).
- **`Cursor.md`**: (If present) supplementary notes about cursor and iteration conventions used by the project.
- **`examples/`**: Small Eiffel examples and templates to illustrate the rules (`agent_example.e`, `class_template.e`, `minimal_example.e`).

**Purpose**
- Provide an authoritative, machine-readable guide for producing Eiffel code with an LLM.
- Enforce strict rules (naming, tabs, assertion labeling, attached-by-default types, symbolic loops in contracts, etc.) so generated code is predictable and correct.

**Who is this for?**
- LLM developers building Eiffel code generators or assistants.
- Engineers needing a consistent Eiffel style and contract ruleset for automated code generation.

**Quick usage**
- Read `Eiffel.md` to understand the mandatory code generation rules and final checklist.
- Inspect `examples/` to see minimal runnable Eiffel examples that follow the rules.
- Use `Agents.md` for instructions when implementing AI agents that will produce or validate Eiffel code.

**Contributing**
- Suggest edits via pull requests. Keep changes minimal and focused on specific rules.
- When updating rules, include rationale and examples demonstrating the change.

**Next steps (suggested)**
- Review `Eiffel.md` to confirm the assertion and formatting rules match your toolchain.
- Add a `LICENSE` file if you intend to publish the project.
- Optionally add CI checks to validate style (tab indentation) and run small Eiffel compiler checks on `examples/`.
