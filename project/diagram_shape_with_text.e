note
	description: "A figure that has a shape and containing a text."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

deferred class
	DIAGRAM_SHAPE_WITH_TEXT

inherit
	DIAGRAM_SHAPE
	redefine
		initialise
	end
	DIAGRAM_FIGURE_WITH_TEXT
	undefine
		default_create,
		position_on_figure,
		initialise
	end
feature -- Initialisation

	make_with_dimension_and_text(a_width,a_height:INTEGER;a_text:READABLE_STRING_GENERAL)
			-- Initialization for `Current'.
			-- Set `a_width' as the `width' of the figure.
			-- Set `a_height' as the `height' of the figure.
			-- Set `a_text' as the `text' to print in the figure.
		do
			make_with_dimension(a_width,a_height)
			set_text (a_text)
		end

	make_from_point_with_dimension_and_text(a_point:EV_RELATIVE_POINT;a_width,a_height:INTEGER;a_text:READABLE_STRING_GENERAL)
			-- Initialization for `Current'.
			-- Set the position set in `a_point' as the new dimension of the figure.
			-- Set `a_width' as the `width' of the figure.
			-- Set `a_height' as the `height' of the figure.
			-- Set `a_text' as the `text' to print in the figure.
		do
			make_from_point_with_dimension(a_point,a_width,a_height)
			set_text (a_text)
		end

	initialise
			-- Initialisation of the texted figure shape.
		do
			extend(text_figure)
			Precursor {DIAGRAM_SHAPE}
		end

feature -- Access

	max_text_width:INTEGER
			-- The maximum width permit to draw text is the width of the figure.
			-- It is a best effort rule. If a single word cannot be hold in this width
			-- the word will be print.
		do
			Result:=width.abs
		end
end
