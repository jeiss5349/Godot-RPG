extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true
var enemy_attack_cooldown = true
var attack_ip = false

var slash_combo_step = 0  # 0 for no attack, 1 for slash1, 2 for slash2


@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	deal_with_damage()
	
	if player_chase:
		# Move towards player
		position += (player.position - position)/speed
		animationTree.set("parameters/blend_position", Vector2(1, 0))  # Trigger 'Run'
		animationState.travel("Run")  # Ensure 'Run' animation plays
		move_and_collide(Vector2(0, 0)) 
		
		# Flip sprite based on player's position
		if(player.position.x - position.x) < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		# Default to 'Idle' when not chasing
		animationState.travel("Idle")  # Play Idle animation
	if player_inattack_zone and enemy_attack_cooldown:
		perform_attack_combo()
		#print("attack called")
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		if can_take_damage == true:
			health -= 30  # Reduce enemy's health
			can_take_damage = false
			print("enemy health = ", health)  # Debugging message
			await get_tree().create_timer(1.0).timeout
			reset_damage_cooldown()
			if health <= 0:
				play_death_animation()  # Trigger death animation
				print("Enemy defeated!")  # Debugging message

func take_damage(amount):
	health -= amount
	print("Enemy health: ", health)
	if health <= 0:
		play_death_animation()  # Trigger death animation

func play_death_animation():
	animationState.travel("Death")  # Trigger death animation
	await get_tree().create_timer(1.0).timeout
	queue_free()

func reset_damage_cooldown():
	can_take_damage = true

# Handle attack combo (slash1 -> slash2)
func perform_attack_combo():
	if player != null and player.player_alive and not attack_ip:
		#attack_ip = true
		#slash_combo_step = 1
		animationState.travel("Slash1")  # Trigger 'Slash1' animation
		#print("attack combo started")

func _on_attack_timer_timeout() -> void:
	damagePlayer()

		#slash_combo_step = 0
		#attack_ip = false
	#enemy_attack_cooldown = true
#
	#else:
		#enemy_attack_cooldown = true

func damagePlayer() -> void:
	if player != null:
		player.health -= 20
		print(player.health)
	
	
