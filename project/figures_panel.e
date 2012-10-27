note
	description: "The panel showing all figure that can be put on the diagram."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

class
	FIGURES_PANEL

inherit
	ANY
	EV_DRAWING_AREA_PROJECTOR
		rename
			make as make_projector
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make(a_drawing:EV_DRAWING_AREA)
			-- Creating the `Current' panel and associate it with `a_drawing'
		local
			figures_world:EV_FIGURE_WORLD
		do
			create figures_world.default_create
			make_projector (figures_world, a_drawing)
		end

feature -- Access

	add_figure(a_figure:DIAGRAM_FIGURE)
			-- Put the figure `a_figure' on the panel
		do
			world.extend (a_figure)
			project
		end

	selected_figure: detachable EV_FIGURE
			-- The figure that is currently selected.


end
