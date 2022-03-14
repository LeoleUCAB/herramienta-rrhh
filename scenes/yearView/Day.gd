extends Control

onready var dayNumberLabel = $DayNumber
onready var LAG = $LongAppointmentGrid

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
	for i in range(rng.randi_range(1, 4)):
		var newAppointment = ColorRect.new()
		newAppointment.rect_min_size = Vector2(6, 3)
		newAppointment.size_flags_vertical = SIZE_EXPAND + SIZE_SHRINK_CENTER
		var colorList = [
			Color(33/255 as float, 182/255 as float, 168/255 as float, 1),
			Color(23/255 as float, 127/255 as float, 117/255 as float, 1),
			Color(182/255 as float, 33/255 as float, 45/255 as float, 1),
			Color(127/255 as float, 23/255 as float, 31/255 as float, 1),
			Color(182/255 as float, 119/255 as float, 33/255 as float, 1),
			Color(127/255 as float, 84/255 as float, 23/255 as float, 1)
			]
		newAppointment.color = colorList[i]
		LAG.add_child(newAppointment)
