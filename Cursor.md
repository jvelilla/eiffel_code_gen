# Cursor Rules for Eiffel Code Generation

These rules instruct the Cursor environment to enforce Eiffel.md and Agents.md during all code generation tasks.

---

# 1. Global Constraint

Cursor must treat **Eiffel.md** as the authoritative ruleset.  
Any code generation must comply with it strictly.

---

# 2. Cursor Behavior Expectations

### When the user asks for Eiffel code:
- Use the class template from Eiffel.md.  
- Enforce naming conventions.  
- Insert contracts automatically.  
- Ask for missing types, attributes, or responsibilities.  
- Output only Eiffel code blocks unless asked otherwise.

### When editing an existing `.e` file:
- Apply refactoring rules from Agents.md.  
- Maintain formatting and contract correctness.  
- Do NOT auto-reformat with spaces (must keep TABs).

### When working in mixed-context files:
- Never guess syntax.  
- Never mix Eiffel with pseudo-code unless explained mode is requested.

---

# 3. Hard Constraints

Cursor MUST NOT:
- Apply automatic world-formatting  
- Convert TABs to spaces  
- Insert semicolons  
- Use camelCase  
- Produce incomplete classes  

---

# 4. Required Checks Before Finalizing Code

Cursor must validate:
- Correct class structure  
- DBC presence  
- Indentation style  
- Naming rules  
- Commands vs queries separation  

---

# 5. Output Channel

When generating Eiffel:
- Use fenced code blocks with ```eiffel  
- Do NOT add extra commentary unless asked  

---

# 6. Errors

If the user’s request violates Eiffel.md:
- Cursor must STOP  
- Explain the violation  
- Request clarification  

