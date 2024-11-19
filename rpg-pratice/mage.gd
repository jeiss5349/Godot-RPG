extends CharacterBody2D


const SPEED = 300.0
var teleportDestination = Vector2.ZERO

func _ready():
	await get_tree().create_timer(2.0).timeout

func teleport():
	position = teleportDestination
	

func _on_enemy_hurtbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_enemy_hurtbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
