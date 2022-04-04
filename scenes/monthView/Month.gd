extends GridContainer


export var weekScene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 6:
		add_child(weekScene.instance())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
