extends Node2D

onready var yearCamera = $YearRoulette/Camera2D
onready var monthCamera = $MonthRoulette/Camera2D

onready var yearRoulette = $YearRoulette/ScrollContainer
onready var monthRoulette = $MonthRoulette/ScrollContainer

var currentDate = {
	"year": 1951,
	"month": 1
}

func _ready():
	yearCamera.connect("yearZoomed", self, "changeToMonth")
	monthCamera.connect("monthZoomed", self, "changeToYear")
	yearRoulette.connect("updateHover", self, "updateHover")
	monthRoulette.connect("updateHover", self, "updateHover")
	pass 

func changeToMonth(zoomValue):
	monthRoulette.goToDate(currentDate)
	monthRoulette._on_scroll_ended()
	yearCamera.current = false
	monthCamera.current = true
	
func changeToYear(zoomValue):
	yearRoulette.goToDate(currentDate)
	yearRoulette._on_scroll_ended()
	yearCamera.moveCamera(currentDate)
	monthCamera.current = false
	yearCamera.current = true

func updateHover(value):
	print(currentDate)
	currentDate = value
