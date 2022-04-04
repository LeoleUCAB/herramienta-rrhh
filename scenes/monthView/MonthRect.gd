extends ColorRect

onready var grid = $GridContainer
onready var monthName = $MonthName


# Called when the node enters the scene tree for the first time.
func _ready():
	print(monthName.rect_size)
	yield(get_tree(), "idle_frame")
	rect_size.y = grid.rect_size.y
	monthName.text="W\nH\nA\nT\nE\nV\nE\nR"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
