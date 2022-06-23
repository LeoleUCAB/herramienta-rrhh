extends Control

export var dayScene: PackedScene

var year = 2022
var month = 1
var weekStart = 1
var daysInMonth = 31
const monthArray = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

onready var grid = $DayGrid
onready var monthName = $MonthName

signal monthHover(month)

func _ready():
	for i in range(daysInMonth + weekStart):
		var newDay = dayScene.instance()
		newDay.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		grid.add_child(newDay)
		newDay.dayNumber = i+1-weekStart
		if(i < weekStart):
			newDay.modulate = Color(1, 1, 1, 0)
		monthName.text = monthArray[month-1]

func init(param: Dictionary): #{"year": int, "month": int, "weekStart": int, "daysInMonth": int}
	year = param.year
	month = param.month
	weekStart = param.weekStart
	daysInMonth = param.daysInMonth
	pass


func _on_Month_mouse_entered():
	emit_signal("monthHover", month)
