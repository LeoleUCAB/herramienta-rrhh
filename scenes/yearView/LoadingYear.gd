extends Control

onready var yearNumber = $YearNumber

var year: int = 1900 setget setYear

func _ready():
	yearNumber.text = year as String

func setYear(value):
	year = value
