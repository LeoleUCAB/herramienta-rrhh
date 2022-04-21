extends Control


onready var Day1 = $GridContainer/Rect1
onready var Day2 = $GridContainer/Rect2
onready var Day3 = $GridContainer/Rect3
onready var Day4 = $GridContainer/Rect4
onready var Day5 = $GridContainer/Rect5
onready var Day6 = $GridContainer/Rect6
onready var Day7 = $GridContainer/Rect7

var dayList = Array()
var startDate = 0 setget setStartDate
var daysInMonth = 30 setget setDaysInMonth
var color = [Color("d9d9d9"), Color("bfbfbf")]


func _ready():
	dayList = [Day1, Day2, Day3, Day4, Day5, Day6, Day7]
	var inverted: bool = false
	for i in dayList.size():
		var date = (startDate + 7 + i)
		if date > daysInMonth:
			date -= daysInMonth
			if not inverted:
				invertColors()
				inverted = true
		dayList[i].get_node("DayLabel").text = date as String
		dayList[i].get_node("ColorRect").color = color[0]
	pass

func setStartDate(value):
	startDate = value

func setDaysInMonth(value):
	daysInMonth = value
	
func invertColors():
	color.invert()
	
func addLog(startDate, endDate):
	pass
