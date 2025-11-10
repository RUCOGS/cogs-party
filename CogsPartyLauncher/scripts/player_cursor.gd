extends CharacterBody2D

@export var speed: float = 30000.0
@export var player_name_label: Label

# unlinked cursors have an ID of -1
var controller_id: int = 0


func construct(cursor_position: Vector2, id: int):
	position = cursor_position
	controller_id = id


func _physics_process(delta):
	if controller_id != -1:
		var direction = Input.get_vector(
			"left%s" % [controller_id],
			"right%s" % [controller_id],
			"up%s" % [controller_id],
			"down%s" % [controller_id]
		)
		
		velocity = direction * speed * delta
		move_and_slide()


func _input(event: InputEvent) -> void:
	if controller_id != -1:
		if event.is_action_pressed("select%s" % [controller_id]):
			_simulate_mouse_click()


func _simulate_mouse_click():
	var click_pos = get_viewport().get_screen_transform() * position
	
	var press = InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.position = click_pos
	press.pressed = true
	Input.parse_input_event(press)

	var release = InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.position = click_pos
	release.pressed = false
	Input.parse_input_event(release)


func update_player_label(player_number: int):
	player_name_label.text = "P%d" % player_number


func update_color(color: Color):
	$Sprite2D.modulate = color
