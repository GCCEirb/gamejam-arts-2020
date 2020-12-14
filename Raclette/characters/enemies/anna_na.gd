extends Enemy

var bullet = preload("res://characters/bullet.tscn")
var target : KinematicBody2D

func _ready():
	print("anna ready")
	
func _process(delta: float) -> void:
	manage_action()
	
func manage_action():
	if not $CooldownTimer.is_stopped():
		return
	if target:
		fire((target.global_position - global_position).normalized())


func _on_DetectionArea_body_entered(body):
	target = body
	$CooldownTimer.start()
	

func fire(direction):
	$CooldownTimer.start()
	var new_bullet = bullet.instance()
	new_bullet.direction = direction
	add_child(new_bullet)
	# le temps de trouver un endroit ou spawn les truc on les met à gauche
	var spawn_pos = Vector2(-300, -85)
	if (direction.x < 0):
		spawn_pos = Vector2(300, -85)
	new_bullet.position = position + spawn_pos
	


func _on_DetectionArea_body_exited(_body):
	target = null
	$CooldownTimer.stop()



