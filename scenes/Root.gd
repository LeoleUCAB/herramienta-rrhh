extends Node2D

onready var yearCamera = $YearRoulette/Camera2D
onready var monthCamera = $MonthRoulette/Camera2D

onready var yearRoulette = $YearRoulette/ScrollContainer
onready var monthRoulette = $MonthRoulette/ScrollContainer

onready var dateFinder = $HUD/MainBanner/DateFinder

var pagination = {}
var appointmentList = []
var currentCam: int

var currentDate = {
	"year": 1951,
	"month": 1
}

const YEAR_CAM = 0
const MONTH_CAM = 1

func _ready():
	appointmentList = generateRandomAppointments()
	appointmentList.sort_custom(sortAppointments, "sortByStartDateObj")
#	printDates(appointmentList)
	paginate(appointmentList)
	
	yearCamera.connect("yearZoomed", self, "changeToMonth")
	yearRoulette.connect("updateHover", self, "updateHover")
	yearRoulette.connect("updateClick", dateFinder, "updateClick")
	yearRoulette.appointmentList = appointmentList
	yearRoulette.pagination = pagination
	
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
#	print(currentDate)
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
	var randomAppointments = []
	var rng = RandomNumberGenerator.new()
	var userList = [
		{
			"name": "Alan",
			"id": 1,
		},
		{
			"name": "Bea",
			"id": 2,
		},
		{
			"name": "Chris",
			"id": 3,
		},
		{
			"name": "Dylan",
			"id": 4,
		},
		{
			"name": "Earl",
			"id": 5,
		},
		{
			"name": "Frank",
			"id": 6
		}
	]
	for i in 20:
		rng.randomize()
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
			day += rng.randi_range(0, 28)
			if day > maxDays:
				day -= maxDays
				month += 1
				if month > 12:
					month -= 12
					year += 1
				
			end = Date.new(day, month, year)
			
		else:
			end = start
			hour.start = rng.randi_range(0, 24)
			hour.end = rng.randi_range(hour.start, 24)
			
		var user = userList[rng.randi_range(0, 4)]
		
		
		var newAppointment = {
			"start": start,
			"end": end,
			"hour": hour,
			"user": user,
			"weight": null,
			"level": null,
			"isItDaylong": isItDayLong
		}
		
		randomAppointments.append(newAppointment)
	return randomAppointments


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
	
func paginate(list):
	for index in range(list.size()):
		var item = list[index]
		var start = item.start.year()
		var end = item.end.year()
		for year in range(start, end + 1):
			if !pagination.has(start):
				pagination[start] = [index]
				continue
			pagination[start].append(index)
	
class sortAppointments:
	static func sortByStartDateObj(a, b):
		if a.start.year() < b.start.year():
			return true
		elif a.start.year() == b.start.year():
			if a.start.month() < b.start.month():
				return true
			elif a.start.month() == b.start.month():
				if a.start.day() <= b.start.day():
					return true
		return false
		
func printDates(list):
	for item in list:
		var day = item.start.day() as String if item.start.day() >= 10 else "0" + item.start.day() as String
		var month = item.start.month() as String if item.start.month() >= 10 else "0" + item.start.month() as String
		print(day + "/" + month + "/" + item.start.year() as String)
