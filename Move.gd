#Finite state machine prototype
#The code isn't suitable for scaling just yet
#Possible improvement: States become classes?
extends KinematicBody2D


enum States {IDLE, WALKING, ATTACKING, DYING}
var sprite : Node = null
var _currentState : int = States.IDLE
var b : Transform2D = Transform2D.IDENTITY
var velo :Vector2 = Vector2.ZERO
var dir : Vector2 = Vector2.ZERO
var mouse_pos : Vector2 = Vector2.ZERO
var delayed_mouse_pos : Vector2 = Vector2.ZERO
##Change this in order to use the script on different objects
var objNode : String = "Sprite"

func _ready():
	sprite = get_node(objNode)
	b = self.transform
	randomize()
	return

#check signals, maybe i could use them, like c# evets, to call this function, instead of having to call it by hand
func GetCurrentState():
	if Input.is_action_pressed("click"):
	#transition to walking
	#maybe walk around the point i made?
		if _currentState != States.ATTACKING:
			sprite  = get_node(objNode)
			_currentState = States.WALKING
			mouse_pos = self.get_global_mouse_position()
			
	
	if Input.is_action_just_pressed("right-click"):
		#transition to idle
		_currentState = States.IDLE
		print(_currentState)
	if Input.is_action_just_pressed("middle-click"):
	#transition to attack
		#attack toward the current mouse position
		mouse_pos = self.get_global_mouse_position()
		_currentState = States.ATTACKING
		print(_currentState)

func GetPlayerInput(speed):
	velo = Vector2.ZERO
	if Input.is_action_pressed("left"):
		velo.x -= 1
	if Input.is_action_pressed("right"):
		velo.x += 1
	if Input.is_action_pressed("up"):
		velo.y -= 1
	if Input.is_action_pressed("down"):
		velo.y += 1
	return velo.normalized() * speed



func Attacking(_delta):
	#random rapid movements moving slightly towards the cursor
	mouse_pos = self.get_global_mouse_position()
	dir = mouse_pos - self.get_global_transform().origin
	sprite.transform.origin += Vector2(rand_range(-5,5),rand_range(-5,5))
	move_and_slide(dir)
func Idling(delta):
	sprite.rotation_degrees += delta
func Walking(_delta):
	if(sprite.transform.origin != Vector2.ZERO):
		sprite.transform.origin.x = smoothstep(sprite.transform.origin.x,0,0.5)
		sprite.transform.origin.y = smoothstep(sprite.transform.origin.y,0,0.5)
	if(sprite.rotation_degrees >= 0):
		sprite.rotation_degrees -= smoothstep(deg2rad(0),abs(deg2rad(sprite.rotation_degrees)),0.5)
	if(sprite.rotation_degrees <= 0):
		sprite.rotation_degrees += smoothstep(deg2rad(0),abs(deg2rad(sprite.rotation_degrees)),0.5)
	
	if(Input.is_action_pressed("click")):
		dir = mouse_pos - self.get_global_transform().origin
		dir = dir*10
	move_and_slide(dir)
	delayed_mouse_pos = mouse_pos
	
func _physics_process(delta):
	GetCurrentState()
	if _currentState == States.IDLE:
		Idling(delta*60)
	if _currentState == States.WALKING:
		Walking(delta)
	if _currentState == States.ATTACKING:
		Attacking(delta)
	if _currentState == States.DYING:
		pass
