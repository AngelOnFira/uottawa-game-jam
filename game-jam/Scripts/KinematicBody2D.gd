extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 1000.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 800
const WALK_MIN_SPEED = 20
const WALK_MAX_SPEED = 500
const STOP_FORCE = 800
const JUMP_SPEED = 600
const JUMP_MAX_AIRBORNE_TIME = 0.18

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false
var Anim = ""


var prev_jump_pressed = false

onready var sprite = $sprite

func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_just_pressed("ui_up")
	var crouch = Input.is_action_pressed("ui_down")
	
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	### Animation ###
	
	var new_anim = "idle"
	
	if is_on_floor():
		if crouch:
			new_anim = "crouching"
		if velocity.x < WALK_MIN_SPEED and velocity.x > -WALK_MIN_SPEED:
			new_anim = "idle"
		if velocity.x < -WALK_MIN_SPEED:
			sprite.scale.x = -1
			new_anim = "walking"
		if velocity.x > WALK_MIN_SPEED:
			sprite.scale.x = 1
			new_anim = "walking"
			
		
	else:
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			sprite.scale.x = 1
			
	if velocity.y < 0:
		new_anim = "jumping"
	#else new_anim = "falling"
	
	if new_anim != Anim:
		Anim = new_anim
		$Anim.play(Anim)