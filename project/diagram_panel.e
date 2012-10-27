note
	description: "The panel containing the diagram."
	author: "Louis Marchand"
	date: "10/26/2012"
	revision: "$Revision$"

class
	DIAGRAM_PANEL

inherit
	CONSTANTS
	EV_DRAWING_AREA_PROJECTOR
		rename
			make as make_projector
		export
			{NONE} all
		redefine
			project_figure_group
		end

create
	make

feature {NONE} -- Initialisation

	make(a_drawing:EV_DRAWING_AREA)
			-- Creating the `Current' panel and associate it with `a_drawing'
		local
			diagram_world:EV_FIGURE_WORLD
			timer:EV_TIMEOUT
		do
			is_selection_motion:=false
			create diagram_world.default_create
			create buffer.default_create
			make_with_buffer (diagram_world, buffer, a_drawing)
			a_drawing.resize_actions.extend (agent on_resize)
			a_drawing.key_press_actions.extend (agent on_multiple_selection_key_pressed)
			a_drawing.key_release_actions.extend (agent on_multiple_selection_key_released)
			a_drawing.pointer_motion_actions.extend (agent on_handle_point_motion)
			a_drawing.pointer_button_release_actions.extend (agent on_handle_point_stop)
			disable_multi_selection
			back_rectangle.point_a.set_position (0, 0)
			back_rectangle.point_b.set_position (a_drawing.width, a_drawing.height)
			world.extend (back_rectangle)
			world.extend (diagram_main_group)
			world.extend (handle_points_group)
			back_rectangle.pointer_button_press_actions.extend (agent on_selection_rectangle_start)
			back_rectangle.pointer_button_release_actions.extend (agent on_selection_rectangle_stop)
			back_rectangle.pointer_motion_actions.extend (agent on_selection_rectangle_motion)
			selection_motion_rectangle.set_foreground_color (default_selection_rectangle_color)
			selection_motion_rectangle.enable_dashed_line_style
			create timer.make_with_interval (500)
			timer.actions.extend (agent full_project)
			activate_handle_points
		end

