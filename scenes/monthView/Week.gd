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
	setWeight(appointmentList, startDate + 7 - 1)
	appointmentList.sort_custom(sortAppointments, "sortByWeight")
	
	var appointments = Array()
	for sortedAppointment in appointmentList:
			sortedAppointment.level = 0
			if appointments.size() == 0:
				appointments.append(sortedAppointment)
			else:
				appointments.sort_custom(sortAppointments, "sortByLevel")
				for appointment in appointments:
					if sortedAppointment.level == appointment.level:
						var start = sortedAppointment.start
						var end = sortedAppointment.end
						if (start >= appointment.start and start <= appointment.end) or (end >= appointment.start and end <= appointment.end):
							sortedAppointment.level += 1
							
				appointments.append(sortedAppointment)
				
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
		var sortedAppointments = Array()
		for appointment in appointments: # appointment: { start: int, end: int, color: Color, level: int, weight: int }
			if appointment.start <= date and appointment.end >= date:
				sortedAppointments.append(appointment)
		sortedAppointments.sort_custom(sortAppointments, "sortByLevel")
		var currentLevel = 0
		for j in sortedAppointments.size():
			var appointment = sortedAppointments[j]
			if appointment.level != j:
				newDay.addPlaceholderAppointment(appointment.level - currentLevel)
			newDay.addAppointment(sortedAppointments[j])
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

class sortAppointments:
	static func sortByStartDate(a, b):
		if a.start <= b.start:
			return true
		return false
	
	static func sortByWeight(a, b):
		if a.weight > b.weight:
			return true
		elif a.weight == b.weight:
			return sortByStartDate(a, b)
		return false
		
	static func sortByLevel(a, b):
		if a.level < b.level:
			return true
		if a.level == b.level:
			return sortByStartDate(a, b)
		return false
