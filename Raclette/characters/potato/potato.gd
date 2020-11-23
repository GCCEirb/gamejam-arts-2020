extends KinematicBody2D

var _velocity: Vector2 = Vector2.ZERO
export var speed: Vector2 = Vector2(300.0, 300)
const FLOOR_NORMAL = Vector2.UP
#var gravity : = 0

func _ready() -> void:
	_velocity.x = -speed.x

func _physics_process(delta: float) -> void:
	if get_parent().potato_in_place :
		if is_on_wall():
			_velocity.x *= -1.0
		move_and_slide(_velocity, FLOOR_NORMAL)
