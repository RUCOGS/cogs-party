extends CharacterBody2D

@export var speed: float = 1000.0

var controller_id: int = 0

func _physics_process(delta):
	var x_axis = Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_X)
	position.x += x_axis * speed * delta
	
	var y_axis = Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_Y)
	position.y += y_axis * speed * delta


func update_color(color: Color):
	$Sprite2D.modulate = color
