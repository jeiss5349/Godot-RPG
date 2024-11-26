class_name playerCH
extends CharacterBody2D



var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var enemy_reference = null


const speed = 2
var current_dir = "none"

var attack_ip = false


func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	
	
	if health <= 0 and player_alive:
		player_alive = false 
		health = 0
		print("player has been killed")
		$AnimatedSprite2D.play("death")
	elif player_alive:
		player_movement(delta)
		#enemy_attack()
		attack()

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_collide(velocity)
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0 and attack_ip == false:
			anim.play("side_idle")

	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0 and attack_ip == false:
			anim.play("side_idle")

	elif dir == "down":
		anim.flip_h = false  # No need to flip for front/back
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0 and attack_ip == false:
			anim.play("front_idle")

	elif dir == "up":
		anim.flip_h = false  # No need to flip for front/back
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0 and attack_ip == false:
			anim.play("back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:

		if body is assassin2:
			enemy_reference = body as assassin2 
		elif body is mage:
			enemy_reference = body as mage
			


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body is assassin2:
		enemy_reference = null
		
#func enemy_attack():
	#if enemy_inattack_range and enemy_attack_cooldown == true:
		#health = health - 20
		#enemy_attack_cooldown = false
		#$attack_cooldown.start()
		#print("player health: ", health)


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		attack_ip = true
		if enemy_reference != null:
			enemy_reference.deal_with_damage(30) 
			
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()

		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()

		elif dir == "down":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()

		elif dir == "up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	attack_ip = false

	
	
