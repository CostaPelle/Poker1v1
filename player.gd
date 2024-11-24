extends CharacterBody2D


const Speed = 150.0
const Acell = 10.0

var input: Vector2

var Inventory = false
@export var EnteredMapArea = false

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()
	

func _process(delta):
	var playerInput = get_input()
	
	var PlayerInput = Input.get_vector("left","right","up","down")
	
	velocity = lerp(velocity, playerInput * Speed, delta * Acell)
	
	move_and_slide()
	
	if Inventory == false:
		if Input.is_action_just_pressed("tab"):
			$Camera2D/UI/TabContainer.visible = true
			Inventory = true
			return
	if Inventory == true:
		if Input.is_action_just_pressed("tab"):
			$Camera2D/UI/TabContainer.visible = false
			Inventory = false
	
	
	if Input.is_action_just_pressed("action"):
		if $Camera2D/UI/Map.visible == true:
			$Camera2D/UI/Map.visible = false
			return
		if EnteredMapArea == true:
			$Camera2D/UI/Map.visible = true
			return
	
	
	
	if PlayerInput == Vector2(-1,0):
		$Walking.play("Walking")
		$Walking.flip_h = false
	
	elif PlayerInput == Vector2(1,0):
		$Walking.play("Walking")
		$Walking.flip_h = true
	
	elif PlayerInput == Vector2(0,-1):
		$Walking.play("Walking_Up")
	
	elif PlayerInput == Vector2(0,1):
		$Walking.play("Walking_Down")





func _on_map_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		EnteredMapArea = true


func _on_map_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		EnteredMapArea = false
