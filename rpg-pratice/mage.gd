extends CharacterBody2D
var player = null
var direction = 1

var teleportDestination = Vector2.ZERO
var speed = 200
var teleportRNG = RandomNumberGenerator.new()

@export var HeavyAttack: PackedScene

enum {
	IDLE,
	TELEPORT,
	ABILITY,
	DEATH,
	WAIT
}
var state = IDLE

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _ready():
	await get_tree().create_timer(2.0).timeout
	
func _physics_process(delta):
	orient()
	match state:
		IDLE:
			idle_state()
		TELEPORT:
			start_teleport()
		ABILITY:
			ability_state()
		DEATH:
			pass
		WAIT:
			pass

func idle_state():
	orient()
	animationState.travel("Idle")
	animationTree.set("parameters/Idle/blend_position", direction) 

	

func teleport():
	var x_offset = teleportRNG.randf_range(-20.0, 20.0)
	print("x_offset: ", x_offset)
	var y_offset = teleportRNG.randf_range(-20.0, 20.0)
	print("y_offset: ", y_offset)
	print("speed: ", speed)
	teleportDestination = (-1*(player.global_position - global_position).normalized()) * speed
	teleportDestination = teleportDestination + Vector2(x_offset, y_offset)
	global_position = teleportDestination + global_position
	print("global position: ", position)
	animationState.travel("teleportEnd")
	animationTree.set("parameters/teleportEnd/blend_position", direction) 
	try_change_state(WAIT)

func start_teleport():
	orient()
	animationState.travel("teleportStart")
	animationTree.set("parameters/teleportStart/blend_position", direction) 

func finished_teleport():
	try_change_state(IDLE)
	
func ability_state():
	orient()
	animationState.travel("heavyAttackCharge")
	animationTree.set("parameters/heavyAttackCharge/blend_position", direction) 
	

	
func spawnAttack():
	orient()
	var attack_object = preload("res://scenes/mage_heavy_attack.tscn")
	var attack = attack_object.instantiate()
	if direction == -1:
		attack.attackRight = false
	
	add_child(attack)

	
func try_change_state(new_state):
	if state != DEATH:
		state = new_state

func orient():
	if player != null and state != DEATH:
		if(player.position.x - position.x) < -5:
			direction = -1
			#scale.x = -scale.x

		elif(player.position.x - position.x) > 5:
			direction = 1
			#scale.x = abs(scale.x)

func _on_enemy_hurtbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_enemy_hurtbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detection_area_body_entered(body: Node2D) -> void:
	print("body entered")
	if body is CharacterBody2D:
		player = body as playerCH
		try_change_state(ABILITY)
		print("player entered detection")
	
	
