extends Control

export var dayScene: PackedScene

var year
var month
var weekStart
var daysInMonth
const monthArray = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

onready var grid = $DayGrid
onready var monthName = $MonthName

func _ready():
	for i in range(daysInMonth + weekStart):
		var newDay = dayScene.instance()
		grid.add_child(newDay)
		newDay.setDayNumber(i+1-weekStart)
		if(i < weekStart):
			newDay.modulate = Color(1, 1, 1, 0)
		monthName.text = monthArray[month-1]

func init(param: Dictionary): #{"year": int, "month": int, "weekStart": int, "daysInMonth": int}
	year = param.year
	month = param.month
	weekStart = param.weekStart
	daysInMonth = param.daysInMonth
	pass
