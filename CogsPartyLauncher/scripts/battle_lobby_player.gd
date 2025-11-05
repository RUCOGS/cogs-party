extends CharacterBody2D

var controllerID
const walkSpeed = 400.0
const jumpVelocity = -1200
var doubleJumpAvailable = true
enum State {Grounded, Airborne, Stunned}
var currentState = State.Airborne

func _process(delta: float) -> void:
	#Horizontal control, always available to player except when stunned
	if (Input.is_action_pressed("left") && velocity.x > -walkSpeed): 
		velocity += Vector2.LEFT * (walkSpeed/2)
	if (Input.is_action_pressed("right") && velocity.x < walkSpeed):
		velocity += Vector2.RIGHT * (walkSpeed/2)
	
	match currentState:
		State.Grounded:
			velocity.x *= 0.8 # apply ground friction
			if (Input.is_action_just_pressed("jump")):
				velocity.y = jumpVelocity
			if (!is_on_floor()): #switch state to Airborne
				currentState = State.Airborne
				
		State.Airborne:
			velocity.x *= 0.95 # apply air friction
			if (Input.is_action_just_pressed("jump") and doubleJumpAvailable):
				velocity.y = jumpVelocity
				doubleJumpAvailable = false
			if (velocity.y < get_gravity().y): #gravitys
				velocity += Vector2.DOWN * (get_gravity()/12)
			if (is_on_floor()): #switch state to Grounded
				doubleJumpAvailable = true
				currentState = State.Grounded
			
		State.Stunned:
			pass
	move_and_slide()
