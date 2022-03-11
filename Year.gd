extends Node2D

var time = OS.get_datetime()
onready var month = $Month

# Called when the node enters the scene tree for the first time.
func _ready():
	month.set_date(time)
	print(time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
