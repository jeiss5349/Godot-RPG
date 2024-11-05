class_name assassin2
extends CharacterBody2D


var speed = 100
var player_chase = false
var sweep_IP = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true
var enemy_attack_cooldown = true
const sweep_speed = 4500
var attack_ip = false

var sweep_Vector = Vector2.ZERO

var slash_combo_step = 0  # 0 for no attack, 1 for slash1, 2 for slash2

enum {
	IDLE,
	RUN,
	SLASH,
	SWEEP,
	DEATH
}
var state = IDLE

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):

	#print(state)
	match state:
		IDLE:
			idle_state()
		RUN:
			run_state()
		SLASH:
			slash_state()
		SWEEP:
			sweep_state(delta)
		DEATH:
			death_state()
			

func try_change_state(new_state):
	if not attack_ip and state != DEATH:
		state = new_state

func orient():
	if player != null and state != DEATH:
		if(player.position.x - position.x) < -5:
			$HitboxPivot.global_rotation_degrees = 0.0
			$Sprite2D.flip_h = true
			#scale.x = -scale.x

		elif(player.position.x - position.x) > 5:
			$HitboxPivot.global_rotation_degrees = 180.0
			$Sprite2D.flip_h = false
			#scale.x = abs(scale.x)

func run_state():
	if player != null:
		orient()
		position += (player.position - position)/speed
		animationTree.set("parameters/blend_position", Vector2(1, 0))  # Trigger 'Run'
		animationState.travel("Run")  # Ensure 'Run' animation plays
		move_and_collide(Vector2(0, 0)) 
		if position.distance_to(player.global_position) >= 50:
			try_change_state(SWEEP)
		elif position.distance_to(player.global_position) < 15:
			try_change_state(SLASH)
	else:
		try_change_state(IDLE)

func idle_state():
	orient()
	animationState.travel("Idle")


func death_state():
	pass

	
func sweep_state(delta):
	print("sweeping")
	if attack_ip:
		sweep_move(delta)
		print("sweep move")
	elif enemy_attack_cooldown:
		sweep_attack()
		print("sweep attack")
		
	
func slash_state():
	if player_inattack_zone and enemy_attack_cooldown:
			perform_attack_combo()



func _on_detection_area_body_entered(body):
	player = body
	try_change_state(RUN)

func _on_detection_area_body_exited(body):
	player = null
	try_change_state(IDLE)
	
func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true
		try_change_state(SLASH)

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false
		try_change_state(RUN)

func deal_with_damage(dmgAmount : int):
	if player_inattack_zone:
		if can_take_damage == true:
			health -= dmgAmount  # Reduce enemy's health
			can_take_damage = false
			print("enemy health = ", health)  # Debugging message
			if health <= 0:
				play_death_animation()  # Trigger death animation
				try_change_state(DEATH)
				print("Enemy defeated!")  # Debugging message
			else: 
				await get_tree().create_timer(1.0).timeout
				reset_damage_cooldown()

#func take_damage(amount):
	#health -= amount
	#print("Enemy health: ", health)
	#if health <= 0:
		#play_death_animation()  # Trigger death animation

func play_death_animation():
	animationState.travel("Death")  # Trigger death animation
	print("enemy dies")
	await get_tree().create_timer(5.0).timeout
	print("enemy deleted")
	queue_free()

func reset_damage_cooldown():
	can_take_damage = true

# Handle attack combo (slash1 -> slash2)
func perform_attack_combo():
	if player != null: 
		if player.player_alive and not attack_ip:
		#attack_ip = true
		#slash_combo_step = 1e
			animationState.travel("Slash1")  # Trigger 'Slash1' animation
		#print("attack combo started")
func sweep_attack():
	if player.player_alive and not attack_ip:
		sweep_Vector = (player.position - position).normalized()
		print(sweep_Vector)
		animationState.travel("sweepCharge")
		sweep_IP = true
		attack_ip = true


func sweep_move(delta):
	velocity = sweep_Vector * sweep_speed * delta
	move_and_slide()
	

func _on_attack_timer_timeout() -> void:
	damage_player()
	attack_ip = false
	try_change_state(RUN)

		#slash_combo_step = 0
		#attack_ip = false
	#enemy_attack_cooldown = true
#
	#else:
		#enemy_attack_cooldown = true

func damage_player() -> void:
	if player_inattack_zone:
		player.health -= 10
		print(player.health)
	
	
