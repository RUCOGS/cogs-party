extends CharacterBody2D

@export var speed: float = 30000.0

var controller_id: int = 0

func _physics_process(delta):
	if controller_id != -1:
		var direction = Input.get_vector(
			"control_left%s" % [controller_id],
			"control_right%s" % [controller_id],
			"control_up%s" % [controller_id],
			"control_down%s" % [controller_id]
		)
		
		velocity = direction * speed * delta # Multiplies direction by speed and delta time
		move_and_slide() # Built-in Godot movement function


func update_color(color: Color):
	$Sprite2D.modulate = color
