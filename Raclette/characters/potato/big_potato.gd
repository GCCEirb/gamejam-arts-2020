extends KinematicBody2D

export var gravity: float = 3000.0
var _velocity: Vector2 = Vector2.ZERO
export var speed: Vector2 = Vector2(200.0, 300)

const FLOOR_NORMAL = Vector2.UP

onready var player = get_parent().get_node("Player")
var direction = Vector2()
var follow = 0
var player_detected = false
var potato_in_place = false

func _physics_process(delta: float) -> void:
	if follow == 0 :
		direction = get_direction_x()
		direction += get_direction_y()
		_velocity = manage_velocity(_velocity, direction)
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	elif follow == 1 :
		direction = Vector2(0,0)
		get_node("Potato/Animationplayer").play("jump")
		follow = 2
	else :
		if not $Potato/Animationplayer.is_playing() :
			$Potato.set_collision_mask(5)
			potato_in_place = true

func manage_velocity(linear_velocity: Vector2, direction: Vector2) -> Vector2:
	var out: = linear_velocity
	out.x = direction.x * speed.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y += speed.y * direction.y
	return out


func get_direction_x() -> Vector2:
	if see_player_x() and player_detected :
		if player.position.x + 5 < position.x :
			return Vector2(-1,0)
		elif player.position.x > position.x + 5 :
			return Vector2(1,0)
		else :
			return Vector2(0,0)
	else :
		return Vector2(0,0)

func see_player_x() :
	var field_of_view = player.position.x - position.x
	if field_of_view < 400 and field_of_view > -400 :
		return true
	else :
		player_detected = false
		return false

func get_direction_y() -> Vector2:
	if see_player_x() and player_detected :
		if player.position.y < position.y and is_on_floor() :
			return Vector2(0,-1)
		elif player.position.x > position.x :
			return Vector2(0,0)
		else :
			return Vector2(0,0)
	else :
		return Vector2(0,0)

func _on_Water_body_entered(body):
	if body == $"." :
		follow = 1


func _on_PlayerInteraction_body_entered(body):
	if body == player :
		player_detected = true
