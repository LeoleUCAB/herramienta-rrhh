extends Control


onready var dayLabel = $Rect/DayLabel
onready var dayRect = $Rect/ColorRect

var date: String = "01"
var color: Color = Color("d9d9d9")

func _ready():
	dayLabel.text = date
	dayRect.color = color
	pass
	
func setDate(value):
	date = value as String
	
func setColor(value):
	color = value as Color
