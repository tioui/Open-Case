note
	description: "A figure to be use in the diagram."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

deferred class
	DIAGRAM_FIGURE

inherit
	ANY
		undefine
			default_Create
		end
	EV_MOVE_HANDLE
		rename
			default_create as default_figure_create
		undefine
			new_filled_list
		redefine
			list_make,
			on_start_resizing,
			on_resizing,
			on_stop_resizing
		select
			default_figure_create
		end

feature -- Initialisation

	default_create
			-- Initialization for `Current'.
		do
			default_figure_create
			initialise
		end

	list_make(n:INTEGER)
			-- Creator that is use by parent {ARRAYED_LIST} in the `new_filled_list' routine.
		do
			precursor {EV_MOVE_HANDLE} (n)
			initialise
		end

	initialise
			-- Initialise the figure
		do
			enable_move_handler
		end


feature -- Access

	lines_color:EV_COLOR assign set_lines_color
			-- The color of the figure lines.
		deferred
		end

	set_lines_color(a_color:EV_COLOR)
			-- Set `a_color' as the new `lines_color'.
		deferred
		end

	handle_points:LIST[HANDLE_POINT]
			-- The list of handle points of the figure.
		attribute
			create {ARRAYED_LIST[HANDLE_POINT]} Result.make(0)
		end

	update_handle_points
			-- Update all handle_points of the figure.
		deferred
		end


feature {DIAGRAM_PANEL}

	enable_move_handler
			-- Activate the move functionnality inherited by `EV_MOVE_HANDLE'.
		do
			is_move_handler:=true
		end

	disable_move_handler
			-- Desactivate the move functionnality inherited by `EV_MOVE_HANDLE'.
		do
			is_move_handler:=false
		end

	is_move_handler:BOOLEAN
			-- True if the move functionnality inherited by `EV_MOVE_HANDLE'
			-- must be used.

feature {NONE} -- Events

	on_start_resizing (x, y, b: INTEGER; xt, yt, p: DOUBLE; sx, sy: INTEGER)
			-- When the move functionnality inherited by `EV_MOVE_HANDLE' start.
		do
			if is_move_handler then
				Precursor {EV_MOVE_HANDLE} (x, y, b,xt, yt, p,sx, sy)
			end
		end

	on_resizing (x, y: INTEGER; xt, yt, p: DOUBLE; sx, sy: INTEGER)
			-- When the move functionnality inherited by `EV_MOVE_HANDLE' is in motion.
		do
			if is_move_handler then
				Precursor {EV_MOVE_HANDLE} (x, y,xt, yt, p,sx, sy)
			end
		end

	on_stop_resizing (x, y, b: INTEGER; xt, yt, p: DOUBLE; sx, sy: INTEGER)
			-- When the move functionnality inherited by `EV_MOVE_HANDLE' stop.
		do
			Precursor {EV_MOVE_HANDLE} (x, y, b,xt, yt, p,sx, sy)
		end

end
