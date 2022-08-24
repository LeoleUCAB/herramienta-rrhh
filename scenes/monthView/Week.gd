extends Control

var startDate = 0 setget setStartDate
var daysInMonth = 30 setget setDaysInMonth
var color = [Color("d9d9d9"), Color("bfbfbf")]
var dayList: Array
var appointmentList: Array = Array()
var highQuality = false setget setHighQuality
var highQualityDayList: Array
var month = 1 setget setMonth

onready var grid = $GridContainer

signal updateWeekHover(month)
signal updateWeekClick(clickValue)

export var dayScene: PackedScene
export var daySceneHQ: PackedScene


func _ready():
	var inverted: bool = false
	var appointments = setLevel()
				
	for i in 7:
		var newDay = dayScene.instance()
		newDay.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		var date = (startDate + 7 + i - 1) #startdate is week number within month times 7 minus the weekday, e.g. 0 for sunday. It's minus 1 because you start on sunday, not monday
		if date > daysInMonth:
			date -= daysInMonth
			if not inverted:
				invertColors()
				inverted = true
		newDay.setDate(date as String)
		newDay.setMonth(month + inverted as int)
		newDay.setColor(color[0] as Color)
		newDay.rect_min_size = Vector2(1100, 933)
		newDay.lastDay = false
		if i == 6:
			newDay.lastDay = true
		newDay.connect("updateDayHover", self, "updateDayHover")
		newDay.connect("updateDayClick", self, "updateDayClick")
		dayList.append(newDay)
		
		var newDayHQ = daySceneHQ.instance()
		newDayHQ.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		newDayHQ.rect_min_size = Vector2(1100, 933)
		newDayHQ.setColor(color[0] as Color)
		newDayHQ.setDate(date)
		newDayHQ.setMonth(month + inverted as int)
		newDayHQ.connect("updateDayHover", self, "updateDayHover")
		newDayHQ.connect("updateDayClick", self, "updateDayClick")
		highQualityDayList.append(newDayHQ)
		
		setDayAppointments(newDay, newDayHQ, appointments)
		
		addDays()
	pass

func setStartDate(value):
	startDate = value

func setDaysInMonth(value):
	daysInMonth = value
	
func setHighQuality(value):
	highQuality = value
	addDays()
	
func invertColors():
	color.invert()
	
func addAppointments(value):
	appointmentList = []
	appointmentList.append_array(value)
	var appointments = setLevel()
	for i in dayList.size():
		var day = dayList[i]
		var HQDay = highQualityDayList[i]
		setDayAppointments(day, HQDay, appointments)
		
func setWeight(appointments, startDate):
	for appointment in appointments:
		var dateRange = Vector2(startDate, startDate + 7 - 1)
		if appointment.isItDaylong:
			if dateRange[0] < appointment.start.day(): #why did i write this in the most confusing logic i could muster?
				dateRange[0] = appointment.start.day()
			if dateRange[1] > appointment.end.day():
				dateRange[1] = appointment.end.day()
			var weight = dateRange[1] - dateRange[0] + 1
			if weight > 7: #i literally cannot tell if this is necessary and i cba to check
				weight = 7
			appointment.weight = weight
		else:
			appointment.weight = 1

class sortAppointments:
	static func sortByStartDate(a, b):
		if a.start.day() <= b.start.day():
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
	
func addDays():
	if grid != null:
		delete_children(grid)
		if highQuality:
			for day in highQualityDayList:
				grid.add_child(day)
		else:
			for day in dayList:
				grid.add_child(day)
			
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		
func setMonth(value):
	month = value
	
func setLevel():
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
	return appointments
		
func setDayAppointments(day, HQDay, appointments):
	day.clearAppointments()
	HQDay.clearAppointments()
	var date = day.date as int
	var sortedAppointments = Array()
	for appointment in appointments: # appointment: { start: int, end: int, color: Color, level: int, weight: int }
		if appointment.start.day() <= date and appointment.end.day() >= date:
			sortedAppointments.append(appointment)
	sortedAppointments.sort_custom(sortAppointments, "sortByLevel")
	var currentLevel = 0
	for j in sortedAppointments.size():
		var appointment = sortedAppointments[j]
		if appointment.level != j:
			day.addPlaceholderAppointment(appointment.level - currentLevel)
		day.addAppointmentList(sortedAppointments[j])
		currentLevel = appointment.level + 1
	day.addAppointments()
	HQDay.addAppointmentList(sortedAppointments)
	HQDay.setAppointments()

func updateDayHover(value):
	emit_signal("updateWeekHover", value)
	pass
	
func updateDayClick(value):
	emit_signal("updateWeekClick", value)
	pass

