note
	description: "A visual handle point to move and transform diagram figures."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

class
	HANDLE_POINT

inherit
	CONSTANTS
		undefine
			default_create
		end
	EV_FIGURE_GROUP
	export
		{ARRAYED_LIST} all;
		{ANY} show, hide, point, enable_capture, disable_capture, world, pointer_button_press_actions;
	redefine
		list_make
	end

create
	make
create {ARRAYED_LIST}
	list_make

feature {NONE} -- Initialization

	make
			-- Initialisation of `Current'
		do
			default_create
			create circle.default_create
			circle.set_background_color (Handle_Point_color)
			circle.point_a.set_position (-Handle_point_radius, -Handle_point_radius)
			circle.point_b.set_position (Handle_point_radius, Handle_point_radius)
			point.set_position (0, 0)
			extend (circle)
		end

	list_make(n:INTEGER_32)
			-- Creator that is use by parent `ARRAYED_LIST' in the `new_filled_list' routine.
		do
			precursor {EV_FIGURE_GROUP} (n)
			make
		end

feature -- Access

	set_cursor(a_cursor:EV_POINTER_STYLE)
			-- Set `a_cursor' as the new pointer style over the handle point.
		do
			circle.set_pointer_style (a_cursor)
		end

	start_move_pointer(x,y:INTEGER)
			-- When the handle point start being used.
		do
			old_handle_coordinate:=[x,y]
		end

	move_pointer(x,y:INTEGER)
			-- When the pointer move,
			-- call the move actions routines `absolute_move_actions' and `relative_move_actions'.
		do
			absolute_move_actions.call ([x,y])
			relative_move_actions.call ([x - old_handle_coordinate.x,y-old_handle_coordinate.y])
			old_handle_coordinate:=[x,y]
		end

	relative_move_actions:EV_PND_START_ACTION_SEQUENCE
			-- When `move_pointer' is used.
			-- The value of the arguments is the difference
			-- between the new pointer coordinate and the last one known.
		attribute
			create Result.default_create
		end

	absolute_move_actions:EV_PND_START_ACTION_SEQUENCE
			-- When `move_pointer' is used.
			-- The value is the arguments is the value of the pointer position on the screen.
		attribute
			create Result.default_create
		end

feature {NONE} -- Implementation

	circle:EV_FIGURE_ELLIPSE
			-- The circle representing the handle point.
		attribute
			create Result.default_create
		end

	old_handle_coordinate:TUPLE[x,y:INTEGER]
			-- The last known coordinate of the mouse pointer when a handle point is currently being used.
		attribute
			Result:=[0,0]
		end

end
