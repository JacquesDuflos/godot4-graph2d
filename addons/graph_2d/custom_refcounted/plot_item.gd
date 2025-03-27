class_name PlotItem
extends RefCounted

## PlotItem offers properties and some methods on the plot.
##
## You do not directly create a [b]PlotItem[/b] type variable. This is created with the method [method Graph2D.add_plot_item].

## Plot label
var label: String:
	set(value):
		label = value
		if not label.is_empty():
			_curve.name = label
	get:
		return label

## Line color
var color: Color = Color.WHITE:
	set(value):
		color = value
		_curve.color = color

## Line thickness
var thickness: float = 1.0:
	set(value):
		if value > 0.0:
			thickness = value
			_curve.width = thickness

var _curve : Plot2D
var _LineCurve = preload("res://addons/graph_2d/custom_nodes/plot_2d.gd")
var _points: PackedVector2Array
var _graph:Graph2D


func _init(obj, l, c, w, a):
	_curve = _LineCurve.new()
	_graph = obj
	label = l
	_curve.name = l
	_curve.color = c
	_curve.width = w
	_curve.with_area = a
	_graph.get_node("PlotArea").add_child(_curve)


## Add point to plot
func add_point(pt: Vector2):
	_points.append(pt)
	_redraw()


## Remove point from plot
func remove_point(pt: Vector2):
	if _points.find(pt) == -1:
		printerr("No point found with the coordinates of %s" % str(pt))
	_points.remove_at(_points.find(pt))
	var point = pt.clamp(Vector2(_graph.x_min, _graph.y_min), Vector2(_graph.x_max, _graph.y_max))
	var pt_px: Vector2
	pt_px.x = remap(point.x, _graph.x_min, _graph.x_max, 0, _graph.get_node("PlotArea").size.x)
	pt_px.y = remap(point.y, _graph.y_min, _graph.y_max, _graph.get_node("PlotArea").size.y, 0)
	_curve.points_px.remove_at(_curve.points_px.find(pt_px))
	_curve.queue_redraw()


## Remove all points from plot
func remove_all():
	_points.clear()
	_curve.points_px.clear()
	_curve.queue_redraw()


## Delete instance
func delete():
	_graph.get_node("PlotArea").remove_child(_curve)
	_curve.queue_free()
	call_deferred("unreference")


func _redraw():
	_curve.points_px.clear()
	_curve.perimeters_px.clear()
	var perimetre := AreaBeneathCurve.new()
	var last_point : Vector2
	var leftmost_point : Vector2
	var rightmost_point : Vector2
	for pt in _points:
		#print_debug("Plot redraw %s" % pt)
		if pt.x > _graph.x_max or pt.x < _graph.x_min: continue
		
		var point = pt.clamp(Vector2(_graph.x_min, _graph.y_min), Vector2(_graph.x_max, _graph.y_max))
		var pt_px: Vector2i
		pt_px = _graph._coordinate_to_pixel(point)
		if last_point :
			# TODO : calculer l'integrale
			if pt.y * last_point.y <= 0:
				var intersect := Vector2(0, 0)
				intersect.x = remap(
					0,
					last_point.y, pt.y,
					last_point.x, pt.x,
				)
				intersect = _graph._coordinate_to_pixel(intersect)
				perimetre.points.append(intersect)
				_curve.perimeters_px.append(perimetre)
				perimetre = AreaBeneathCurve.new()
				perimetre.points.append(intersect)
		perimetre.points.append(pt_px)
		last_point = pt
				
		if leftmost_point:
			if pt_px.x < leftmost_point.x :
				leftmost_point = pt_px
		else :
			leftmost_point = pt_px
		if rightmost_point:
			if pt_px.x > rightmost_point.x :
				rightmost_point = pt_px
		else :
			rightmost_point = pt_px
		_curve.points_px.append(pt_px)
	var y0_px : float
	y0_px = remap (0, _graph.y_min, _graph.y_max, _graph.get_node("PlotArea").size.y, 0)
	y0_px = clamp(y0_px, 0, _graph.get_node("PlotArea").size.y)
	_curve.perimeters_px.append(perimetre)
	_curve.perimeters_px[-1].points.append(Vector2(rightmost_point.x,y0_px))
	_curve.perimeters_px[0].points.append(Vector2(leftmost_point.x,y0_px))
	_curve.queue_redraw()
