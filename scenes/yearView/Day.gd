extends Control

onready var dayNumberLabel = $DayNumber
onready var LAG = $LongAppointmentGrid
onready var SAG = $ShortAppointmentGrid

var dayNumber setget setDayNumber
var appointmentList = [] setget setAppointments

signal dayClick(day)

func _ready():
	pass

func setDayNumber(value):
	dayNumber = value
	dayNumberLabel.text = value as String
	
func generateRandomAppointments():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
#	for i in range(rng.randi_range(0, 4)):
#		var newAppointment = ColorRect.new()
#		newAppointment.rect_min_size = Vector2(168, 84)
#		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
#		newAppointment.color = colorList[i]
#		LAG.add_child(newAppointment)
#	for i in range(rng.randi_range(0, 3)):
#		var newAppointment = ColorRect.new()
#		newAppointment.rect_min_size = Vector2(168, 56)
#		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
#		newAppointment.color = colorList[colorList.size()-i-1]
#		SAG.add_child(newAppointment)
		
func _on_Day_gui_input(event):
	if event.get_class() == "InputEventMouseButton" and event.pressed == true:
		emit_signal("dayClick", dayNumber)
		
func setAppointments(value):
	appointmentList = value
	
	for appointment in appointmentList:
		var newAppointment = ColorRect.new()
		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
		newAppointment.color = appointment.color
		if appointment.isItDaylong:
			newAppointment.rect_min_size = Vector2(168, 84)
			LAG.add_child(newAppointment)
		else:
			newAppointment.rect_min_size = Vector2(168, 56)
			SAG.add_child(newAppointment)
