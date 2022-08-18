extends Control


onready var nameLabel = $Name
onready var checkbox = $CheckBox
onready var colorBox = $ColorRect

var userName: String = ""
var id: int = 0
var userColor: Color = Color.white

signal checkBoxToggle(toggleValue)


# Called when the node enters the scene tree for the first time.
func _ready():
	nameLabel.text = userName
	colorBox.color = userColor


func setName(name):
	userName = name
	
func setColor(color):
	userColor = color


func _on_CheckBox_toggled(button_pressed):
	emit_signal("checkBoxToggle", {"id": id, "state": button_pressed})
	pass # Replace with function body.
