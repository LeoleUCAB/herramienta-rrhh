extends TextEdit

onready var calendarButton = $CalendarButton

var date = {
	"year": 1951,
	"month": 1
}

signal goToDate(date)

func _ready():
	calendarButton.connect("date_selected", self, "dateSelected")
	pass

func dateSelected(value, goTo: bool = true):
	var day = value.day() as int
	day = day as String if day >= 10 else "0" + day as String
	var month = value.month() as int
	date.month = month
	month = month as String if month >= 10 else "0" + month as String
	var year = value.year() as int
	date.year = year
	year = year as String
	
	text = " " + day + "/" + month + "/" + year
	
	if goTo:
		emit_signal("goToDate", date)

func updateClick(clickValue):
	var dateObj = Date.new(clickValue.day, clickValue.month, clickValue.year)
	dateSelected(dateObj, false)
