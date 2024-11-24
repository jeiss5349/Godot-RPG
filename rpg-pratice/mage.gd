extends CharacterBody2D
var player = null
var direction = 1

const SPEED = 300.0
var teleportDestination = Vector2.ZERO
var speed = 60
var teleportRNG = RandomNumberGenerator.new()

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
	match state:
		IDLE:
			idle_state()
		TELEPORT:
			start_teleport()
		ABILITY:
			pass
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
	var y_offset = teleportRNG.randf_range(-20.0, 20.0)
	teleportDestination = (-1*(player.position - position).normalized()) * speed
	teleportDestination = teleportDestination + Vector2(x_offset, y_offset)
	position = teleportDestination
	try_change_state(WAIT)

func start_teleport():
	animationState.travel("teleportStart")
	animationTree.set("parameters/teleportStart/blend_position", direction) 

func finished_teleport():
	
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
	if body == playerCH:
		player = body as playerCH
		try_change_state(TELEPORT)
	
	
