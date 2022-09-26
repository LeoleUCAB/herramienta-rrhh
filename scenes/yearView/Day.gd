extends Control

onready var dayNumberLabel = $DayNumber
onready var LAG = $LongAppointmentGrid
onready var SAG = $ShortAppointmentGrid

const LAGConst = 0
const SAGConst = 1

var dayNumber setget setDayNumber
var appointmentList = [] setget setAppointments
var appointmentRects = []

signal dayClick(day)

func _ready():
	pass

func setDayNumber(value):
	dayNumber = value
	dayNumberLabel.text = value as String
		
func _on_Day_gui_input(event):
	if event.get_class() == "InputEventMouseButton" and event.pressed == true:
		emit_signal("dayClick", dayNumber)
		
func setAppointments(value):
	appointmentList = value
	for appointment in appointmentRects:
		if appointment.grid == LAGConst:
			LAG.remove_child(appointment.obj)
		else:
			SAG.remove_child(appointment.obj)
		appointment.obj.queue_free()
	appointmentRects = []
	
	for appointment in appointmentList:
		var newAppointment = ColorRect.new()
		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
		newAppointment.color = appointment.color
		if appointment.isItDaylong:
			newAppointment.rect_min_size = Vector2(168, 84)
			LAG.add_child(newAppointment)
			appointmentRects.append({"grid": LAGConst, "obj": newAppointment})
		else:
			newAppointment.rect_min_size = Vector2(168, 56)
			SAG.add_child(newAppointment)
			appointmentRects.append({"grid": SAGConst, "obj": newAppointment})
