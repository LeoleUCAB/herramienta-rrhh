extends Control


onready var dayLabel = $ColorRect/DayLabel
onready var dayRect = $ColorRect
onready var grid = $GridContainer

const placeholderAppointment = {
	"end": 0,
	"weight": 1,
	"color": Color(0, 0, 0, 0)
}

var date: String = "01" setget setDate
var month: int = 1 setget setMonth
var color: Color = Color("d9d9d9") setget setColor
var appointmentList: Array = Array()
var lastDay: bool = false

signal updateDayHover(dayValue)
signal updateDayClick(clickValue)

func _ready():
	if date.length() == 1:
		date = "0" + date
	dayLabel.text = date
	dayRect.color = color
	for appointmentItem in appointmentList:
		var newAppointment = ColorRect.new()
		newAppointment.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		var rectSize = Vector2(1000, 50)
#		if date as int == appointmentItem.end or lastDay:
#			rectSize += Vector2(1100 * (appointmentItem.weight - 1), 0)
		newAppointment.rect_min_size = rectSize
		newAppointment.color = appointmentItem.color
		grid.add_child(newAppointment)
	pass
	
func setDate(value):
	date = value as String
	
func setMonth(value):
	month = value
	
func setColor(value):
	color = value as Color
	
func addAppointment(appointment): #value = {start, end, color}
	appointmentList.append(appointment)
	
func addPlaceholderAppointment(value):
	for i in value:
		appointmentList.append(placeholderAppointment)

func _on_mouse_entered():
	emit_signal("updateDayHover", month)
	pass # Replace with function body.

func _on_Day_gui_input(event):
	if event.get_class() == "InputEventMouseButton" and event.pressed == true:
		var currentDayClick = {
			"month": month,
			"day": date as int
		}
		emit_signal("updateDayClick", currentDayClick)
	pass # Replace with function body.
