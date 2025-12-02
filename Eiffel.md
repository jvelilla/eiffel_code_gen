# Eiffel.md — LLM Code Generation Rules for Eiffel

This document defines strict rules for generating **valid, idiomatic, contract-driven Eiffel code** using Large Language Models.

LLMs MUST comply with these rules whenever outputting Eiffel.

---

# 1. General Principles

1. Produce **real, compilable Eiffel**, never pseudo-code.  
2. Follow **Design by Contract**, **Command–Query Separation**, and **Uniform Access**.  
3. Prefer clarity and correctness over cleverness.  
4. If details are missing, make safe, documented assumptions.  
5. Output **only Eiffel** unless the user explicitly asks for commentary.

---

# 2. Naming Rules (Strict)

| Entity | Style | Examples |
|--------|--------|-----------|
| Class names | UPPERCASE | `PERSON`, `BANK_ACCOUNT` |
| Features | lowercase_with_underscores | `set_age`, `is_empty` |
| Locals | short & descriptive | `i`, `result_val`, `item` |
| Booleans | adjectives or `is_` prefix | `is_valid`, `has_value` |

Rules:
- No camelCase or PascalCase for features.  
- Avoid abbreviations unless universally standard.  
- Once routines & constants use leading uppercase (`Pi`, `Max_int`).  

---

# 3. Formatting & Layout

- **Use TAB indentation** (mandatory).  
- Space before parentheses: `f (x)` not `f(x)`.  
- Space after commas: `f (a, b)`.  
- No space around dot calls: `list.count`.  
- Comments start with `-- ` (two dashes and a space).

Grouping of feature clauses:

```
feature -- Initialization
feature -- Access
feature -- Element Change
feature -- Implementation
feature -- Constants
```

---

# 4. Special Characters and Escaping

In Eiffel, special characters within strings and character literals are represented using escape sequences that begin with a percent sign (`%`).

### Common Escape Sequences

| Character | Escape Code | Description |
|-----------|-------------|-------------|
| `@` | `%A` | At-sign |
| Backspace | `%B` | Backspace character |
| `^` | `%C` | Circumflex |
| `$` | `%D` | Dollar sign |
| Form feed | `%F` | Form feed character |
| `\` | `%H` | Backslash |
| `~` | `%L` | Tilde |
| Newline | `%N` | Newline character |
| `` ` `` | `%Q` | Backquote |
| Carriage return | `%R` | Carriage return character |
| `#` | `%S` | Sharp (hash) |
| Tab | `%T` | Horizontal tab character |
| Null | `%U` | Null character |
| `\|` | `%V` | Vertical bar |
| `%` | `%%` | Percent sign (to escape `%` itself) |
| `'` | `%'` | Single quote |
| `"` | `%"` | Double quote |
| `[` | `%(` | Opening bracket |
| `]` | `%)` | Closing bracket |
| `{` | `%<` | Opening brace |
| `}` | `%>` | Closing brace |

### Numeric Character Codes

Characters can also be represented by their numeric codes:

- **Decimal:** `%/123/` - character with decimal code 123
- **Hexadecimal:** `%/0x2200/` - character with hexadecimal code U+2200
- **Octal:** `%/0c21000/` - character with octal code 21000
- **Binary:** `%/0b10001000000000/` - character with binary code

### Examples:

```eiffel
-- String with newline
message := "Hello%NWorld"

-- String with tab and quotes
text := "She said %"Hello%", then left.%TBye!"

-- String with percent sign
percentage := "Discount: 50%% off"

-- Character literals
newline_char: CHARACTER = '%N'
quote_char: CHARACTER = '%"'

-- Using numeric codes
unicode_char: CHARACTER = '%/0x2200/'  -- ∀ (for all)
```

### Rules:
- Use escape sequences for special characters in strings and character literals.
- Always use `%%` to represent a literal percent sign.
- Use `%N` for newlines, `%T` for tabs, `%R` for carriage returns.
- Use numeric codes for Unicode characters or characters not covered by standard escape sequences.

