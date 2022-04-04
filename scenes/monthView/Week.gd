extends GridContainer


onready var Day1 = $Rect1
onready var Day2 = $Rect2
onready var Day3 = $Rect3
onready var Day4 = $Rect4
onready var Day5 = $Rect5
onready var Day6 = $Rect6
onready var Day7 = $Rect7

var dayList = Array()
var startDate setget setStartDate


# Called when the node enters the scene tree for the first time.
func _ready():
	dayList = [Day1, Day2, Day3, Day4, Day5, Day6, Day7]
	pass # Replace with function body.


func set_invisible(upTo):
	for i in range(0, upTo):
		dayList[i].modulate = Color(1, 1, 1, 0)
	pass

func setStartDate(value):
	startDate = value
	for i in range(7):
		dayList[i].DayLabel.text = (startDate + i) as String
