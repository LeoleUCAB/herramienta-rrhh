extends Control

var appointmentList: Array = Array()
var appointmentRects: Array = Array()
var maxColumns = 1
var color: Color = Color.white
var date: int = 1 setget setDate
var month: int = 1 setget setMonth

onready var hours = [
	$Hours/AllDay/Content/GridContainer,
	$Hours/'0h'/Content/GridContainer,
	$Hours/'8h'/Content/GridContainer,
	$Hours/'9h'/Content/GridContainer,
	$Hours/'10h'/Content/GridContainer,
	$Hours/'11h'/Content/GridContainer,
	$Hours/'12h'/Content/GridContainer,
	$Hours/'13h'/Content/GridContainer,
	$Hours/'14h'/Content/GridContainer,
	$Hours/'15h'/Content/GridContainer,
	$Hours/'16h'/Content/GridContainer,
	$Hours/'17h'/Content/GridContainer,
	$Hours/'24h'/Content/GridContainer,
]
onready var background = $Background
const GRID_WIDTH = 945
const GRID_HEIGHT = 67
const GRID_MARGIN = 5
const GRID_H_SEPARATION = 4
const HOUR_HEIGHT = 72

signal updateDayHover(month)
signal updateDayClick(clickValue)

# Called when the node enters the scene tree for the first time.
func _ready():
	background.color = color
	
#	generateRandomAppointments()
	setWeight()
	appointmentList.sort_custom(sortAppointments, "sortByWeight")
	setLevel()
	appointmentList.sort_custom(sortAppointments, "sortByLevel")
	setAppointments()
	pass

func setColor(value):
	color = value

func setWeight():
	for appointment in appointmentList:
		var weight = 0
		if appointment.isItDaylong:
			weight = 1
		else:
			var start = appointment.hour.start
			var end = appointment.hour.end
			if start < 8:
				weight += 1
				start = 8
			if end > 17:
				weight += 1
				end = 17
			weight += end - start + 1
			if weight < 0:
				weight = 0
		appointment.weight = weight

func setLevel():
	var sortedAppointments = Array()
	var maxLevel = 0
	var daylongAppointments = 0
	for i in appointmentList.size():
		var appointment = appointmentList[i]
		if appointment.isItDaylong:
			appointment.level = daylongAppointments
			daylongAppointments += 1
			continue
		else:
			appointment.level = 0
			if sortedAppointments.size() == 0:
				sortedAppointments.append(appointment)
				continue
			sortedAppointments.sort_custom(sortAppointments, "sortByLevel")
			for sortedAppointment in sortedAppointments:
				if appointment.level == sortedAppointment.level:
					var start = sortedAppointment.hour.start
					var end = sortedAppointment.hour.end
					if (appointment.hour.start >= start and appointment.hour.start <= end) or (appointment.hour.end >= start and appointment.hour.end <= end):
						appointment.level += 1
						if appointment.level > maxLevel:
							maxLevel = appointment.level
			sortedAppointments.append(appointment)
	
	maxColumns = maxLevel + 1 if maxLevel >= daylongAppointments else daylongAppointments
		

func addAppointment(hour, appointments, currentTime):
	var rectWidth = ((GRID_WIDTH - GRID_MARGIN) / maxColumns) - (GRID_H_SEPARATION)
	var rectHeight = GRID_HEIGHT - GRID_MARGIN
	var rectSize = Vector2(rectWidth, rectHeight)
	hour.columns = maxColumns
	var currentLevel = 0
	for i in appointments.size():
		var appointment = appointments[i]
		if (i + currentLevel) < appointment.level:
			for j in (appointment.level - (i + currentLevel)):
				var placeholder = ColorRect.new()
				placeholder.color = Color(1, 1, 1, 0)
				placeholder.rect_min_size = Vector2(rectWidth, rectHeight)
				placeholder.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
				hour.add_child(placeholder)
			currentLevel = appointment.level + 1
		var newAppointment = ColorRect.new()
		newAppointment.color = appointment.color
		if currentTime == appointment.hour.end:
			pass #LMAO IT DOESN'T WORK I SCREWED UP
		newAppointment.rect_min_size = rectSize
		newAppointment.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		hour.add_child(newAppointment)
		appointmentRects.append({"grid": hour, "obj": newAppointment})
	
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
	for i in range(rng.randi_range(0, 8)):
		var isItDayLong: bool = rng.randi() % 2
		var start: int
		var end: int
		if isItDayLong:
			start = rng.randi_range(1, 31)
			end = rng.randi_range(start, 31)
		else:
			start = rng.randi_range(0, 24)
			end = rng.randi_range(start, 24)
		var color = colorList[rng.randi_range(0, 5)]
		var newAppointment = {
			"start": start,
			"end": end,
			"color": color,
			"weight": null,
			"level": null,
			"isItDaylong": isItDayLong
		}
		appointmentList.append(newAppointment)

func addAppointmentList(valueList):
	appointmentList.append_array(valueList)
	
func setHourAppointments(i):
	var hour = hours[i]
	var currentTime = i + 6
	var hourAppointments = Array()
	if i == 0:
		for appointment in appointmentList:
			if appointment.isItDaylong:
				hourAppointments.append(appointment)
	else:
		for appointment in appointmentList:
			if !appointment.isItDaylong:
				if i == 1 && appointment.hour.start < 8:
					hourAppointments.append(appointment)
				elif i == hours.size() - 1 && appointment.hour.end > 17:
					hourAppointments.append(appointment)
				elif currentTime >= appointment.hour.start && currentTime <= appointment.hour.end:
					hourAppointments.append(appointment)
	if !hourAppointments.empty():
		addAppointment(hour, hourAppointments, currentTime)
		
func clearAppointments():
	appointmentList = []
	for rectObj in appointmentRects:
		rectObj.grid.remove_child(rectObj.obj)
		rectObj.obj.queue_free()
	appointmentRects = []
	
func setAppointments():
	if hours != null:
		for i in hours.size():
			setHourAppointments(i)

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

func setDate(value):
	date = value
	
func setMonth(value):
	month = value

func _on_mouse_entered():
	emit_signal("updateDayHover", month)
	pass # Replace with function body.


func _on_Control_gui_input(event):
	if event.get_class() == "InputEventMouseButton" and event.pressed == true:
		var currentDayClick = {
			"month": month,
			"day": date
		}
		emit_signal("updateDayClick", currentDayClick)
	pass # Replace with function body.
