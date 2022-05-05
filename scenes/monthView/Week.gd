extends Control

var startDate = 0 setget setStartDate
var daysInMonth = 30 setget setDaysInMonth
var color = [Color("d9d9d9"), Color("bfbfbf")]
var dayList: Array
var appointmentList: Array = Array()

onready var grid = $GridContainer

export var dayScene: PackedScene


func _ready():
	var inverted: bool = false
	appointmentList.sort_custom(sortAppointments, "sortByStartDate")
	var heavyAppointments = setWeight(appointmentList, startDate + 7 - 1)
#	print(appointmentList)
	for i in 7:
		var newDay = dayScene.instance()
		newDay.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		var date = (startDate + 7 + i - 1) #startdate is week number within month times 7 minus the weekday, e.g. 0 for sunday. It's minus 1 because you start on sunday, not monday
		if date > daysInMonth:
			date -= daysInMonth
			if not inverted:
				invertColors()
				inverted = true
		newDay.setDate(date as String)
		newDay.setColor(color[0] as Color)
		newDay.rect_min_size = Vector2(1100, 933)
		var dayAppointments = Array()
		for appointment in appointmentList: # appointment: { start: int, end: int, color: Color, level: null }
			if appointment.start <= date and appointment.end >= date:
				dayAppointments.append(appointment)
		dayAppointments.sort_custom(sortAppointments, "sortByWeight")
		var currentLevel = 0
		for j in dayAppointments.size():
			var appointment = dayAppointments[j]
			if appointment.start == date or i == 0:
				appointment.level = j
				if i == 0:
					if (appointment.weight > 1 and appointment.weight < 6):
						appointment.level += heavyAppointments[0]
						if appointment.weight < 5:
							appointment.level += heavyAppointments[2]
					if (appointment.weight > 2 and appointment.weight < 5):
						appointment.level += heavyAppointments[1]
				if i == 1:
					if (appointment.weight > 1 and appointment.weight < 5):
						appointment.level += heavyAppointments[0]
			if appointment.level != j:
				newDay.addPlaceholderAppointment(appointment.level - currentLevel)
			newDay.addAppointment(dayAppointments[j])
			currentLevel = appointment.level + 1
		grid.add_child(newDay)
	pass

func setStartDate(value):
	startDate = value

func setDaysInMonth(value):
	daysInMonth = value
	
func invertColors():
	color.invert()
	
func addAppointment(appointment):
	appointmentList.append(appointment)
		
func setWeight(appointments, startDate):
	var heavyAppointments = Vector3(0, 0, 0)
	for appointment in appointments:
		var dateRange = Vector2(startDate, startDate + 7 - 1)
		if dateRange[0] < appointment.start: #why did i write this in the most confusing logic i could muster?
			dateRange[0] = appointment.start
		if dateRange[1] > appointment.end:
			dateRange[1] = appointment.end
		var weight = dateRange[1] - dateRange[0] + 1
		if weight > 7: #i literally cannot tell if this is necessary and i cba to check
			weight = 7
		appointment.weight = weight
		if weight == 6 and appointment.start - startDate == 1:
			heavyAppointments[0] += 1
		if weight == 5 and appointment.start - startDate == 2:
			heavyAppointments[1] += 1
		if weight == 5 and appointment.start - startDate == 1:
			heavyAppointments[2] += 1
	return heavyAppointments

class sortAppointments:
	static func sortByStartDate(a, b):
		if a.start <= b.start:
			return true
		return false
	
	static func sortByWeight(a, b):
		if a.weight > b.weight:
			return true
		return false
