extends CharacterBody2D

const ACCELERATION = 100
const MAX_SPEED = 30
const FRICTION = 500

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

var target
func _init() -> void:
	velocity = Vector2.ZERO
	
func _physics_process(delta):
	var input_vector = Vector2(0, 0)
	if target != null:
		input_vector = position.direction_to(target.position)
		if position.distance_to(target.position) < 20:
			input_vector = Vector2.ZERO
		velocity = (input_vector * MAX_SPEED * delta)
		move_and_collide(velocity)
		print(input_vector)
		print(target.position)
	if input_vector != Vector2(0, 0):
		if input_vector.x > 0:
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationState.travel("Run")
			
			if(position.x - target.position.x) < 0:
				$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		animationState.travel("Idle")
		velocity = (Vector2(0, 0))
		move_and_collide(velocity)

	#move_and_slide()
	


func _on_detection_area_body_entered(body: Node2D) -> void:
	target = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	target = null
