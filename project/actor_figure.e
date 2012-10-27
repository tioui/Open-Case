note
	description: "Summary description for {ACTOR_FIGURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACTOR_FIGURE

inherit
	DIAGRAM_SHAPES_WITH_TEXT
	redefine
		text_point
	end

create
	list_make,
	default_create,
	make_with_dimension,
	make_from_point_with_dimension,
	make_with_text,
	make_with_dimension_and_text,
	make_from_point_with_dimension_and_text

feature {NONE} -- Initialization


	initialise
		do
			head.point_a.set_position (0, 0)
			arms.point_a.set_x (0)
			extend(body)
			extend(arms)
			extend(left_leg)
			extend(right_leg)
			extend(head)
			extend(text_figure)
			set_color (default_color)
			text_horizontal_align:=align_center
			text_vertical_align:=align_center
		end

feature -- Access

	point_a:EV_RELATIVE_POINT assign set_point_a
		attribute
			create Result.make_with_position(0,0)
		end
	point_b:EV_RELATIVE_POINT assign set_point_b
		attribute
			create Result.make_with_position(0,0)
		end

	set_point_a(a_point:EV_RELATIVE_POINT)
		do
			set_points_a_and_b(a_point,point_b)
		end

	set_point_b(a_point:EV_RELATIVE_POINT)
		do
			set_points_a_and_b(point_b,a_point)
		end

	set_points(a_points:LIST[EV_RELATIVE_POINT])
		do
			set_points_a_and_b(a_points.first,a_points.last)
		end

	set_points_a_and_b(a_point_a,a_point_b:EV_RELATIVE_POINT)
		local
			x_low,x_high,y_low,y_high:INTEGER
		do
			if a_point_a.x<a_point_b.x then
				x_low:=a_point_a.x
				x_high:=a_point_b.x
			else
				x_low:=a_point_b.x
				x_high:=a_point_a.x
			end

			point.set_x (x_low)
			head.point_b.set_x (x_high-x_low)
			arms.point_b.set_x (x_high-x_low)
			body.point_a.set_x ((x_high-x_low)//2)
			body.point_b.set_x ((x_high-x_low)//2)
			left_leg.point_a.set_x ((x_high-x_low)//2)
			right_leg.point_a.set_x ((x_high-x_low)//2)
			left_leg.point_b.set_x ((x_high-x_low)//4)
			right_leg.point_b.set_x (((x_high-x_low)//4)*3)
		end

	set_width(a_width:INTEGER)
		do
			width:=a_width
		end

	set_height(a_height:INTEGER)
		do
			height:=a_height
		end

	color:EV_COLOR assign set_color
		do
			if attached head.background_color as l_color then
				Result:=l_color
			else
				Result:=default_color
			end
		end

	set_color(a_color:EV_COLOR)
		do
			head.set_background_color (a_color)
		end

	line_color:EV_COLOR
		do
			Result:=head.foreground_color
		end

	set_line_color(a_color:EV_COLOR)
		do
			head.set_foreground_color (a_color)
			body.set_foreground_color (a_color)
			arms.set_foreground_color (a_color)
			left_leg.set_foreground_color (a_color)
			right_leg.set_foreground_color (a_color)
		end

	text_point:EV_RELATIVE_POINT
		do
			create Result.make_with_position (width//2, point_b.y+5)
		end


feature {NONE}  -- Implementation - Variables

	head:EV_FIGURE_ELLIPSE
		attribute
			create Result.default_create
		end

	body:EV_FIGURE_LINE
		attribute
			create Result.default_create
		end

	arms:EV_FIGURE_LINE
		attribute
			create Result.default_create
		end

	left_leg:EV_FIGURE_LINE
		attribute
			create Result.default_create
		end

	right_leg:EV_FIGURE_LINE
		attribute
			create Result.default_create
		end

	default_color:EV_COLOR
		once
			create Result.make_with_8_bit_rgb (255, 128, 0)
		end


feature {NONE} -- Others

	new_filled_list (n: INTEGER): like Current
			-- New list with `n' elements.
		do
			create Result.list_make (n)
		end
end
