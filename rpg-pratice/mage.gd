class_name mage
extends CharacterBody2D
var player = null
var direction = 1

var teleportDestination = Vector2.ZERO
var speed = 200
var teleportRNG = RandomNumberGenerator.new()
var health = 120



@export var HeavyAttack: PackedScene

enum {
	IDLE,
	TELEPORT,
	ABILITY,
	ATTACK,
	DEATH,
	WAIT
}
var state = IDLE

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _ready():
	pass
	#await get_tree().create_timer(2.0).timeout
	
func _physics_process(delta):
	orient()
	match state:
		IDLE:
			idle_state()
		TELEPORT:
			start_teleport()
		ABILITY:
			ability_state()
			print("health of player: ", player.health )
		ATTACK:
			attack_state()
			print("health of player: ", player.health )
		DEATH:
			death_state()
		WAIT:
			pass
		

func idle_state():
	orient()
	animationState.travel("Idle")
	animationTree.set("parameters/Idle/blend_position", direction) 
	print(player)
	if player != null:
		await get_tree().create_timer(2.0).timeout
		try_change_state(ATTACK)
		print("calling orb attack", )
	
func death_state():
	await get_tree().create_timer(2.0).timeout
	queue_free()


func teleport():
	var x_offset = teleportRNG.randf_range(-20.0, 20.0)

	var y_offset = teleportRNG.randf_range(-20.0, 20.0)

	teleportDestination = (-1*(player.global_position - global_position).normalized()) * speed
	teleportDestination = teleportDestination + Vector2(x_offset, y_offset)
	teleportDestination = teleportDestination + global_position
	global_position = Vector2(clamp(teleportDestination.x, 20.0, 310.0), clamp(teleportDestination.y,-10.0, 214.0))

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
	
func attack_state():
	orient()
	animationState.travel("lightAttack")
	animationTree.set("parameters/lightAttack/blend_position", direction) 
	
func spawnAttack():
	orient()
	var attack_object = preload("res://scenes/mage_heavy_attack.tscn")
	var attack = attack_object.instantiate()
	if direction == -1:
		attack.attackRight = false
	
	add_child(attack)
	
func spawnOrb():
	var attack_object = preload("res://scenes/Orb.tscn")
	var attack = attack_object.instantiate()
	attack.attackDirection = -1*(position - player.position).normalized()
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

	if body is CharacterBody2D:
		player = body as playerCH
		try_change_state(ABILITY)

		
func deal_with_damage(dmgAmount : int):
	health -= dmgAmount
	print("Mage Health is: ", health)
	if health <= 0:
		animationState.travel("Death")
		animationTree.set("parameters/Death/blend_position", direction) 
		try_change_state(DEATH)
	
	
