extends Node2D

onready var yearCamera = $YearRoulette/Camera2D
onready var monthCamera = $MonthRoulette/Camera2D

onready var yearRoulette = $YearRoulette/ScrollContainer
onready var monthRoulette = $MonthRoulette/ScrollContainer

onready var dateFinder = $HUD/MainBanner/DateFinder

var appointmentDict = {}
var currentCam: int

var currentDate = {
	"year": 1951,
	"month": 1
}

const YEAR_CAM = 0
const MONTH_CAM = 1

func _ready():
	generateRandomAppointments()
	
	yearCamera.connect("yearZoomed", self, "changeToMonth")
	yearRoulette.connect("updateHover", self, "updateHover")
	yearRoulette.connect("updateClick", dateFinder, "updateClick")
	
	monthCamera.connect("monthZoomed", self, "changeToYear")
	monthRoulette.connect("updateHover", self, "updateHover")
	monthRoulette.connect("updateClick", dateFinder, "updateClick")
	
	dateFinder.connect("goToDate", self, "goToDate")
	currentCam = YEAR_CAM
	
	
	pass 

func changeToMonth(zoomValue):
	monthRoulette.goToDate(currentDate)
	monthRoulette._on_scroll_ended()
	yearCamera.current = false
	monthCamera.current = true
	currentCam = MONTH_CAM
	
func changeToYear(zoomValue):
	yearRoulette.goToDate(currentDate)
	yearRoulette._on_scroll_ended()
	yearCamera.moveCamera(currentDate)
	monthCamera.current = false
	yearCamera.current = true
	currentCam = YEAR_CAM

func updateHover(value):
	print(currentDate)
	currentDate = value
	
func goToDate(date):
	if currentCam == YEAR_CAM:
		yearRoulette.goToDate(date)
		yearRoulette._on_scroll_ended()
		yearCamera.moveCamera(date)
	elif currentCam == MONTH_CAM:
		monthRoulette.goToDate(date)
		monthRoulette._on_scroll_ended()

func generateRandomAppointments():
	var appointmentList = []
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var colorList = [
		Color.yellow,
		Color.red,
		Color.blue,
		Color.orange,
		Color.green,
		Color.purple
	]
	var newAppointment = {
		"start": 0,
		"end": 0,
		"hour": null,
		"color": null,
		"weight": null,
		"level": null,
		"isItDaylong": false
	}
	for i in 20:
		var isItDayLong: bool = rng.randi() % 2
		
		var year = 2022
		var month = rng.randi_range(1, 12)
		var maxDays = getDaysInMonth(month, year)
		var day = rng.randi_range(1, maxDays)
		var start = Date.new(day, month, year)
		
		var end
		var hour = {
			"start": 0,
			"end": 0
		}
		
		if isItDayLong:
			day += rng.randi_range(0, 30)
			if day > maxDays:
				day -= maxDays
				month += 1
				
			end = Date.new(day, month, year)
			
		else:
			end = start
			hour.start = rng.randi_range(0, 24)
			hour.end = rng.randi_range(hour.start, 24)
			
		var color = colorList[rng.randi_range(0,5)]
		
		newAppointment = {
			"start": start,
			"end": end,
			"hour": hour,
			"color": color,
			"isItDaylong": isItDayLong,
			"weight": null,
			"level": null
		}	
		if appointmentDict.has(year):
			appointmentDict[year].append(newAppointment)
		else:
			appointmentDict[year] = [newAppointment]
			


func getDaysInMonth(month, year):
	var isLeapYear: bool
	var daysInMonth: int
	if (year % 4 == 0):
		if (year % 100 == 0):
			if(year % 400 == 0):
				isLeapYear = true
			else:
				isLeapYear = false
		else:
			isLeapYear = true
	else:
		isLeapYear = false
	if month == 2:
		daysInMonth = 28 + isLeapYear as int
	else:
		daysInMonth = 31 - ((month - 1) % 7 % 2) #it just works don't worry about it: http://www.dispersiondesign.com/articles/time/number_of_days_in_a_month
	return daysInMonth
