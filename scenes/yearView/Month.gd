extends Control

export var dayScene: PackedScene

var dayList = []
var appointmentList = []
var pagination = {} setget setPagination
var year = 2022
var month = 1
var weekStart = 1
var daysInMonth = 31
const monthArray = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

onready var grid = $DayGrid
onready var monthName = $MonthName

signal monthHover(month)
signal monthClick(currentClickDate)

func _ready():
	for i in range(daysInMonth + weekStart):
		var newDay = dayScene.instance()
		newDay.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		grid.add_child(newDay)
		newDay.dayNumber = i+1-weekStart
		newDay.connect("dayClick", self, "updateDayClick")
		if(i < weekStart):
			newDay.modulate = Color(1, 1, 1, 0)
		monthName.text = monthArray[month-1]
		dayList.append(newDay)

func init(param: Dictionary): #{"year": int, "month": int, "weekStart": int, "daysInMonth": int}
	year = param.year
	month = param.month
	weekStart = param.weekStart
	daysInMonth = param.daysInMonth
	pass

func _on_Month_mouse_entered():
	emit_signal("monthHover", month)

func updateDayClick(day):
	var currentClickDate = {
		"month": month,
		"day": day
	}
	emit_signal("monthClick", currentClickDate)

func setPagination(value):
	pagination = value
	setAppointments()

func setAppointments():
	for dayItem in dayList:
		var dayAppointments = []
		var day = dayItem.dayNumber
		if pagination.has(day):
			for page in pagination[day]:
				dayAppointments.append(appointmentList[page])
		dayItem.appointmentList = dayAppointments
