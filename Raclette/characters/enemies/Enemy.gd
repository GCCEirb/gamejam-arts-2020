extends KinematicBody2D

# squelette pour la mise en place d'ennemies
class_name Enemy

# member variables
export var speed = 10

func _ready() -> void :
	pass
	
func _destroy() -> void :
	pass

func _spawn(x, y):
	pass


func _process(delta: float) -> void:
	manage_action()
	
# gestion du comportement de l'ennemi
func manage_action():
	pass

