@tool
extends Control
class_name FloatingLegend
## Display the legend of a [Graph2D]
##
## This node will display the list of [PoltItem] names that a [Graph2D]
## has. It is used as alternative to the legend displayed inside the 
## plot area. You can hide the legend of the plot area by setting the
## show_legend parameter of the [Graph2D].
##
## tutorial: https://www.reddit.com/r/godot/comments/1jkc0al/graph2d_plugin_floating_legend_branch/

## The [Graph2D] of which's legend will be displayed.
@export var graph : Graph2D

const _Graph2DLegend = preload("res://addons/graph_2d/custom_nodes/legend.gd")
var legend: Legend
var label_list : VBoxContainer
var backgrnound: ColorRect


func _ready() -> void:
	legend = _Graph2DLegend.new()
	add_child(legend)
	label_list = legend.get_child(0) as VBoxContainer
	label_list.resized.connect(_on_resized)
	if graph :
		graph.legend_updated.connect(_on_graph_legend_updated)
		backgrnound = ColorRect.new()
		backgrnound.layout_mode = 1
		backgrnound.anchors_preset = Control.PRESET_FULL_RECT
		backgrnound.color = graph.background_color
		add_child(backgrnound)
		move_child(backgrnound,0)
	else :
		printerr("No graph declared for the floating legend node")


func _on_graph_legend_updated(labels:Array):
	legend.update(labels)


func _on_resized() -> void:
	size = label_list.size + Vector2(20,40)
	
