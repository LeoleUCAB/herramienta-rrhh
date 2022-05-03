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
	setLevels(appointmentList)
	print(appointmentList)
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
		if not dayAppointments.empty():
			dayAppointments.sort_custom(sortAppointments, "sortByLevel")
			print(dayAppointments)
			var previousLevel = -1
			for j in dayAppointments.size():
				if previousLevel + 1 != dayAppointments[j].level:
					newDay.addPlaceholderAppointment(dayAppointments[j].level - (previousLevel + 1))
				newDay.addAppointment(dayAppointments[j])
				previousLevel = dayAppointments[j].level
				pass
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
		
func setLevels(appointmentList):
	var maxLevel = 0
	for i in appointmentList.size():
		var currentAppointment = appointmentList[i]
		currentAppointment.level = 0
		var compareList = Array() + appointmentList
		compareList.remove(i)
		for j in range(i):
			var appointment = compareList[j]
			if (currentAppointment.start <= appointment.end or (currentAppointment.end >= appointment.start and not currentAppointment.end >= appointment.end)) and appointment.level <= currentAppointment.level:
				currentAppointment.level += 1
				if currentAppointment.level > maxLevel:
					maxLevel = currentAppointment.level
			pass
		pass
	return maxLevel

class sortAppointments:
	static func sortByStartDate(a, b):
		if a.start <= b.start:
			return true
		return false
	
	static func sortByLevel(a, b):
		if a.level < b.level:
			return true
		return false
