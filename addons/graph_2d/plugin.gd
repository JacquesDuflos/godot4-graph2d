@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("Graph2D", "Control",
					preload("res://addons/graph_2d/graph_2d.gd"),
					preload("res://addons/graph_2d/graph_2d.svg"),
					)
	add_custom_type("FloatingLegend", "Control",
					preload("res://addons/graph_2d/floating_legend.gd"),
					preload("res://addons/graph_2d/legend.svg"),
					)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("Graph2D")
	remove_custom_type("FloatingLegend")
