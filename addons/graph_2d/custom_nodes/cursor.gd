extends Control
class_name PlotCursor

var graph : Graph2D


func _ready() -> void:
	graph = get_parent().get_parent() as Graph2D


func _draw() -> void:
	draw_circle(graph.mouse_px, 20, Color.AQUA)
	draw_horizontal_cursor()
	draw_vertical_cursor()


func draw_vertical_cursor():
	if not graph.show_vertical_curser : return
	var fr : Vector2
	var to : Vector2
	match graph.vertical_curser_extend:
		0:
			fr = Vector2(0, graph.mouse_px.y)
			to = Vector2(graph.plot_area.size.x, graph.mouse_px.y)
		1:
			fr = graph.mouse_px
			to = graph._coordinate_to_pixel(Vector2(0, graph.mouse_coor.y))
	draw_line(fr, to, Color.OLD_LACE)


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
	draw_line(fr, to, Color.INDIAN_RED)
	
