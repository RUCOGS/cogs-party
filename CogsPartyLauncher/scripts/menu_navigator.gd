extends Node
class_name MenuNavigator


@export var default_menu: String = "MainMenu"
@export var menus: Array[Control]


func load_menu(_name: String, data = null):
	for menu in menus:
		menu.visible = menu.name == _name
		if menu.visible and data != null and menu.has_method("_menu_loaded"):
			menu._menu_loaded(data)


func _ready():
	load_menu(default_menu)
