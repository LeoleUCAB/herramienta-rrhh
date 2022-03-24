extends Node2D

onready var scrollContainer = $ScrollContainer
onready var vBoxContainer = $ScrollContainer/VBoxContainer
export var yearScene: PackedScene
export var loadingPlaceholderScene: PackedScene

var newYearList: Array
var placeholderList: Array

const RANGE = 5
const MAX_SIZE = 100
const ITEM_HEIGHT = 23000
const ITEM_WIDTH = 35850

func _ready():
	for i in range(MAX_SIZE):
		var placeholder = loadingPlaceholderScene.instance()
		placeholder.setYear(1950 + i)
		placeholder.rect_min_size = Vector2(ITEM_WIDTH, ITEM_HEIGHT)
		placeholder.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		placeholderList.append(placeholder)
		
		var newYear = yearScene.instance()
		newYear.setYear(1950 + i)
		newYear.rect_min_size = Vector2(ITEM_WIDTH, ITEM_HEIGHT)
		newYear.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		newYearList.append(newYear)
	
	for item in placeholderList:
		vBoxContainer.add_child(item)
		
	yield(get_tree(), "idle_frame") #wait one frame to set scroll, it just works
	
	scrollContainer.set_v_scroll(ITEM_HEIGHT*(2022-1950))
	_on_scroll_ended()
	pass

func _on_scroll_ended():
	var currentVPos = scrollContainer.get_v_scroll()
	var lowerLimit = currentVPos / ITEM_HEIGHT - (RANGE / 2)
	lowerLimit = 0 if lowerLimit < 0 else lowerLimit
	var higherLimit = lowerLimit + RANGE if lowerLimit + RANGE < MAX_SIZE else MAX_SIZE
	
	var scrollList = Array() + placeholderList
	for i in range(lowerLimit, higherLimit):
		scrollList.remove(i)
		scrollList.insert(i, newYearList[i])
	
	delete_children(vBoxContainer)
	for item in scrollList:
		vBoxContainer.add_child(item)
	prints("ended", lowerLimit, higherLimit, currentVPos / ITEM_HEIGHT)
	pass
	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
