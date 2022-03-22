extends Control

onready var grid = $MonthGrid
onready var yearNumber = $YearNumber

export var monthScene: PackedScene

var year: int = 1900 setget setYear

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
		grid.add_child(newMonth)
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