feature -- Access

	enable_grid
			-- Show te grid on the panel
		do
			world.enable_grid
			full_project
		end

	disable_grid
			-- Hide the grid from the panel
		do
			world.disable_grid
			full_project
		end

	is_grid_enabled:BOOLEAN
			-- The Grid is visible on the panel
		do
			Result:=world.grid_enabled
		end

	set_grid_spacing(a_spacing:INTEGER)
			-- The distance between each dots of the grid on the panel
		do
			world.set_grid_x (a_spacing)
			world.set_grid_y (a_spacing)
			full_project
		end

	add_figure(a_figure:DIAGRAM_FIGURE)
			-- Put the figure `a_figure' on the panel
		do
			a_figure.pointer_button_press_actions.extend (agent on_selection_figure_button_pressed(a_figure,?,?,?,?,?,?,?,?))
			a_figure.move_actions.extend (agent (a_x,a_y:INTEGER)
											do

											end)
			a_figure.enable_move_handler
			a_figure.move_actions.extend (agent on_diagram_figure_motion(a_figure,?,?))
			a_figure.start_actions.extend (agent on_diagram_figure_moving_start(a_figure))
			across a_figure.handle_points as l_points loop
				l_points.item.pointer_button_press_actions.extend(agent on_handle_point_start(l_points.item,?,?,?,?,?,?,?,?))
			end
			if is_snapping then
				a_figure.enable_snapping
			else
				a_figure.disable_snapping
			end
			diagram_main_group.extend (a_figure)
			full_project
		end

	selected_figures: LINKED_LIST[DIAGRAM_FIGURE]
			-- Figures that is currently selected.
		attribute
			create Result.make
		end

	is_snapping:BOOLEAN
			-- The moving figures snap the grid when moving

	enable_snapping
			-- All moving figures start snapping the grid when moving
		do
			is_snapping:=true
			across diagram_main_group as figure_list loop
				if attached {DIAGRAM_FIGURE} figure_list.item as movable_item then
					movable_item.enable_snapping
				end
			end
		end

	disable_snapping
			-- All moving figures stop snapping the grid when moving
		do
			is_snapping:=false
			across diagram_main_group as figure_list loop
				if attached {DIAGRAM_FIGURE} figure_list.item as movable_item then
					movable_item.disable_snapping
				end
			end
		end

	multi_selection_enabled:BOOLEAN
			-- Users can select multiple figures for selection

	enable_multi_selection
			-- Activate the multiple figure selection functionality
		do
			multi_selection_enabled:=true
			multi_selection_enabled_action.call([])
		end

	disable_multi_selection
			-- Desactivate the multiple figure selection functionality
		do
			multi_selection_enabled:=false
			multi_selection_disabled_action.call ([])
		end

	multi_selection_enabled_action:EV_NOTIFY_ACTION_SEQUENCE
			-- Action to perform when the multiple selection functionality is enabled
		attribute
			Create Result.default_create
		end

	multi_selection_disabled_action:EV_NOTIFY_ACTION_SEQUENCE
			-- Action to perform when the multiple selection functionality is disabled
		attribute
			Create Result.default_create
		end

feature {NONE} -- Implementation - Routines

	on_multiple_selection_key_pressed(key:EV_KEY)
			-- When the Shift key is pressed, activate the multiple selection functionality
		do
			if key.code = {EV_KEY_CONSTANTS}.Key_shift then
				enable_multi_selection
			end

		end

	on_multiple_selection_key_released(key:EV_KEY)
			-- When the Shift key is pressed, activate the multiple selection functionality
		do
			if key.code = {EV_KEY_CONSTANTS}.Key_shift then
				disable_multi_selection
			end

		end

	on_resize(a_x,a_y,a_width,a_height:INTEGER)
			-- When the attached drawing area is resized.
		do
			buffer.set_size (a_width, a_height)
			back_rectangle.point_b.set_position (a_width, a_height)
			full_project
		end

	on_selection_rectangle_start(x, y, button: INTEGER_32; x_tilt, y_tilt, pressure: REAL_64; screen_x, screen_y: INTEGER_32)
			-- When the user click on the back, start the selection rectangle management.
		do
			if button=1 then
				is_selection_motion:=true
				selection_motion_rectangle.point_a.set_position (x, y)
				selection_motion_rectangle.point_b.set_position (x, y)
				back_rectangle.enable_capture
				full_project
			end

		end

	on_selection_rectangle_motion(x, y: INTEGER_32; x_tilt, y_tilt, pressure: REAL_64; screen_x, screen_y: INTEGER_32)
			-- When the selection rectangle is activate, change the dimension to fit the mouse pointer.
		do
			if is_selection_motion then
				selection_motion_rectangle.point_b.set_position (x, y)
				full_project
			end
		end

	on_selection_rectangle_stop(x, y, button: INTEGER_32; x_tilt, y_tilt, pressure: REAL_64; screen_x, screen_y: INTEGER_32)
			-- When the selection rectangle is activate and the user release the mouse button, stop the selection
			-- rectangle and update the `selected_figures' to include the figure selected with the selection rectangle.
		local
			found:BOOLEAN
		do
			if button=1 then
				if not multi_selection_enabled then
					clear_selected_figures
				end
				across diagram_main_group as figures_list loop
					if attached {DIAGRAM_FIGURE} figures_list.item as diag_figure then
						diag_figure.update_handle_points
						from
							found:=false
							diag_figure.handle_points.start
						until
							found or diag_figure.handle_points.exhausted
						loop
							if selection_motion_rectangle.position_on_figure (diag_figure.handle_points.item.point.x_abs, diag_figure.handle_points.item.point.y_abs)  then
								found:=true
							end
							diag_figure.handle_points.forth
						end
						if found then
							if not  selected_figures.has (diag_figure) then
								add_figure_to_selection (diag_figure)
							else
								remove_figure_from_selection (diag_figure)
							end
						end
					end
				end
				is_selection_motion:=false
				back_rectangle.disable_capture
				full_project
			end
		end

	on_selection_figure_button_pressed(a_figure:DIAGRAM_FIGURE;x, y, button: INTEGER_32; x_tilt, y_tilt, pressure: REAL_64; screen_x, screen_y: INTEGER_32)
			-- When the user press on a figure, update the `selected_figures' to include (or exclude) `a_figure'.
		do
			if button=1 then
				if not  selected_figures.has (a_figure) then
					if not multi_selection_enabled then
						clear_selected_figures
					end
					add_figure_to_selection (a_figure)
				else
					if multi_selection_enabled and then selected_figures.count>1 then
						remove_figure_from_selection (a_figure)
					end
				end
			end

		end

	add_figure_to_selection(a_figure:DIAGRAM_FIGURE)
			-- Add `a_figure' to the `selected_figures' list.
		require
			Figure_Not_Already_Selected: not selected_figures.has (a_figure)
		do

			selected_figures.extend (a_figure)
			handle_points_group.append (a_figure.handle_points)
			update_handle_points
			full_project
		end

	remove_figure_from_selection(a_figure:DIAGRAM_FIGURE)
			-- Remove `a_figure' from the `selected_figures' list.
		do
			selected_figures.prune_all (a_figure)
			across a_figure.handle_points as points_list loop
				handle_points_group.prune_all (points_list.item)
			end
			full_project
		end

	clear_selected_figures
			-- Unselect all figures (empty the `selected_figures' list).
		do
			selected_figures.wipe_out
			handle_points_group.wipe_out
			update_handle_points
			full_project
		end

	project_figure_group (group: EV_FIGURE_GROUP; r: EV_RECTANGLE)
			-- When a figure `group' is drawn on the panel, add the selection rectangle and the figure limitator (with the handle points).
		local
			selection_rectangle:EV_FIGURE_RECTANGLE
		do
			Precursor {EV_DRAWING_AREA_PROJECTOR} (group,r)
			if selected_figures.count>0 then
				create selection_rectangle.default_create
				selection_rectangle.set_foreground_color (default_selection_rectangle_color)
				selection_rectangle.enable_dashed_line_style
				across selected_figures as figures_list loop
					if attached {DIAGRAM_SHAPE} figures_list.item as selected_shape then
						selection_rectangle.point_a.set_position (selected_shape.point.x, selected_shape.point.y)
						selection_rectangle.point_b.set_position (selected_shape.point.x+selected_shape.width, selected_shape.point.y+selected_shape.height)
						draw_figure_rectangle (selection_rectangle)
					end
				end
			end
			if is_selection_motion then
				draw_figure_rectangle (selection_motion_rectangle)
			end
		end

	update_handle_points
			-- Update the handle points position for every selected figure
		do
			across selected_figures as figures_list loop
				figures_list.item.update_handle_points
			end
		end

	activate_handle_points
			-- Show the handle points
		do
			handle_points_group.show
		end

	desactivate_handle_points
			-- Hide the handle points
		do
			handle_points_group.hide
		end

	on_handle_point_start(a_point:HANDLE_POINT;x, y, button: INTEGER_32; x_tilt, y_tilt, pressure: REAL_64; screen_x, screen_y: INTEGER_32)
			-- When the user press on the handle point `a_point', start the handle point motion.
		local
			old_handle_coordinate:TUPLE[x,y:INTEGER]
		do
			if button=1 then
				handle_activated:=a_point
				a_point.enable_capture
				old_handle_coordinate:=coordinate_with_snap(screen_x, screen_y)
				a_point.start_move_pointer (old_handle_coordinate.x, old_handle_coordinate.y)
			end
		end

	on_handle_point_motion(x, y: INTEGER_32; x_tilt, y_tilt, pressure: REAL_64; screen_x, screen_y: INTEGER_32)
			-- When a handle point is active and the user move the handle point, modify the attached figure accordingly.
		local
			new_coordinate:TUPLE[x,y:INTEGER]
		do
			if attached handle_activated as l_handle then
				new_coordinate:=coordinate_with_snap(screen_x, screen_y)
				l_handle.move_pointer (new_coordinate.x, new_coordinate.y)
				update_handle_points
				full_project
			end
		end

	on_handle_point_stop(x, y, button: INTEGER_32; x_tilt, y_tilt, pressure: REAL_64; screen_x, screen_y: INTEGER_32)
			-- When a handle point is active and the user release the left mouse button, stop the handle point motion.
		do
			if button=1 then
				if attached handle_activated as l_handle then
					l_handle.disable_capture
					handle_activated:=void
				end
			end
		end

	coordinate_with_snap(a_x,a_y:INTEGER):TUPLE[x,y:INTEGER]
			-- If the coordinate of a move must snap to the grid, snap it.
		do
			if is_snapping and is_grid_enabled then
				Result:=[world.x_to_grid (a_x),world.y_to_grid (a_y)]
			else
				Result:=[a_x,a_y]
			end
		end

	on_diagram_figure_moving_start(a_figure:DIAGRAM_FIGURE)
			-- When the user start moving `a_figure', prepare the others selected figures to follow it.
		do
			old_move_coordinate:=[a_figure.point.x,a_figure.point.y]
		end

	on_diagram_figure_motion(a_figure:DIAGRAM_FIGURE;x,y:INTEGER)
			-- When the user move `a_figure', make sure the others selected figures follow it.
		do
			across
				selected_figures as figure_list
			loop
				if figure_list.item/=a_figure then
					figure_list.item.point.set_x (figure_list.item.point.x+(a_figure.point.x - old_move_coordinate.x))
					figure_list.item.point.set_y (figure_list.item.point.y+(a_figure.point.y - old_move_coordinate.y))
				end
			end
			update_handle_points
			full_project
			old_move_coordinate:=[a_figure.point.x,a_figure.point.y]
		end

feature {NONE} -- Implementation - Variables


	handle_points_group:EV_FIGURE_GROUP
			-- Group to draw the handle points
		attribute
			create Result.default_create
		end

	diagram_main_group:EV_FIGURE_GROUP
			-- Group to draw diagram figures
		attribute
			create Result.default_create
		end

	selection_motion_rectangle:EV_FIGURE_RECTANGLE
			-- Rectangle to draw when the user press the mouse button on the back and move the mouse to select figures.
		attribute
			create Result.default_create
		end

	is_selection_motion:BOOLEAN
			-- True when the `selection_motion_rectangle' must be drawn.

	buffer: EV_PIXMAP
			-- The drawing buffer to enable multi bufferring
		attribute
			create Result.default_create
		end

	back_rectangle:EV_FIGURE_RECTANGLE
			-- Rectangle tha is always in the back of all figures and handle points ofthe diagram.
			-- Used to detect a mouse pointer pressed on the back of the diagram.
		attribute
			create Result.default_create
		end

	handle_activated: detachable HANDLE_POINT
		-- The handle point that is currently used by the user.
		-- Void if no handle point is currently being used.

	old_move_coordinate:TUPLE[x,y:INTEGER]
			-- When a figure is moved, the last known coordinate of the moved figure.
		attribute
			Result:=[0,0]
		end



end