**Reference:** [Eiffel Syntax - Special Characters](https://www.eiffel.org/doc/eiffel/Eiffel_programming_language_syntax#Special_characters)

---

# 5. Class Structure (Strict Template)

LLMs must follow this exact structure:

```eiffel
note
	description: "Short description."

class
	CLASS_NAME

create
	make


inherit
	-- Optional

feature -- Initialization

	make (...)
			-- Constructor comment.
		require
			-- Preconditions
		do
			-- Body
		ensure
			-- Postconditions
		end

feature -- Access

	...

feature -- Element Change

	...

invariant
	invariant_label: condition

end
```

---

# 6. Once Classes

Once classes represent a mechanism to specify **unique values** in a program. They behave like any other objects but preserve their identity at creation time. Only a single distinguishable instance of a class is created per creation procedure, regardless of how many times the creation is used.

### Declaration

A once class is declared with the keyword `once` before `class`. **All creation procedures** listed in the declaration must be once procedures.

```eiffel
once class
	DIRECTION

create
	down, left, right, up

feature {NONE} -- Creation

	down
		once
			y_scroll := 3
		end

	left
		once
			x_scroll := -1
		end

	right
		once
			x_scroll := 1
		end

	up
		once
			y_scroll := -3
		end

feature -- Access

	x_scroll: INTEGER
			-- The number of columns to scroll.

	y_scroll: INTEGER
			-- The number of lines to scroll.

end
```

### Key Properties

- **Uniqueness:** Only one instance is created per creation procedure. Successive attempts to create an object with the same creation procedure yield the same object.
- **Frozen:** Once classes are automatically frozen and cannot be used as parents of other classes.
- **Equality:** Objects created with the same creation procedure are equal (`=`).
- **State sharing:** Changing attributes of a once object updates them for all references to that object.

### Access and Creation

Objects of a once class can be created using regular creation syntax:

```eiffel
-- Creation instruction
create direction.up

-- Creation expression
foo (create {DIRECTION}.up)

-- Simplified creation expression (create keyword can be omitted)
foo ({DIRECTION}.up)
```

### Multi-Branch Constructs

Once classes can be used in `inspect` statements, similar to integers:

```eiffel
inspect direction
when {DIRECTION}.down then
	io.put_string ("Down")
when {DIRECTION}.left then
	io.put_string ("Left")
when {DIRECTION}.right then
	io.put_string ("Right")
when {DIRECTION}.up then
	io.put_string ("Up")
end
```

**Intervals:** The order of creation procedures in the `create` clause determines their relative order for interval matching:

```eiffel
once class
	DAY_OF_WEEK

create
	Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday

-- Can use intervals:
inspect day
when {DAY_OF_WEEK}.Monday .. {DAY_OF_WEEK}.Friday then
	is_weekend := False
else
	is_weekend := True
end
```

### SCOOP (Concurrency)

Once classes follow default once-per-thread behavior. To create a single instance across all threads and SCOOP regions, specify the `"PROCESS"` once key:

```eiffel
up
	once ("PROCESS")
		y_scroll := -3
	end
```

Without the once key, each thread gets its own instance. With `"PROCESS"`, all threads share the same instance.

### Use Cases

**1. Singleton Pattern:**
```eiffel
once class
	LOGGER

create
	make

feature -- Initialization

	make
		once
			-- Initialize logger
		end

feature -- Access

	log (message: STRING)
		do
			-- Log message
		end

end
```

**2. Enumeration-like Values:**
Use once classes to represent fixed sets of values (like enums in other languages).

**3. Iteration:**
Provide an `instances` feature returning all values:

```eiffel
instances: ITERABLE [DAY_OF_WEEK]
		-- All days of week.
	once
		Result := <<{DAY_OF_WEEK}.Sunday, {DAY_OF_WEEK}.Monday,
			{DAY_OF_WEEK}.Tuesday, {DAY_OF_WEEK}.Wednesday,
			{DAY_OF_WEEK}.Thursday, {DAY_OF_WEEK}.Friday,
			{DAY_OF_WEEK}.Saturday>>
	ensure
		class
	end
```

### Rules:
- All creation procedures in a once class must be once procedures.
- Once classes are automatically frozen (cannot inherit from them).
- Use once classes when you need unique, distinguishable values.
- Use `"PROCESS"` once key for system-wide uniqueness in concurrent programs.
- Creation expression syntax can omit `create` keyword: `{DIRECTION}.up` instead of `create {DIRECTION}.up`.

**Reference:** [Once Classes - Eiffel Blog](https://www.eiffel.org/blog/Alexander%20Kogtenkov/2020/12/once-classes)

---

# 7. Attachment Status (Types are Attached by Default)

In modern Eiffel, **all reference types are attached by default**. This means:

- A variable of type `STRING` cannot be `Void` unless explicitly declared as `detachable STRING`.
- No need for `/= Void` checks on attached types.
- Use `detachable TYPE` only when `Void` is a valid value.
- Use `attached TYPE` explicitly when you want to emphasize attachment (optional but clear).

### Rules:
- **Default:** All reference types are attached (`STRING`, `LIST [INTEGER]`, etc.).
- **Explicit detachment:** Use `detachable STRING` when `Void` is allowed.
- **Explicit attachment:** Use `attached STRING` for clarity (redundant but allowed).
- **Preconditions:** Do NOT check `a_string /= Void` for attached types.
- **Preconditions:** DO check `a_string /= Void` for `detachable STRING` parameters.

### Examples:

```eiffel
-- Attached by default (cannot be Void)
name: STRING

-- Explicitly detachable (can be Void)
optional_name: detachable STRING

-- In preconditions for attached types (unnecessary):
-- name_not_void: a_name /= Void  -- WRONG: a_name is attached

-- In preconditions for detachable types (necessary):
-- name_not_void: a_name /= Void  -- CORRECT: a_name is detachable
```

---

# 8. Design by Contract (Mandatory)

### Preconditions (`require`)
Define what the **client** must guarantee.

### Postconditions (`ensure`)
Define what the **supplier** guarantees.

### Invariants
Define long-term correctness constraints.

### Loop Invariants and Variants (Optional)
Loop invariants and variants are optional parts of loops that help guarantee loop correctness.

**Loop Invariants:**
- Express properties that must be true after initialization and preserved by each loop iteration.
- The initialization part must establish the invariant.
- Each loop body execution must preserve the invariant.
- When the loop terminates, both the invariant and exit condition are true.

**Loop Variants:**
- Provide an integer expression whose value is non-negative after initialization.
- The variant value must decrease by at least one (while remaining non-negative) with each loop iteration.
- This guarantees loop termination (a non-negative integer cannot decrease forever).

**Syntax:**
```eiffel
from
	-- Initialization (establishes invariant, variant >= 0)
invariant
	invariant_label: condition  -- Must hold after init and each iteration
variant
	variant_label: integer_expression  -- Must decrease each iteration
until
	exit_condition
loop
	-- Loop body (preserves invariant, decreases variant)
end
```

**Example:**
```eiffel
find_index (target: INTEGER): INTEGER
		-- Find index of `target` in array, or -1 if not found.
	local
		i: INTEGER
	do
		from
			i := 1
			Result := -1
		invariant
			valid_range: i >= 1 and i <= array.count + 1
			not_found_yet: Result = -1 implies (∀ j: 1 |..| (i - 1) ¦ array [j] /= target)
		variant
			array.count + 1 - i
		until
			i > array.count or Result >= 0
		loop
			if array [i] = target then
				Result := i
			else
				i := i + 1
			end
		end
	end
```

**Rules:**
- Loop invariants and variants are **optional** but recommended for complex loops.
- Invariants must be **labeled**.
- Variants must be **labeled**.
- Variants must be non-negative integers that decrease with each iteration.
- When assertion monitoring is enabled, these properties are checked after initialization and each iteration.

**Reference:** [Loop Invariants and Variants](https://www.eiffel.org/doc/eiffel/ET-_Instructions#Loop_invariants_and_variants)

Rules:
- Preconditions may be **weakened** in subclasses.  
- Postconditions may be **strengthened**.  
- Invariants must always hold around exported features.  
- Assertions must be **labeled**.

---

# 9. Commands vs Queries

- **Commands:** Procedures that mutate state, return nothing.  
- **Queries:** Functions that return a value, must NOT mutate state.  

This is strict.

---

# 10. Loops and Iteration

Eiffel supports several loop constructs. The `across` loop provides iteration over iterable collections.

### Across Loops

The `across` loop iterates over collections that conform to `ITERABLE [G]`. It provides access to both the current item and cursor features.

**Syntax:**
```eiffel
across iterable_expression as cursor_name loop
	-- Loop body
	-- Access current item: cursor_name
	-- Access cursor features: @ cursor_name.feature_name
end
```

**Unified Cursor Syntax:**
- **Current item:** Accessed directly by the cursor name (e.g., `x` or `y`)
- **Cursor features:** Accessed by preceding the cursor name with `@` (e.g., `@ x.target_index` or `@ y.key`)

**Examples:**

```eiffel
-- Iterate over array, accessing current item
across array as x loop
	print (x)
	io.put_new_line
end

-- Access cursor features using @ syntax
∀ x: array ¦ (@ x.target_index \\ 2 = 0 ⇒ x > 0)
	-- All elements at even positions are positive.

-- Iterate over hash table, accessing both key and value
across table as y loop
	print (@ y.key)  -- Access key via cursor
	print (": ")
	print (y)        -- Access value (current item)
	io.put_new_line
end

-- Iterate over integer interval
across 5 |..| 15 as i loop
	print (i.out + "%N")
end

-- Iterate in reverse order
across my_list.new_cursor.reversed as ic loop
	print (ic)  -- Current item accessed directly
end
```

**Symbolic Loops (Quantifier Forms) - Optional:**
Symbolic loops use quantifier notation and are **optional** but **preferred** for use in preconditions, postconditions, and invariants.

```eiffel
-- Universal quantifier (all elements satisfy condition)
∀ x: collection ¦ condition

-- Existential quantifier (at least one element satisfies condition)
∃ x: collection ¦ condition
```

**When to Use Symbolic Loops:**
- **Preferred** in preconditions (`require` clauses)
- **Preferred** in postconditions (`ensure` clauses)
- **Preferred** in invariants
- **Preferred** in loop invariants
- Use regular `across ... loop ... end` for executable code in routine bodies

**Examples in Contracts:**
```eiffel
feature -- Access

	is_sorted: BOOLEAN
			-- Are all elements in sorted order?
		do
			Result := ∀ i: 1 |..| (array.count - 1) ¦ array [i] <= array [i + 1]
		end

feature -- Element Change

	add_all (items: ITERABLE [INTEGER])
			-- Add all items to the collection.
		require
			all_positive: ∀ x: items ¦ x > 0
		do
			across items as x loop
				collection.extend (x)
			end
		ensure
			all_added: ∀ x: items ¦ collection.has (x)
		end

invariant
	no_duplicates: ∀ i, j: 1 |..| list.count ¦ (i /= j ⇒ list [i] /= list [j])
```

**Rules:**
- The iterable expression must conform to `ITERABLE [G]` for some type `G`.
- The cursor name is a local variable scoped to the loop body or assertion.
- Use the cursor name directly to access the current item.
- Use `@ cursor_name.feature_name` to access cursor features (e.g., `target_index`, `key`, `index`).
- Works with arrays, lists, hash tables, intervals, and any class implementing `ITERABLE`.
- Symbolic loops are **optional** but recommended for assertions (preconditions, postconditions, invariants).
- Use regular `across ... loop ... end` syntax for executable code in routine bodies.

**Reference:** [EiffelStudio 21.11 Release Notes](https://www.eiffel.org/doc/eiffelstudio/Release_notes_for_EiffelStudio_21.11)

---

# 11. Agents

Agents provide a mechanism for representing routines as objects, enabling deferred execution, event-driven programming, and flexible iteration patterns.

### Basic Concepts

An agent is an object that represents a routine (procedure or function). Agents are instances of:
- `PROCEDURE [TUPLE [...]]` - for procedures
- `FUNCTION [TUPLE [...], T]` - for functions returning type `T`
- `PREDICATE [TUPLE [...]]` - for boolean functions (predicates)

**Basic Syntax:**
```eiffel
-- Create an agent from an existing routine
agent routine_name
agent routine_name (arg1, arg2, ...)

-- Call an agent
agent_object.call ([arg1, arg2, ...])  -- For procedures
agent_object.item ([arg1, arg2, ...])  -- For functions
```

**Example:**
```eiffel
apply_twice (f: FUNCTION [INTEGER, INTEGER]; x: INTEGER): INTEGER
		-- Apply agent `f` twice to `x`.
	do
		Result := f.item (f.item (x))
	end
```

is a short-hand for:

```eiffel
apply_twice (f: FUNCTION [TUPLE [INTEGER], INTEGER]; x: INTEGER): INTEGER
		-- Apply agent `f` twice to `x`.
	do
		Result := f.item ([f.item ([x])])
	end
```	

### Open and Closed Arguments

Agents can have **open** and **closed** arguments. Closed arguments are set when the agent is created; open arguments are provided when the agent is called.

**Syntax:**
- `?` denotes an open argument
- Values or variables denote closed arguments

**Examples:**
```eiffel
-- All arguments open (equivalent to agent routine_name)
agent routine_name (?, ?)

-- Some arguments closed, some open
agent record_city (name, population, ?, ?)
	-- First two arguments are closed, last two are open

-- All arguments closed
agent routine_name (25, 32)
	-- Type: PROCEDURE [TUPLE] (no open arguments)
	-- Call with: agent_object.call ([])
```

**Type Rules:**
- The agent type is determined by the **open arguments only**
- `agent record_city (name, population, ?, ?)` has type `PROCEDURE [TUPLE [INTEGER, INTEGER]]`
- A completely closed agent has type `PROCEDURE [TUPLE]` (empty tuple)

### Open Targets

Agents can also have open or closed targets (the object on which the routine is called).

**Syntax:**
```eiffel
-- Closed target (target is set when agent is created)
agent object.feature_name
agent object.feature_name (arg1, arg2)

-- Open target (target is provided when agent is called)
agent {CLASS_NAME}.feature_name
agent {CLASS_NAME}.feature_name (?, ?)
agent {CLASS_NAME}.feature_name (?, closed_arg)
```

**Examples:**
```eiffel
-- Iterate over accounts, depositing money on each
account_list.do_all (agent {ACCOUNT}.deposit_one_grand)
	-- Target is open, will be each account in the list

-- Iterate over integers, adding each to total
integer_list.do_all (agent add_to_total)
	-- Target is closed (Current), argument is open
```

### Inline Agents

Inline agents allow you to define a routine directly within an agent expression, without creating a separate feature.

**Syntax:**
```eiffel
agent (formal_args): RETURN_TYPE
	require
		-- Optional preconditions
	local
		-- Optional local variables
	do
		-- Body
	ensure
		-- Optional postconditions
	end
```

**Examples:**
```eiffel
-- Inline agent as procedure
account_list.do_all (agent (a: ACCOUNT)
	do
		a.deposit (1000)
	end)

-- Inline agent as function
integer_list.for_all (agent (i: INTEGER): BOOLEAN
	do
		Result := (i > 0)
	ensure
		definition: Result = (i > 0)
	end)

-- Inline agent with local variables
list.do_all (agent (item: STRING)
	local
		upper: STRING
	do
		upper := item.as_upper
		process (upper)
	end)
```

**Rules:**
- Inline agents can have preconditions, postconditions, and local variables
- Inline agents do **not** have access to local variables of the enclosing routine
- If needed, pass local variables as arguments to the inline agent

### Common Use Cases

**1. Iteration:**
```eiffel
-- Apply a procedure to all elements
list.do_all (agent process_item)

-- Apply a procedure with closed arguments
list.do_all (agent process_item (closed_arg, ?))

-- Check if all elements satisfy a condition
all_positive: BOOLEAN
	do
		Result := integer_list.for_all (agent (i: INTEGER): BOOLEAN
			do
				Result := i > 0
			end)
	end
```

**2. Event-Driven Programming:**
```eiffel
-- Register a callback
button.click_actions.extend (agent on_button_click)
button.click_actions.extend (agent handle_click (button_id, ?))
```

**3. Higher-Order Functions:**
```eiffel
integrate (f: FUNCTION [REAL, REAL]; a, b: REAL): REAL
		-- Integrate function `f` from `a` to `b`.
	do
		-- Integration implementation
	end

-- Use with partially closed arguments
integrator.integrate (agent function3 (3.5, ?, 6.0), 0.0, 1.0)
```

### Rules:
- Agents are attached by default (no `Void` check needed for agent parameters)
- Use `?` to denote open arguments
- Use `{TYPE}.feature_name` for open targets
- Inline agents cannot access enclosing routine's local variables
- Agent types are determined by open arguments only
- Use `call` for procedures, `item` for functions

**Reference:** [Eiffel Agents Tutorial](https://www.eiffel.org/doc/eiffel/ET-_Agents)

---


# 12. How to write comments


### a. **Markup Syntax**
- **Class references**: Wrap class names in braces  
  Example:  
  ```eiffel
  -- See {DEBUG_OUTPUT} for more information.
  ```
- **Feature references (same class or parent)**: Use double back quotes  
  Example:  
  ```eiffel
  -- See `debug_output` for more information.
  ```
- **Feature references from another class**: Combine class markup with feature name  
  Example:  
  ```eiffel
  -- See {DEBUG_OUTPUT}.debug_output for more information.
  ```

### b. **Precursor Comments**
- Use `-- <Precursor>` to inherit parent feature comments when redefining.  
- This avoids duplication and ensures consistency.  
- Example:  
  ```eiffel
  test (a_arg: INTEGER): BOOLEAN
      -- <Precursor>
  do
  end
  ```

### c. **Comment Augmentation**
- Add extra notes before or after `-- <Precursor>`.  
- Keep `-- <Precursor>` on its own line for clarity.  
- Example:  
  ```eiffel
  test (a_arg: INTEGER): BOOLEAN
      -- Comments before the original comments from {BASE}.
      -- <Precursor>
      -- Some additional comments.
  do
  end
  ```

### d. **Multiple Redefinitions**
- When inheriting from multiple parents, specify the source class explicitly:  
  ```eiffel
  f (a_arg: INTEGER): BOOLEAN
      -- <Precursor {BASE}>
  do
  end
  ```
- If the class is incorrect, EiffelStudio will warn:  
  ```
  -- Unable to retrieve the comments from redefinition of {CLASS_NAME}.
  ```

### e. **Documentation Integration**
- Precursor comments are supported in all EiffelStudio tools (Contract Viewer, Feature Relation Tool, documentation generators).  
- Using `-- <Precursor>` ensures inherited documentation is visible and consistent.

**Reference:** [Eiffel Code  Comments](https://www.eiffel.org/doc/eiffel/Eiffel_Code_Comments)
---

# 13. Prohibited Patterns

LLM MUST NEVER:

- Generate camelCase or mixed styles  
- Auto-format with spaces instead of TABs  
- Use pseudo-Eiffel (`:=`, `{}`, `[]`)  
- Use `null` instead of `Void`  
- Output routines without contracts (except trivial once constants)  
- Mix other languages into Eiffel blocks  
- Duplicate comments that restate code  
- Check `/= Void` for attached types (types are attached by default)  

---

# 14. Ask Before Coding

If the spec is ambiguous, the model must ask clarifying questions before generating Eiffel code.

---

# 15. Final Checklist (LLM MUST verify before generating)

- [ ] Class name is UPPERCASE  
- [ ] Feature names in snake_case  
- [ ] Proper class template used  
- [ ] Preconditions & postconditions included and labeled  
- [ ] Invariant included (if applicable)  
- [ ] All indentation uses TABs  
- [ ] Comments concise  
- [ ] No pseudo-eiffel  
- [ ] Command–Query separation preserved  
- [ ] No missing types  
- [ ] No unnecessary `/= Void` checks for attached types  
- [ ] `detachable` used only when `Void` is a valid value  
- [ ] Special characters in strings use proper escape sequences (`%N`, `%T`, `%"`, etc.)  
- [ ] Once classes have `once` keyword before `class` and all creation procedures are once procedures  

---

# 16. Example (Reference)

```eiffel
class
	PERSON

create
	make

note
	description: "Represents a person with name and age."

feature -- Initialization

	make (a_name: STRING; an_age: INTEGER)
			-- Initialize with name and age.
		require
			age_non_negative: an_age >= 0
		do
			name := a_name
			age := an_age
		ensure
			name_set: name = a_name
			age_set: age = an_age
		end

feature -- Access

	name: STRING
			-- Person's name.

	age: INTEGER
			-- Age in years.

feature -- Element Change

	set_age (new_age: INTEGER)
			-- Set `age` to `new_age`.
		require
			age_non_negative: new_age >= 0
		do
			age := new_age
		ensure
			age_updated: age = new_age
		end

invariant
	valid_age: age >= 0

end
```

