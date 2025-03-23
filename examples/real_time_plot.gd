extends Control

@onready var v_slider: VSlider = $VSlider
@onready var graph_2d: Graph2D = $Graph2D
var plot : PlotItem
var t : float
const DT = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plot = graph_2d.add_plot_item("slider", Color.BURLYWOOD,1)
	t = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	plot.add_point(Vector2(t,v_slider.value))
	t += delta
	if t > DT :
		graph_2d.x_max = t
		graph_2d.x_min = t-DT

