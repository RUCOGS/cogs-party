extends Node2D


@export var default_resolution: Vector2


var left_border: StaticBody2D
var right_border: StaticBody2D
var top_border : StaticBody2D
var bottom_border: StaticBody2D
var size: Vector2 # current resolution


func _ready() -> void:
	left_border = $LeftBorder
	right_border = $RightBorder
	top_border = $TopBorder
	bottom_border = $BottomBorder
	size = get_viewport_rect().size
	_update_borders()
	_update_file_dialog_borders()


# adjusts the position of the world borders depending on the viewport resolution
func _update_borders():
	left_border.position = Vector2(0, size.y / 2)
	right_border.position = Vector2(size.x, size.y /2)
	top_border.position = Vector2(size.x / 2, 0)
	bottom_border.position = Vector2(size.x / 2, size.y)


# adjusts the position of the world borders for the FileDialog 
# pop-up menu for editing games folder path. 
func _update_file_dialog_borders():
	if size != default_resolution:
		%LeftBorderDialog.position = Vector2(0, size.y / 2)
		%RightBorderDialog.position = Vector2(size.x, size.y /2)
		%TopBorderDialog.position = Vector2(size.x / 2, 0)
		%BottomBorderDialog.position = Vector2(size.x / 2, size.y)
	
