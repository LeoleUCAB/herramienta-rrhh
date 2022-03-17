extends Control

onready var grid = $MonthGrid

export var monthScene: PackedScene

func _ready():
	for i in range(12):
		var newMonth = monthScene.instance()
		var year = 2022 #this shouldn't be constant	
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
			"daysInMonth": getDaysInMonth(i+1, year)
		}
		newMonth.init(initDict)
		grid.add_child(newMonth)
	pass
	
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

