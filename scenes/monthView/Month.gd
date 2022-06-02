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

const monthArray = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]


func _ready():
	generateRandomAppointments()
	var invertedColors: bool = false
	if month % 2:
		monthRect.color = Color("bfbfbf")
		invertedColors = true
	for i in weeks:
		var newWeek = weekScene.instance()
		newWeek.setDaysInMonth(daysInMonth)
		newWeek.setHighQuality(highQuality)
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
		monthName.text = verticalString(monthArray[month])
	for week in weekList:
		gridContainer.add_child(week)
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
	for i in range(rng.randi_range(0, 4)):
		var start = rng.randi_range(1, daysInMonth)
		var end = rng.randi_range(start, daysInMonth)
		var color = colorList[i]
		var newAppointment = {
			"start": start,
			"end": end,
			"color": color,
			"weight": null,
			"level": null
		}
		appointmentList.append(newAppointment)
	var debugAppointment = [
		{
			"start": 8,
			"end": 8,
			"color": colorList[0],
			"weight": null,
			"level": null
		},
		{
			"start": 7,
			"end": 8,
			"color": colorList[1],
			"weight": null,
			"level": null
		},
		{
			"start": 6,
			"end": 8,
			"color": colorList[2],
			"weight": null,
			"level": null
		},
		{
			"start": 5,
			"end": 8,
			"color": colorList[3],
			"weight": null,
			"level": null
		},
		{
			"start": 4,
			"end": 8,
			"color": colorList[4],
			"weight": null,
			"level": null
		},
		{
			"start": 3,
			"end": 8,
			"color": colorList[5],
			"weight": null,
			"level": null
		}
	]
	appointmentList.append_array(debugAppointment)

func verticalString(string):
	var verticalString: String = ""
	for c in string:
		verticalString += c + "\n"
	verticalString.erase(verticalString.length() - 1, 1)
	return verticalString
