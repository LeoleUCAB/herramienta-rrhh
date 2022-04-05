extends Control

onready var monthRect = $MonthRect

var weeks: int = 4 setget setWeeks

func _ready():
	for i in weeks:
		monthRect.rect_size += Vector2(0, 933.33)
	pass # Replace with function body.
	
func setWeeks(value):
	weeks = value
