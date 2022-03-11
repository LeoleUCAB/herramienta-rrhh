extends Node2D

var date
var daysInMonth

export var dayScene: PackedScene

onready var grid = $ColorRect/GridContainer

const monthNames = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

func _ready():
	pass
	
func set_date(parentDate):
	date = parentDate
	var month = date.month
	var year = date.year
	var isLeapYear
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
		daysInMonth = 28 + isLeapYear
	else:
		daysInMonth = 31 - ((month - 1) % 7 % 2) #it just works don't worry about it: http://www.dispersiondesign.com/articles/time/number_of_days_in_a_month
	var offset = 3
	for i in range(daysInMonth + offset):
		var newDay = dayScene.instance()
		grid.add_child(newDay)
		newDay.setDayNumber(i+1-offset)
		if(i < offset):
			newDay.modulate = Color(1, 1, 1, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
