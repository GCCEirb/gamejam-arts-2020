extends KinematicBody2D

const UP = Vector2(0,-1)
const SLOPE_STOP = 64

signal hit
signal health_updated(health)
signal death()

var velocity = Vector2() # The player's movement vector.
var move_speed = 50
var jump_velocity = 720
var screen_size
var gravity = 1200
export var max_health = 100
onready var health = max_health setget _set_health
onready var invulnerable_timer = $Invulnerable
onready var anim = $AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size # Replace with function body.

func _physics_process(delta):
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	velocity.y += gravity * delta
	_get_input()

func _input(event):
	if event.is_action_pressed("jump"):
		velocity.y = jump_velocity

func _get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)
	if velocity.x == 0:
		anim.animation = "idle"
	else:
		anim.animation = "walk"
		if velocity.x < 0:
			anim.flip_h = true
		else:
			anim.flip_h = false
#	if move_direction != 0:
		

func damage(amount):
	if invulnerable_timer.is_stopped():
		invulnerable_timer.start()
		_set_health(health - amount)

func kill():
	pass

func _set_health(value):
	var prev_health = health
	health = clamp (value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("death")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
