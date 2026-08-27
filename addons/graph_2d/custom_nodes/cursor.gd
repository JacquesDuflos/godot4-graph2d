extends Control
class_name PlotCursor

var graph : Graph2D


func _ready() -> void:
	graph = get_parent().get_parent() as Graph2D


func _draw() -> void:
	draw_circle(graph.mouse_px, 20, Color.AQUA)
	draw_line(
			Vector2(graph.mouse_px.x, 0),
			Vector2(graph.mouse_px.x, graph.plot_area.size.y),
			Color.INDIAN_RED,
	)
	draw_line(
			Vector2(0, graph.mouse_px.y),
			Vector2(graph.plot_area.size.x, graph.mouse_px.y),
			Color.OLD_LACE,
	)
