extends ColorRect

onready var dayNumber = $DayNumber

func _ready():
	pass

func setDayNumber(value):
	dayNumber.text = value as String
