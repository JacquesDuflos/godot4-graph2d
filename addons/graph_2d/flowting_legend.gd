@tool
extends Control
class_name FlowtingLegend

@export var graph : Graph2D

const _Graph2DLegend = preload("res://addons/graph_2d/custom_nodes/legend.gd")
var legend: Legend

func _ready() -> void:
	legend = _Graph2DLegend.new()
	add_child(legend)
	if graph :
		graph.legend_updated.connect(_on_graph_legend_updated)
	else :
		printerr("No graph declared for the flowting legend node")

func _on_graph_legend_updated(labels):
	legend.update(labels)
