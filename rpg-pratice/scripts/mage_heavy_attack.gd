extends Node2D
var player = null
var attackRight = true

func _ready():
	if attackRight:
		$AnimationPlayer.play("HeavyAttackRight")
	else:
		$AnimationPlayer.play("HeavyAttackLeft")


	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if player == null:
		if body is CharacterBody2D:
			player = body as playerCH
			if player != null:
				player.health -= 30

func finishAttack():
	queue_free()
