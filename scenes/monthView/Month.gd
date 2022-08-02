extends Control


export var weekScene: PackedScene

onready var gridContainer = $MonthRect/GridContainer
onready var monthName = $MonthRect/MonthName
onready var monthRect = $MonthRect

var weekStart: int = 0 setget setWeekStart
var weeks: int = 4 setget setWeeks
var daysInMonth: int = 30 setget setDaysInMonth
var month: int = 0 setget setMonth #January is 0
var appointmentList: Array = Array()
var highQuality = false setget setHighQuality
var weekList: Array
var year: int = 1950 setget setYear

const monthArray = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

signal updateMonthHover(hoverValue)
signal updateMonthClick(clickValue)

func _ready():
	generateRandomAppointments()
	var invertedColors: bool = false
	if month % 2:
		monthRect.color = Color("bfbfbf")
		invertedColors = true
	for i in weeks:
		var newWeek = weekScene.instance()
		newWeek.setDaysInMonth(daysInMonth)
		newWeek.setMonth(month + 1)
		newWeek.setHighQuality(highQuality)
		newWeek.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		newWeek.connect("updateWeekHover", self, "updateWeekHover")
		newWeek.connect("updateWeekClick", self, "updateWeekClick")
		var startDate = i * 7 - weekStart + 1
		var appointmentRange: Vector2 = Vector2(startDate - 1 + 7, startDate - 1 + 14)
		newWeek.setStartDate(startDate)
		if invertedColors:
			newWeek.invertColors()
		for appointment in appointmentList:
			if appointment.start >= appointmentRange[0] and appointment.start <= appointmentRange[1]: # starts this week
				newWeek.addAppointment(appointment)
			elif appointment.end >= appointmentRange[0] and appointment.end <= appointmentRange[1]: # started in another week but ends this week
				newWeek.addAppointment(appointment)
			elif appointment.start <= appointmentRange[0] and appointment.end >= appointmentRange[1]: # started in another week and ends later still
				newWeek.addAppointment(appointment)
		weekList.append(newWeek)
		
	for week in weekList:
		gridContainer.add_child(week)
	
	monthName.text = verticalString(monthArray[month])
	pass

func setWeekStart(value):
	weekStart = value
	
func setWeeks(value):
	weeks = value

func setDaysInMonth(value):
	daysInMonth = value

func setMonth(value):
	month = value
	
func setHighQuality(value):
	highQuality = value
	for week in weekList:
		week.setHighQuality(highQuality)

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
			start = rng.randi_range(1, daysInMonth)
			end = rng.randi_range(start, daysInMonth)
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
	var debugAppointment = [
		{
			"start": 8,
			"end": 8,
			"color": colorList[0],
			"weight": null,
			"level": null,
			"isItDaylong": true
		},
		{
			"start": 7,
			"end": 8,
			"color": colorList[1],
			"weight": null,
			"level": null,
			"isItDaylong": true
		},
		{
			"start": 6,
			"end": 8,
			"color": colorList[2],
			"weight": null,
			"level": null,
			"isItDaylong": true
		},
		{
			"start": 5,
			"end": 8,
			"color": colorList[3],
			"weight": null,
			"level": null,
			"isItDaylong": true
		},
		{
			"start": 4,
			"end": 8,
			"color": colorList[4],
			"weight": null,
			"level": null,
			"isItDaylong": true
		},
		{
			"start": 3,
			"end": 8,
			"color": colorList[5],
			"weight": null,
			"level": null,
			"isItDaylong": true
		}
	]
	appointmentList.append_array(debugAppointment)

func verticalString(string):
	var verticalString: String = ""
	for c in string:
		verticalString += c + "\n"
	verticalString.erase(verticalString.length() - 1, 1)
	return verticalString

func setYear(value):
	year = value

func updateWeekHover(value):
	var hoverValue = {
		"year": year + 1,
		"month": value
	}
	emit_signal("updateMonthHover", hoverValue)
	pass

func updateWeekClick(value):
	var clickValue = {
		"year": year + 1,
		"month": value.month,
		"day": value.day
	}
	emit_signal("updateMonthClick", clickValue)
