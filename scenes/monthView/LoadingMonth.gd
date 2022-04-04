extends Control

onready var monthRect = $MonthRect

var year: int = 1900 setget setYear

func _ready():
	for i in 5:
		monthRect.rect_size += Vector2(0, 933)
	pass # Replace with function body.

func setYear(value):
	year = value
