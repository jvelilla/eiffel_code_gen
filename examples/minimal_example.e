class
	COUNTER

create
	make

note
	description: "Simple integer counter."

feature -- Initialization

	make
		do
			value := 0
		ensure
			value_zeroed: value = 0
		end

feature -- Access

	value: INTEGER
			-- Current count.

feature -- Element Change

	increment
		do
			value := value + 1
		ensure
			increased: value = old value + 1
		end

invariant
	non_negative: value >= 0

end
