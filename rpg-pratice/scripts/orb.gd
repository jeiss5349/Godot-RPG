extends Node2D
var player = null
var attackDirection = Vector2.ZERO
var speed = 100




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = attackDirection * delta * speed
	global_position = velocity + global_position
	
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body is playerCH:
			player = body as playerCH
			player.health -= 10
			queue_free()
