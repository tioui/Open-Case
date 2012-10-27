note
	description: "A figure with a text in it."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

deferred class
	DIAGRAM_FIGURE_WITH_TEXT

inherit
	CONSTANTS
	undefine
		default_create
	end
	DIAGRAM_FIGURE
	redefine
		initialise
	select
		default_figure_create
	end


feature -- Initialisation

	make_with_text(a_text:READABLE_STRING_GENERAL)
			-- Initialization for `Current'.
			-- Set `a_text' as the `text' to print in the figure.
		do
			default_create
			set_text (a_text)
		end

	initialise
			-- Initialise the figure with text.
		do
			extend(text_figure)
			Precursor {DIAGRAM_FIGURE}
		end


feature -- Access

	text:READABLE_STRING_GENERAL assign set_text
			-- The text to draw in the figure.
		attribute
			create {STRING_8} Result.make_empty
		end

	set_text(a_text:READABLE_STRING_GENERAL)
			-- Set `a_text' as the new `text' of the figure.
		do
			text:=a_text
			update_text
		end

	text_color:EV_COLOR assign set_text_color
			-- The color of the text of the figure.
		attribute
			create Result.make_with_8_bit_rgb (0, 0, 0)
		end

	set_text_color(a_color:EV_COLOR)
			-- Set `a_color' as the new `text_color' of the figure.
		do
			text_color:=a_color
			update_text
		end

	font:EV_FONT assign set_font
			-- The font to use when drawing text on the figure.
		attribute
			create Result.make_with_values ({EV_FONT_CONSTANTS}.family_roman, {EV_FONT_CONSTANTS}.weight_regular, {EV_FONT_CONSTANTS}.shape_regular, 18)
		end

	set_font(a_font:EV_FONT)
			-- Set `a_font' as the new `font' to use when drawing the text on the figure.
		do
			font:=a_font
			update_text
		end

	text_vertical_align:INTEGER
			-- The vertical alignment of the text (align from the `text_point').

	text_horizontal_align:INTEGER
			-- The horizontal alignment of the text (align from the `text_point').

	text_point:EV_RELATIVE_POINT
			-- The reference point to draw the text on the figure.
		deferred
		end

	max_text_width:INTEGER
			-- The maximum width permit to draw text.
			-- It is a best effort rule. If a single word cannot be hold in this width
			-- the word will be print.
		deferred
		end

feature {NONE}  -- Implementation - Routines

	update_text
			-- Update the `text_figure' by applying the `text_point', `text_horizontal_align', `text_vertical_align' and `max_text_width' rules.
		local
			temp_text_figure:EV_FIGURE_TEXT
			i,new_i:INTEGER
			temp_text,old_text,new_text:STRING_32
			is_new_line:BOOLEAN
			l_point:EV_RELATIVE_POINT
		do
			text_figure.wipe_out
			if max_text_width=0 then
				create temp_text_figure.make_with_text (text)
				temp_text_figure.set_font (font)
				text_width:=temp_text_figure.width
				text_height:=temp_text_figure.height
				temp_text_figure.set_foreground_color (text_color)
				temp_text_figure.point.set_position (0, 0)
				text_figure.extend (temp_text_figure)
			else
				temp_text:=text.as_string_32
				create l_point.make_with_position (0, 0)
				text_width:=0
				from
					i:=1
					create old_text.make_empty
				invariant
					font.string_width (old_text)<=max_text_width
				until
					i>temp_text.count
				loop
					is_new_line:=false
					if temp_text.substring_index (" ", i)=0 and temp_text.substring_index ("%N", i)=0 then
						new_i:=temp_text.count+1
					elseif temp_text.substring_index ("%N", i)>0 and then (temp_text.substring_index ("%N", i)<temp_text.substring_index (" ", i)
							or temp_text.substring_index (" ", i)=0) then
						new_i:=temp_text.substring_index ("%N", i)
						is_new_line:=true
					elseif temp_text.substring_index (" ", i)>0 and then (temp_text.substring_index (" ", i)<temp_text.substring_index ("%N", i)
							or temp_text.substring_index ("%N", i)=0) then
						new_i:=temp_text.substring_index (" ", i)+1
					end
					new_text:=old_text+temp_text.substring (i, new_i-1)
					if font.string_width (new_text)>max_text_width then
						is_new_line:=true
						if old_text.is_empty then
							old_text:=new_text
							i:=new_i
						end
					else
						old_text:=new_text
						i:=new_i
						if i>temp_text.count then
							is_new_line:=true
						end
					end
					if is_new_line then
						create temp_text_figure.make_with_text (old_text.string)
						temp_text_figure.set_font (font)
						if text_width<temp_text_figure.width then
							text_width:=temp_text_figure.width
						end
						temp_text_figure.set_foreground_color (text_color)
						if text_horizontal_align=align_center then
							l_point.set_x ((0-temp_text_figure.width)//2)
						elseif text_horizontal_align=align_right then
							l_point.set_x (0-temp_text_figure.width)
						end
						temp_text_figure.point.set_position (l_point.x, l_point.y)
						text_figure.extend (temp_text_figure)
						create l_point.make_with_position (0, temp_text_figure.point.y+temp_text_figure.height+(font.height//4))
						if new_i=i then
							i:=i+1
						end
						old_text.wipe_out
					end
				end
				text_height:=l_point.y-(font.height//4)
				text_figure.do_all
					(agent (a_figure:EV_FIGURE)
						do
							if attached {EV_FIGURE_TEXT} a_figure as a_text_figure then
								a_text_figure.point.set_position (a_text_figure.point.x+(text_width//2), a_text_figure.point.y)
							end
						end)
			end
			if text_horizontal_align=align_center then
				text_figure.point.set_x (text_point.x-(text_width//2))
			elseif text_horizontal_align=align_right then
				text_figure.point.set_x (text_point.x-text_width)
			else
				text_figure.point.set_x (text_point.x)
			end
			if text_vertical_align=align_center then
				text_figure.point.set_y (text_point.y-(text_height//2))
			elseif text_horizontal_align=align_right then
				text_figure.point.set_y (text_point.y-text_height)
			else
				text_figure.point.set_y (text_point.y)
			end
		end



feature {NONE}  -- Implementation - Variables


	text_figure:EV_FIGURE_GROUP
			-- The text to be print on the figure.
		attribute
			create Result.default_create
		end

	text_width:INTEGER
			-- The current width of the `text_figure'.


	text_height:INTEGER
			-- The current height of the `text_figure'.


end
