extends Control

onready var dayNumberLabel = $DayNumber
onready var LAG = $LongAppointmentGrid
onready var SAG = $ShortAppointmentGrid

var dayNumber setget setDayNumber

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
		newAppointment.rect_min_size = Vector2(6, 3)
		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
		newAppointment.color = colorList[i]
		LAG.add_child(newAppointment)
	for i in range(rng.randi_range(0, 3)):
		var newAppointment = ColorRect.new()
		newAppointment.rect_min_size = Vector2(6, 2)
		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
		newAppointment.color = colorList[colorList.size()-i-1]
		SAG.add_child(newAppointment)
		
