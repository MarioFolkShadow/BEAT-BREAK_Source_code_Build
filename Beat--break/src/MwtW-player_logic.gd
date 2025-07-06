extends CharacterBody2D # Player

# Basic Movement
var SPEED = 300.0
var JUMP_VELOCITY = -800.0
var GRAVITY = 1800
# Retired
@export var health: int = 100
var is_retired: bool = false
# Flashing
@export var is_invincible: bool = false
var flash_timer: float = 0.4
# Dash
@export var is_dash: bool = false
@export var dash_dmg: int = 2
var can_dash: bool = true
var dash_speed: float = 2000.0
var dash_duration: float = 0.2
var dash_cooldown: float = 1.0

# Game-loop(per Frame) Function
func _process(_delta: float) -> void:
	if health <= 0 and not is_retired:
		retired()
# Game-loop(per millisecond)/Movement Function
func _physics_process(delta: float) -> void:
	if not is_on_floor() and not is_dash: # gravity control
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("Dash") and can_dash and not is_dash: # dash
		dash_forward()

	if Input.is_action_pressed("ui_up") and is_on_floor() and not is_dash: # jump
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right") # x axis control
	if direction:
		if is_dash:
			velocity.x = direction * dash_speed
		else: velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

# Player Interactions Functions
func dash_forward() -> void:
	if can_dash and not is_dash:
		can_dash = false
		is_dash = true
		$"Dash hitbox area".monitoring = true
		print("Dashing")
		await get_tree().create_timer(dash_duration).timeout
		is_dash = false
		await get_tree().create_timer(dash_cooldown).timeout
		can_dash = true
		$"Dash hitbox area".monitoring = false

# Hurtbox and Retirement Functions
func _on_dummy_attacked() -> void:
	is_invincible = true
	print("Player is now invulnerable.")
	flash_out(3.0)
	await get_tree().create_timer(3.0).timeout

func _on_invincible_timer_timeout() -> void:
	is_invincible = false
	print("Player is now vulnerable.")

func flash_out(delta: float = -1):
	var timer_inv = $"Invincible timer"
	timer_inv.start(delta)
	while timer_inv.time_left > 0:
		$AnimatedSprite2D.modulate.a = 0.25
		await get_tree().create_timer(flash_timer).timeout
		$AnimatedSprite2D.modulate.a = 1.0
		await get_tree().create_timer(flash_timer).timeout
		flash_timer -= 0.06 # Default: 0.06
		# print("Flash Timer: ", flash_timer) for debug
	flash_timer = 0.4
	# print("flash_timer variable has been reset.") # for debug

func retired():
		hide()
		is_retired = true
		print("player has faded.")
