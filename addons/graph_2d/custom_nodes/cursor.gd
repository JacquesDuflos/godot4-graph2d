extends Control
class_name PlotCursor

var graph : Graph2D
## The x coordinate displayed next to the mouse
var x_label : Label
## The y coordinate displayed next to the mouse
var y_label : Label


func _ready() -> void:
	graph = get_parent().get_parent() as Graph2D
	x_label = Label.new()
	x_label.rotation = PI/2
	add_child(x_label)
	y_label = Label.new()
	add_child(y_label)


func _draw() -> void:
	#draw_circle(graph.mouse_px, 20, Color.AQUA)
	draw_horizontal_cursor()
	draw_vertical_cursor()
	draw_plot_intersection()


func draw_vertical_cursor():
	if not graph.show_vertical_curser :
		x_label.hide()
		return
	var fr : Vector2
	var to : Vector2
	match graph.vertical_curser_extend:
		0:
			fr = Vector2(0, graph.mouse_px.y)
			to = Vector2(graph.plot_area.size.x, graph.mouse_px.y)
		1:
			fr = graph.mouse_px
			to = graph._coordinate_to_pixel(Vector2(0, graph.mouse_coor.y))
			to.x = clamp(to.x, 0, graph.plot_area.size.x)
	draw_line(fr, to, graph.y_color)
	x_label.position = graph.mouse_px + Vector2(20,20)
	x_label.modulate = graph.x_color
	x_label.text = "%.3f" % [graph.mouse_coor.x]
	x_label.show()


func draw_horizontal_cursor():
	if not graph.show_horizontal_curser : return
	var fr : Vector2
	var to : Vector2
	match graph.horizontal_curser_extend:
		0:
			fr = Vector2(graph.mouse_px.x, 0)
			to = Vector2(graph.mouse_px.x, graph.plot_area.size.y)
		1:
			fr = graph.mouse_px
			to = graph._coordinate_to_pixel(Vector2(graph.mouse_coor.x, 0))
			to.y = clamp(to.y, 0, graph.plot_area.size.y)
	draw_line(fr, to, graph.x_color)
	y_label.position = graph.mouse_px + Vector2(20,-20)
	y_label.modulate = graph.y_color
	y_label.text = "%.3f" % [graph.mouse_coor.y]
	y_label.show()
	

func draw_plot_intersection():
	for plot:PlotItem in graph._plots:
		for i:int in plot._curve.points_px.size()-1:
			var intersect : Vector2
			if ((plot._curve.points_px[i].x <= graph.mouse_px.x) ==
					(plot._curve.points_px[i+1].x > graph.mouse_px.x)) :
				intersect = Vector2(graph.mouse_px.x, remap(
						graph.mouse_px.x,
						plot._curve.points_px[i].x, plot._curve.points_px[i+1].x,
						plot._curve.points_px[i].y, plot._curve.points_px[i+1].y))
				draw_circle(
						intersect,
						20,
						plot._curve.color
				)
				
