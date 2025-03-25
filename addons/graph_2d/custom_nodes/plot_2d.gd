@tool
extends Control
class_name Plot2D

var points_px := PackedVector2Array([])
var with_area : bool
var perimeter_px := PackedVector2Array([])
var color: Color = Color.WHITE
var color_area: Color
var width: float = 1.0


func _draw() -> void:
	if points_px.size() > 1:
		draw_polyline(points_px, color, width, true)
	if with_area:
		var areas := Geometry2D.merge_polygons(perimeter_px,PackedVector2Array([]))
		color_area = color
		color_area.a = 0.2
		for area in areas:
			draw_colored_polygon(area,color_area)
