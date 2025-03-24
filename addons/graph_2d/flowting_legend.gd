@tool
extends Control
class_name FlowtingLegend

@export var graph : Graph2D

const _Graph2DLegend = preload("res://addons/graph_2d/custom_nodes/legend.gd")
var legend: Legend
var backgrnound: ColorRect

func _ready() -> void:
	legend = _Graph2DLegend.new()
	add_child(legend)
	if graph :
		graph.legend_updated.connect(_on_graph_legend_updated)
		backgrnound = ColorRect.new()
		backgrnound.layout_mode = 1
		backgrnound.anchors_preset = Control.PRESET_FULL_RECT
		backgrnound.color = graph.background_color
		add_child(backgrnound)
		move_child(backgrnound,0)
	else :
		printerr("No graph declared for the flowting legend node")

func _on_graph_legend_updated(labels:Array):
	legend.update(labels)
