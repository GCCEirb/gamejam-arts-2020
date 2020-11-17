tool
extends MarginContainer


export(String, FILE) var new_game_path: String
onready var _new_game_scene: = load(new_game_path)


func _on_Continue_pressed() -> void:
	pass # Replace with function body.


func _on_NewGame_pressed() -> void:
	if not _new_game_scene:
		return
	get_tree().change_scene_to(_new_game_scene)


func _on_Options_pressed() -> void:
	pass # Replace with function body.


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _get_configuration_warning() -> String:
	if not new_game_path:
		return "The new game scene path must not be empty"
	return ""
