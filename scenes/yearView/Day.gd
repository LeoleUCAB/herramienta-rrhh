extends Control

onready var dayNumberLabel = $DayNumber
onready var LAG = $LongAppointmentGrid
onready var SAG = $ShortAppointmentGrid

var dayNumber setget setDayNumber

signal dayClick(day)

func _ready():
	generateRandomAppointments()
	pass

func setDayNumber(value):
	dayNumber = value
	dayNumberLabel.text = value as String
	
func generateRandomAppointments():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var colorList = [
		Color.aqua,
		Color.coral,
		Color.indigo,
		Color.orangered,
		Color.orchid,
		Color.gold
	]
	for i in range(rng.randi_range(0, 4)):
		var newAppointment = ColorRect.new()
		newAppointment.rect_min_size = Vector2(168, 84)
		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
		newAppointment.color = colorList[i]
		LAG.add_child(newAppointment)
	for i in range(rng.randi_range(0, 3)):
		var newAppointment = ColorRect.new()
		newAppointment.rect_min_size = Vector2(168, 56)
		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
		newAppointment.color = colorList[colorList.size()-i-1]
		SAG.add_child(newAppointment)
		
func _on_Day_gui_input(event):
	if event.get_class() == "InputEventMouseButton" and event.pressed == true:
		emit_signal("dayClick", dayNumber)
