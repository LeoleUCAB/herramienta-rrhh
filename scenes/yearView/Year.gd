extends Control

onready var grid = $MonthGrid
onready var yearNumber = $YearNumber

export var monthScene: PackedScene

var year: int = 1900 setget setYear
var monthList = []
var appointmentList = []
var pagination = {}
var hoverValue = {
	"year": year,
	"month": -1
}

var clickValue = {
	"year": year,
	"month": -1,
	"day": -1
}

signal updateYearHover(hoverValue)
signal updateYearClick(clickValue)

func _ready():
	yearNumber.text = year as String
	for i in range(12):
		var newMonth = monthScene.instance()
		var newMonthDate: Dictionary = {
			"year": year,
			"month": i + 1,
			"day": 1,
			"hour": 12,
			"minute": 0,
			"second": 0
		}
		var weekStart = OS.get_datetime_from_unix_time(OS.get_unix_time_from_datetime(newMonthDate)).weekday
		var initDict: Dictionary = {
			"year": year,
			"month": i + 1,
			"weekStart": weekStart,
			"daysInMonth": getDaysInMonth(i+1)
		}
		newMonth.init(initDict)
		newMonth.connect("monthHover", self, "updateMonthHover")
		newMonth.connect("monthClick", self, "updateMonthClick")
		monthList.append(newMonth)
		grid.add_child(newMonth)
	setPagination()
	pass
	
func getDaysInMonth(month):
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
	
func setYear(value):
	year = value
	
func updateMonthHover(month):
	if hoverValue.month != month:
		hoverValue.month = month
		hoverValue.year = year
		emit_signal("updateYearHover", hoverValue)

func updateMonthClick(currentClickValue):
	if clickValue.day != currentClickValue.day:
		clickValue.day = currentClickValue.day
		clickValue.month = currentClickValue.month
		clickValue.year = year
		emit_signal("updateYearClick", clickValue)
		
func setPagination():
	for monthItem in monthList:
		var monthPagination = {}
		var month = monthItem.month
		if pagination.has(month):
			for page in pagination[month]:
				monthItem.appointmentList.append(appointmentList[page])
				var index = monthItem.appointmentList.size() - 1
				for day in range(appointmentList[page].start.day(), appointmentList[page].end.day() + 1):
					if !monthPagination.has(day):
						monthPagination[day] = [index]
						continue
					monthPagination[day].append(index)
		monthItem.pagination = monthPagination
