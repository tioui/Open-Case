note
	description: "Constants used in the application."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

deferred class
	CONSTANTS

feature -- Alignment

	Align_left:INTEGER
			-- Integer to represent à left alignment.
		once
			Result:=1
		end

	Align_right:INTEGER
			-- Integer to represent à right alignment.
		once
			Result:=2
		end

	Align_top:INTEGER
			-- Integer to represent à top alignment.
		once
			Result:=3
		end

	Align_bottom:INTEGER
			-- Integer to represent à bottom alignment.
		once
			Result:=4
		end

	Align_center:INTEGER
			-- Integer to represent à center alignment.
		once
			Result:=5
		end

feature {NONE} -- Dimension

	Handle_point_radius:INTEGER
			-- The default radius of a handle point.
		once
			Result:=5
		end



feature {NONE} -- Colors

	default_selection_rectangle_color:EV_COLOR
			-- The default color of a selection rectangle
		once
			create Result.make_with_8_bit_rgb (0, 100, 0)
		end

	default_case_color:EV_COLOR
			-- The default color of a case figure
		once
			create Result.make_with_8_bit_rgb (0, 200, 0)
		end

	Handle_Point_color:EV_COLOR
			-- The default color of a handle point
		once
			create Result.make_with_8_bit_rgb (0, 200, 0)
		end

end
