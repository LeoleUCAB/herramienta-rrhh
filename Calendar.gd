extends Node2D

onready var scrollContainer = $ScrollContainer/VBoxContainer
export var yearScene: PackedScene

func _ready():
	for i in range(5):
		var newYear = yearScene.instance()
		newYear.setYear(2020 + i)
		newYear.rect_min_size = Vector2(35850, 20160)
		newYear.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		scrollContainer.add_child(newYear)
	pass
	
