extends Node2D

onready var yearCamera = $YearRoulette/Camera2D
onready var monthCamera = $MonthRoulette/Camera2D

onready var yearRoulette = $YearRoulette/ScrollContainer
onready var monthRoulette = $MonthRoulette/ScrollContainer

func _ready():
	yearCamera.connect("yearZoomed", self, "changeToMonth")
	monthCamera.connect("monthZoomed", self, "changeToYear")
	yearRoulette.connect("updateHover", self, "updateHover")
	pass 

func changeToMonth(zoomValue):
	yearCamera.current = false
	monthCamera.current = true
	monthRoulette._on_scroll_ended()
	
func changeToYear(zoomValue):
	monthCamera.current = false
	yearCamera.current = true

func updateHover(value):
	print(value)
	monthRoulette.goToDate(value)
