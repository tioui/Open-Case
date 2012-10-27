note
	description: "A figure that has a shape."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

deferred class
	DIAGRAM_SHAPE

inherit
	DIAGRAM_FIGURE
	redefine
		position_on_figure,
		initialise
	end

feature {NONE} -- Initialization

	make_with_dimension(a_width,a_height:INTEGER)
			-- Initialization for `Current'.
			-- Set `a_width' as the `width' of the figure.
			-- Set `a_height' as the `height' of the figure.
		do
			default_create
			set_width (a_width)
			set_height (a_height)
		end

	make_from_point_with_dimension(a_point:EV_RELATIVE_POINT;a_width,a_height:INTEGER)
			-- Initialization for `Current'.
			-- Set the position set in `a_point' as the new dimension of the figure.
			-- Set `a_width' as the `width' of the figure.
			-- Set `a_height' as the `height' of the figure.
		do
			make_with_dimension(a_width,a_height)
			point.set_position (a_point.x, a_point.y)
		end

	initialise
			-- Initialise the shape figure.
		local
			l_handle_point:HANDLE_POINT
		do
			create {ARRAYED_LIST[HANDLE_POINT]} handle_points.make(8)
			create l_handle_point.make
			l_handle_point.set_cursor (default_pixmaps.sizenwse_cursor)
			l_handle_point.relative_move_actions.extend (agent on_handle_points_process(true,1,1,-1,-1,?,?))
			handle_points.extend (l_handle_point)
			create l_handle_point.make
			l_handle_point.set_cursor (default_pixmaps.Sizens_cursor)
			l_handle_point.relative_move_actions.extend (agent on_handle_points_process(false,0,1,0,-1,?,?))
			handle_points.extend (l_handle_point)
			create l_handle_point.make
			l_handle_point.set_cursor (default_pixmaps.Sizenesw_cursor)
			l_handle_point.relative_move_actions.extend (agent on_handle_points_process(true,0,-1,1,1,?,?))
			handle_points.extend (l_handle_point)
			create l_handle_point.make
			l_handle_point.set_cursor (default_pixmaps.Sizewe_cursor)
			l_handle_point.relative_move_actions.extend (agent on_handle_points_process(false,1,0,-1,0,?,?))
			handle_points.extend (l_handle_point)
			create l_handle_point.make
			l_handle_point.set_cursor (default_pixmaps.Sizewe_cursor)
			l_handle_point.relative_move_actions.extend (agent on_handle_points_process(false,0,0,1,0,?,?))
			handle_points.extend (l_handle_point)
			create l_handle_point.make
			l_handle_point.set_cursor (default_pixmaps.Sizenesw_cursor)
			l_handle_point.relative_move_actions.extend (agent on_handle_points_process(true,1,0,-1,-1,?,?))
			handle_points.extend (l_handle_point)
			create l_handle_point.make
			l_handle_point.set_cursor (default_pixmaps.Sizens_cursor)
			l_handle_point.relative_move_actions.extend (agent on_handle_points_process(false,0,0,0,1,?,?))
			handle_points.extend (l_handle_point)
			create l_handle_point.make
			l_handle_point.set_cursor (default_pixmaps.sizenwse_cursor)
			l_handle_point.relative_move_actions.extend (agent on_handle_points_process(true,0,0,1,1,?,?))
			handle_points.extend (l_handle_point)
			Precursor {DIAGRAM_FIGURE}
		end

feature -- Access

	color:EV_COLOR assign set_color
			-- The color of the figure interior.
		deferred
		end

	set_color(a_color:EV_COLOR)
			-- Set `a_color' as the new `color' of the figure interior.
		deferred
		end

	height:INTEGER assign set_width
			-- The height of the figure.

	width:INTEGER assign set_height
			-- The width of the figure.

	set_width(a_width:INTEGER)
			-- Set `a_width' as the new `width' of the figure.
		deferred
		ensure
			width = a_width
		end

	set_height(a_height:INTEGER)
			-- Set `a_height' as the new `height' of the figure.
		deferred
		ensure
			height = a_height
		end

	position_on_figure(a_x,a_y:INTEGER): BOOLEAN
			-- Is (`a_x', `a_y') on this figure?
		do
			if a_x>=point.x and a_x<=point.x+width and a_y>=point.y and a_y<=point.y+height then
				Result:=false
			else
				Result:=true
			end
		end

	update_handle_points
			-- Update all handle_points position of the figure.
		require else
			Valid_Handle_Points_Count: handle_points.count = 1
		do
			handle_points.at (1).point.set_position (point.x, point.y)
			handle_points.at (2).point.set_position (point.x+(width//2), point.y)
			handle_points.at (3).point.set_position (point.x+width, point.y)
			handle_points.at (4).point.set_position (point.x, point.y+(height//2))
			handle_points.at (5).point.set_position (point.x+width, point.y+(height//2))
			handle_points.at (6).point.set_position (point.x, point.y+height)
			handle_points.at (7).point.set_position (point.x+(width//2), point.y+height)
			handle_points.at (8).point.set_position (point.x+width, point.y+height)
		end

feature {NONE} -- Implementation Routine

	on_handle_points_process(keep_proportion:BOOLEAN;x_modifier,y_modifier,width_modifier,height_modifier,a_rel_x,a_rel_y:INTEGER)
			-- When the handle point are used, modify the position and dimension of the figure accordingly.
		do
			point.set_x (point.x+(a_rel_x*x_modifier))
			if keep_proportion then
				point.set_y (point.y+(a_rel_x*y_modifier))
			else
				point.set_y (point.y+(a_rel_y*y_modifier))
			end
			set_width (width+(a_rel_x*width_modifier))
			if keep_proportion then
				set_height (height+(a_rel_x*height_modifier))
			else
				set_height (height+(a_rel_y*height_modifier))
			end

		end



end
