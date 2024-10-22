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

@onready var attack_timer = $attack_timer

func _physics_process(delta):
	
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		move_and_collide(Vector2(0,0)) 
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		
	if player_inattack_zone and enemy_attack_cooldown:
		perform_attack_combo()
		
		

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false


func enemy():
	pass
	


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
			##$take_damage_cooldown.start(e)  # Add cooldown to prevent repeated damage
			can_take_damage = false
			print("enemy health = ", health)  # Print enemy health each time damage is taken
			await get_tree().create_timer(1.0).timeout
			reset_damage_cooldown() 
			if health <= 0:
				self.queue_free()  # Enemy is defeated
				print("Enemy defeated!")  # Debugging message for when the enemy is killed
				


func take_damage(amount):
	health -= amount
	print("Slime health: ", health)
	if health <= 0:
		self.queue_free()  # Enemy is defeated


			
func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	
func reset_damage_cooldown():
	can_take_damage = true

func _on_animated_sprite_2d_ready() -> void:
	$AnimatedSprite2D.play("idle")  # Replace with function body.
	
	
# Function to handle enemy attack combo (slash1 -> slash2)
func perform_attack_combo():
	if player != null and player.player_alive and not attack_ip:
	# Attack logic

		attack_ip = true
		slash_combo_step = 1
		$AnimatedSprite2D.play("slash1")
		attack_timer.start(1)  # Adjust time to match the length of the "slash1" animation

# Handle the combo sequence
func _on_attack_timer_timeout() -> void:
	if slash_combo_step == 1:
		# Deal damage after "slash1"
		if player != null:
			player.health -= 20  # Damage from slash1
			print("Player damaged by slash1, player health: ", player.health)
		
		# Proceed to "slash2"
		slash_combo_step = 2
		$AnimatedSprite2D.play("slash2")
		attack_timer.start(1)  # Adjust time to match the length of the "slash2" animation

	elif slash_combo_step == 2:
		# Deal damage after "slash2"
		if player != null:
			player.health -= 20  # Damage from slash2
			print("Player damaged by slash2, player health: ", player.health)
		
		# Reset combo
		slash_combo_step = 0
		attack_ip = false
		enemy_attack_cooldown = false
		attack_timer.start(2.0)  # Cooldown before the enemy can attack again

	else:
		# End of combo and reset the attack cooldown
		enemy_attack_cooldown = true
