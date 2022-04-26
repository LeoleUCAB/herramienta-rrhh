extends Control

var startDate = 0 setget setStartDate
var daysInMonth = 30 setget setDaysInMonth
var color = [Color("d9d9d9"), Color("bfbfbf")]
var dayList: Array

onready var grid = $GridContainer

export var dayScene: PackedScene


func _ready():
	var inverted: bool = false
	for i in 7:
		var newDay = dayScene.instance()
		var date = (startDate + 7 + i)
		if date > daysInMonth:
			date -= daysInMonth
			if not inverted:
				invertColors()
				inverted = true
		newDay.setDate(date as String)
		newDay.setColor(color[0] as Color)
		newDay.rect_min_size = Vector2(1100, 933)
		grid.add_child(newDay)
	pass

func setStartDate(value):
	startDate = value

func setDaysInMonth(value):
	daysInMonth = value
	
func invertColors():
	color.invert()
	
func addLog(startDate, endDate):
	pass
