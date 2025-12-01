class
	WORKER

create
	make

note
	description: "Uses agents for deferred execution."

feature -- Initialization

	make
		do
		end

feature -- Access

	apply_twice (f: FUNCTION [INTEGER, INTEGER]; x: INTEGER): INTEGER
			-- Apply agent `f` twice to `x`.
			-- Note: `f` is attached by default, so no Void check needed.
		do
			Result := f.item (f.item (x))
		ensure
			applied: True
		end

end
