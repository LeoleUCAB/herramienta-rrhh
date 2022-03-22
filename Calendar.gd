extends Node2D

onready var scrollContainer = $ScrollContainer
onready var vBoxContainer = $ScrollContainer/VBoxContainer
export var yearScene: PackedScene

var newYearList: Array
var placeholderList: Array

func _ready():
	for i in range(30):
		var placeholder = ColorRect.new()
		placeholder.rect_min_size = Vector2(35850, 23000)
		placeholder.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		placeholderList.append(placeholder)
		
		var newYear
		newYear = yearScene.instance()
		newYear.setYear(2000 + i)
		newYear.rect_min_size = Vector2(35850, 23000)
		newYear.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		newYearList.append(newYear)
	
	var scrollList = Array() + placeholderList
	scrollList.insert(5, newYearList[5])
	scrollList.insert(6, newYearList[6])
	scrollList.insert(7, newYearList[7])
	
	for item in scrollList:
		vBoxContainer.add_child(item)
		
	yield(get_tree(), "idle_frame") #wait one frame to set scroll, it just works
	scrollContainer.set_v_scroll(23000*6)
	pass

func _on_scroll_ended():
	var currentVPos = scrollContainer.get_v_scroll()
	var currentRange: Vector2 = Vector2(currentVPos / 23000 - 1, currentVPos / 23000 + 1)
	var scrollList = Array() + placeholderList
	for i in range(currentRange[0], currentRange[1] + 1):
		scrollList.insert(i, newYearList[i])
	
	delete_children(vBoxContainer)
	print(scrollList)
	for item in scrollList:
		vBoxContainer.add_child(item)
	prints("ended", currentRange)
	pass
	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
