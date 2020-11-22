tool
extends Control

onready var _anim: = $AnimationPlayer
onready var _hider = $CanvasLayer/Hider

export(String, FILE) var title_screen_path: String
onready var _title_screen: = load(title_screen_path)


func _ready() -> void:
	_anim.play("fade_in")
	yield(_anim, "animation_finished")
	_hider.queue_free()


func _on_TitleScreen_pressed() -> void:
	get_tree().change_scene_to(_title_screen)


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _get_configuration_warning() -> String:
	if not title_screen_path:
		return ErrorMessages.get_message("The title screen path", ErrorMessages.Warning.SHOULD_NOT_BE_EMPTY)
	return ""

