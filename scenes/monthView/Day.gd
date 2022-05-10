extends Control


onready var dayLabel = $Rect/DayLabel
onready var dayRect = $Rect/ColorRect
onready var grid = $Rect/GridContainer

const placeholderAppointment = {
	"start": 0,
	"color": Color(0, 0, 0, 0)
}

var date: String = "01" setget setDate
var color: Color = Color("d9d9d9") setget setColor
var appointmentList: Array = Array()

func _ready():
	dayLabel.text = date
	dayRect.color = color
	for appointmentItem in appointmentList:
		var newAppointment = ColorRect.new()
		newAppointment.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		var rectSize = Vector2(1000, 50)
		print(appointmentItem)
		if date as int == appointmentItem.start:
			rectSize += Vector2(1100 * (appointmentItem.weight - 1), 0)
		newAppointment.rect_min_size = rectSize
		newAppointment.color = appointmentItem.color
		grid.add_child(newAppointment)
	pass
	
func setDate(value):
	date = value as String
	
func setColor(value):
	color = value as Color
	
func addAppointment(appointment): #value = {start, end, color}
	appointmentList.append(appointment)
	
func addPlaceholderAppointment(value):
	for i in value:
		appointmentList.append(placeholderAppointment)
