extends Control


export var weekScene: PackedScene

onready var gridContainer = $MonthRect/GridContainer

var year: int = 1900 setget setYear
var month: int = 1 setget setMonth #January is 1

func _ready():
	var daysInMonth = getDaysInMonth()
	
	var newMonthDate: Dictionary = {
		"year": year,
		"month": month,
		"day": 1,
		"hour": 12,
		"minute": 0,
		"second": 0
	}
	var weekStart = OS.get_datetime_from_unix_time(OS.get_unix_time_from_datetime(newMonthDate)).weekday
	var maxWeek = (weekStart + daysInMonth) / 7
	for i in maxWeek:
		gridContainer.add_child(weekScene.instance())
	pass
	
func getDaysInMonth():
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
	
func setMonth(value):
	month = value
