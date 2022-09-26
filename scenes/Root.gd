extends Node2D

const NO_MENU = -1
const YEAR_CAM = 0
const MONTH_CAM = 1
const FILTER_MENU = 2
const SETTING_MENU = 3
const COLOR_INDEX_DEFAULT = 0
const COLOR_INDEX_COLORBLIND_WONG = 1
const COLOR_INDEX_COLORBLIND_TOLB = 2

onready var yearCamera = $YearRoulette/Camera2D
onready var monthCamera = $MonthRoulette/Camera2D

onready var yearRoulette = $YearRoulette/ScrollContainer
onready var monthRoulette = $MonthRoulette/ScrollContainer

onready var dateFinder = $HUD/MainBanner/DateFinder

onready var filter = $HUD/FilterMenu
onready var settings = $HUD/SettingsMenu

var pagination = {}
var appointmentList = []
var currentCam: int
var userList = []
var filterDict = {}
var currentMenu = NO_MENU
var currentColor = COLOR_INDEX_DEFAULT

var defaultColorList = [
	Color.red,
	Color.blue,
	Color.yellow,
	Color.green,
	Color.orange,
	Color.purple
]

var wongColorList = [
	Color(0, 0, 0, 1),
	Color(230.0/255, 159.0/255, 0, 1),
	Color(86.0/255, 180.0/255, 233.0/255, 1),
	Color(0, 158.0/255, 115.0/255, 1),
	Color(240.0/255, 228.0/255, 66.0/255, 1),
	Color(0, 114.0/255, 178.0/255, 1),
	Color(213.0/255, 94.0/255, 0, 1),
	Color(204.0/255, 121.0/255, 167.0/255, 1)
]

var tolBrightColorList = [
	Color(68.0/255, 119.0/255, 170.0/255, 1),
	Color(102.0/255, 204.0/255, 238.0/255, 1),
	Color(34.0/255, 136.0/255, 51.0/255, 1),
	Color(204.0/255, 187.0/255, 68.0/255, 1),
	Color(238.0/255, 102.0/255, 119.0/255, 1),
	Color(170.0/255, 51.0/255, 119.0/255, 1)
]

var currentDate = {
	"year": 1951,
	"month": 1
}


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
	monthRoulette.appointmentList = appointmentList
	monthRoulette.pagination = pagination
	
	filter.connect("checkBoxToggle", self, "checkBoxToggle")
	filter.userList = userList
	
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
	var defaultUserList = [
		{
			"name": "Alan",
			"id": 1,
			"color": null
		},
		{
			"name": "Bea",
			"id": 2,
			"color": null
		},
		{
			"name": "Chris",
			"id": 3,
			"color": null
		},
		{
			"name": "Dylan",
			"id": 4,
			"color": null
		},
		{
			"name": "Earl",
			"id": 5,
			"color": null
		},
		{
			"name": "Frank",
			"id": 6,
			"color": null
		}
	]
	userList = defaultUserList
	setColors(userList)
	for userItem in defaultUserList:
		filterDict[userItem.id] = true
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
		var color = setAppointmentColor(user)
		
		
		var newAppointment = {
			"start": start,
			"end": end,
			"hour": hour,
			"user": user,
			"color": color,
			"weight": null,
			"level": null,
			"isItDaylong": isItDayLong
		}
		
		randomAppointments.append(newAppointment)
	return randomAppointments

func setColors(userList):
	var currentColorList = getCurrentColorList()
	for user in userList:
		user.color = currentColorList[user.id % currentColorList.size()]
			
func setAppointmentColor(user):
	var currentColorList = getCurrentColorList()
	return currentColorList[user.id % currentColorList.size()]

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
	pagination = {}
	for index in range(list.size()):
		var item = list[index]
		if !filterDict[item.user.id]:
			continue
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
		
func checkBoxToggle(toggleValue):
	filterDict[toggleValue.id] = toggleValue.state
	paginate(appointmentList)
	yearRoulette.setPagination(pagination, false)
	monthRoulette.setPagination(pagination)


func _on_FilterButton_pressed():
	match currentMenu:
		NO_MENU:
			currentMenu = FILTER_MENU
			filter.changeState(true)
		FILTER_MENU:
			currentMenu = NO_MENU
			filter.changeState(false)
		SETTING_MENU:
			currentMenu = FILTER_MENU
			filter.changeState(true)
			settings.changeState(false)


func _on_SettingsButton_pressed():
	match currentMenu:
		NO_MENU:
			currentMenu = SETTING_MENU
			settings.changeState(true)
		SETTING_MENU:
			currentMenu = NO_MENU
			settings.changeState(false)
		FILTER_MENU:
			currentMenu = SETTING_MENU
			settings.changeState(true)
			filter.changeState(false)

func getCurrentColorList():
	match currentColor:
		COLOR_INDEX_DEFAULT:
			return defaultColorList
		COLOR_INDEX_COLORBLIND_WONG:
			return wongColorList
		COLOR_INDEX_COLORBLIND_TOLB:
			return tolBrightColorList
		_:
			return defaultColorList

func _changeAppColor(index):
	currentColor = index
	setColors(userList)
	for appointment in appointmentList:
		appointment.color = setAppointmentColor(appointment.user)
	
	filter.deleteUserList()
	filter.setUserList(userList)
	
	paginate(appointmentList)
	yearRoulette.setPagination(pagination, false)
	monthRoulette.setPagination(pagination)
