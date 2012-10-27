note
	description: "A figure representing a Case."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

class
	CASE_FIGURE

inherit
	DIAGRAM_SHAPE_WITH_TEXT
	redefine
		position_on_figure,
		initialise
	end

create
	default_create,
	make_with_dimension,
	make_from_point_with_dimension,
	make_with_text,
	make_with_dimension_and_text,
	make_from_point_with_dimension_and_text

create {ARRAYED_LIST}
	list_make

feature {NONE} -- Initialization

	initialise
			-- Initialise the case figure.
		do
			ellipse.point_a.set_position (0, 0)
			extend(ellipse)
			set_color (default_case_color)
			text_horizontal_align:=align_center
			text_vertical_align:=align_center
			Precursor {DIAGRAM_SHAPE_WITH_TEXT}
		end

feature -- Access

	set_width(a_width:INTEGER)
			-- Set `a_width' as the new `width' of the figure.
		do
			width:=a_width
			ellipse.point_b.set_x (width)
			update_text
		end

	set_height(a_height:INTEGER)
			-- Set `a_height' as the new `height' of the figure.
		do
			height:=a_height
			ellipse.point_b.set_y (height)
			update_text
		end

	color:EV_COLOR assign set_color
			-- The color of the case figure (in the ellipse).
		do
			if attached ellipse.background_color as l_color then
				Result:=l_color
			else
				Result:=default_case_color
			end
		end

	set_color(a_color:EV_COLOR)
			-- Set `a_color' as the new `color' of the case figure (in the ellipse).
		do
			ellipse.set_background_color (a_color)
		end

	lines_color:EV_COLOR
			-- The color of the figure lines.
		do
			Result:=ellipse.foreground_color
		end

	set_lines_color(a_color:EV_COLOR)
			-- Set `a_color' as the new `lines_color'.
		do
			ellipse.set_foreground_color (a_color)
		end

	text_point:EV_RELATIVE_POINT
			-- The point in the figure to position the text
		do
			create Result.make_with_position (width//2, height//2)
		end

	position_on_figure(a_x,a_y:INTEGER): BOOLEAN
			-- Is (`a_x', `a_y') on this figure?
		do
			Result:=ellipse.position_on_figure (a_x, a_y)
		end

feature {NONE}  -- Implementation - Variables

	ellipse:EV_FIGURE_ELLIPSE
			-- The ellipse to draw to represent a Case figure.
		attribute
			create Result.default_create
		end

feature {NONE} -- Others

	new_filled_list (n: INTEGER): like Current
			-- New list with `n' elements.
		do
			create Result.list_make (n)
		end


end
