extends CharacterBody2D

@export var speed: float = 30000.0
@export var player_name_label: Label

# unlinked cursors have an ID of -1
var controller_id: int = 0

# reference to a matching cursor used to navigate the file dialog from the edit button on the main menu
var file_dialog_cursor: CharacterBody2D


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
		
		var rs_strength = abs(Input.get_axis("scroll_down", "scroll_up"))
		
		velocity = direction * speed * delta
		move_and_slide()
		
		if Input.is_action_pressed("scroll_up%s" % [controller_id]):
			_simulate_scroll(MOUSE_BUTTON_WHEEL_UP, rs_strength)
		elif Input.is_action_pressed("scroll_down%s" % [controller_id]):
			_simulate_scroll(MOUSE_BUTTON_WHEEL_DOWN, rs_strength)
		else:
			_simulate_stop_scroll(MOUSE_BUTTON_WHEEL_UP)
			_simulate_stop_scroll(MOUSE_BUTTON_WHEEL_DOWN)


func get_id() -> int:
	return controller_id


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


func _simulate_scroll(direction: MouseButton, strength: float):
	var mouse_pos = get_viewport().get_screen_transform() * position
	
	var scroll = InputEventMouseButton.new()
	scroll.button_index = direction
	scroll.position = mouse_pos
	scroll.factor = strength
	scroll.pressed = true
	Input.parse_input_event(scroll)


func _simulate_stop_scroll(direction: MouseButton):
	var scroll = InputEventMouseButton.new()
	scroll.button_index = direction
	scroll.pressed = false
	Input.parse_input_event(scroll)


func update_player_label(player_number: int):
	player_name_label.text = "P%d" % player_number
	if file_dialog_cursor != null:
		file_dialog_cursor.update_player_label(player_number)


func update_color(color: Color):
	$Sprite2D.modulate = color
	if file_dialog_cursor != null:
		file_dialog_cursor.update_color(color)


func update_id(id: int):
	controller_id = id
	if file_dialog_cursor != null:
		file_dialog_cursor.update_id(id)
