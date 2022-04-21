extends Control


export var weekScene: PackedScene

onready var gridContainer = $MonthRect/GridContainer
onready var monthName = $MonthRect/MonthName
onready var monthRect = $MonthRect

var weekStart: int = 0 setget setWeekStart
var weeks: int = 4 setget setWeeks
var daysInMonth: int = 30 setget setDaysInMonth
var month: int = 0 setget setMonth #January is 0

const monthArray = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]


func _ready():
	var invertedColors: bool = false
	if month % 2:
		monthRect.color = Color("bfbfbf")
		invertedColors = true
	for i in weeks:
		var newWeek = weekScene.instance()
		newWeek.setDaysInMonth(daysInMonth)
		newWeek.setStartDate(i * 7 - weekStart + 1)
		if invertedColors:
			newWeek.invertColors()
		gridContainer.add_child(newWeek)
		monthName.text = verticalString(monthArray[month])
	pass

func setWeekStart(value):
	weekStart = value
	
func setWeeks(value):
	weeks = value

func setDaysInMonth(value):
	daysInMonth = value

func setMonth(value):
	month = value

func verticalString(string):
	var verticalString: String = ""
	for c in string:
		verticalString += c + "\n"
	verticalString.erase(verticalString.length() - 1, 1)
	return verticalString
