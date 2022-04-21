extends Control

onready var monthRect = $MonthRect
onready var monthName = $MonthName

var weeks: int = 4 setget setWeeks
var color: Color = Color("d9d9d9") setget setColor
var month: int = 0 setget setMonth #January is 0

const monthArray = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]


func _ready():
	for i in weeks:
		monthRect.rect_size += Vector2(0, 933.33)
	monthRect.color = color
	monthName.text = verticalString(monthArray[month])
	
func setWeeks(value):
	weeks = value
	
func setColor(value):
	color = value

func setMonth(value):
	month = value

func verticalString(string):
	var verticalString: String = ""
	for c in string:
		verticalString += c + "\n"
	verticalString.erase(verticalString.length() - 1, 1)
	return verticalString
