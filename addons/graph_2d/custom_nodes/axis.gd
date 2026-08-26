@tool
extends Control

var default_font: Font

enum {
	POINT = 0,
	LABEL,
}

var vert_grad: Array # [Vector2, String]
var hor_grad: Array
var x_label: String
var y_label: String
var show_x_ticks: bool
var show_y_ticks: bool
var show_x_numbers: bool
var show_y_numbers: bool
var show_vertical_line: bool
var show_horizontal_line: bool
## 0 : bottom ; 1 : top ; 2 : floating
var x_axis_pos : int
## 0 : left ; 1 : right ; 2 : floating
var y_axis_pos : int
var x_color : Color = Color.WHITE
var y_color : Color = Color.WHITE
var zero_px : Vector2i


func _ready():
	name = "Axis"
	default_font = ThemeDB.fallback_font
	var x_label_node = Label.new()
	x_label_node.name = "XLabel"
	add_child(x_label_node)
	var y_label_node = Label.new()
	y_label_node.name = "YLabel"
	y_label_node.rotation = -PI/2
	add_child(y_label_node)
	

func _draw() -> void:
	if vert_grad.is_empty() or hor_grad.is_empty(): return
	
	var topleft: Vector2 = vert_grad.front()[POINT]
	var topright: Vector2 = Vector2(hor_grad.back()[POINT].x, vert_grad.front()[POINT].y)
	var bottomright: Vector2 = hor_grad.back()[POINT]
	var zero_x : int
	if y_axis_pos == 0 :
		zero_x = topleft.x
	if y_axis_pos == 1 :
		zero_x = topright.x
	if y_axis_pos == 2 :
		zero_x = clamp(zero_px.x, topleft.x, topright.x)
	
	var zero_y : int
	if x_axis_pos == 0 :
		zero_y = topleft.y
	if x_axis_pos == 1 :
		zero_y= bottomright.y
	if x_axis_pos == 2 :
		zero_y = clamp(zero_px.y, topleft.y, bottomright.y)
	
	#draw_circle(zero_px, 10, Color.REBECCA_PURPLE)
	if show_x_ticks:
		for grad in hor_grad:
			var _starting_point : Vector2 = Vector2(grad[POINT].x, zero_y)
			draw_line(_starting_point, _starting_point + Vector2(0, 10), x_color)
	
	if show_x_numbers:
		for grad in hor_grad:
			var _starting_point : Vector2 = Vector2(grad[POINT].x, zero_y)
			draw_string(
					default_font,
					_starting_point + Vector2(0, 20),
					grad[LABEL],
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					16,
					x_color,
			)
	
	if show_horizontal_line == true:
		draw_line(Vector2(topleft.x, zero_y), Vector2(topright.x, zero_y), x_color)

	if show_y_ticks == true:
		for grad in vert_grad:
			var _starting_point : Vector2 = Vector2(zero_x, grad[POINT].y)
			draw_line(_starting_point, _starting_point - Vector2(10, 0), y_color)
	
	if show_y_numbers == true:
		for grad in vert_grad:
			var _starting_point : Vector2 = Vector2(zero_x, grad[POINT].y)
			draw_string(
					default_font,
					_starting_point + Vector2(-35, -5),
					grad[LABEL],
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					16,
					y_color,
			)

	if show_vertical_line == true:
		draw_line(Vector2(zero_x, topleft.y), Vector2(zero_x, bottomright.y), y_color)

	get_node("XLabel").text = x_label
	get_node("YLabel").text = y_label 
	get_node("XLabel").position = Vector2((bottomright.x + topleft.x)/2, bottomright.y + 20)
	get_node("YLabel").position = Vector2(5, (bottomright.y + topleft.y)/2)
