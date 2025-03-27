@tool
extends Control
class_name Plot2D

var points_px := PackedVector2Array([])
var with_area : bool
var perimeters_px : Array[AreaBeneathCurve]
var color: Color = Color.WHITE
var color_area: Color
var width: float = 1.0


func _draw() -> void:
	_draw_polyline()
	_draw_polygons()

func _draw_polyline():
	if points_px.size() <= 1: return
	draw_polyline(points_px, color, width, true)
	

func _draw_polygons():
	if not with_area: return
	color_area = color
	color_area.a = 0.2
	for poligon in perimeters_px:
		draw_colored_polygon(poligon.points,color_area)
