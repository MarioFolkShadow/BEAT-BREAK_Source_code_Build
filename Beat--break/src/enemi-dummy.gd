extends RigidBody2D

@onready var player = get_node("/root/Test Field/PlaceHPlayer")

signal attacked
const base_dmg: int = 10
var rng := RandomNumberGenerator.new()
var enemi_health: int = 100

# Body Hitbox and Hurtbox
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and player.is_invincible == false and player.is_dash == false:
		var rand_dmg := rng.randf_range(0.8, 1.2)
		rng.randomize()
		var atk_dmg := int(base_dmg * rand_dmg)
		player.health -= atk_dmg
		print("Damaged player for %d (×%.2f)" % [atk_dmg, rand_dmg])
		emit_signal("attacked")
		print("Player health is now: %d" %player.health)
	elif body.is_in_group("Player") and player.is_dash == true:
		var rand_dmg := rng.randf_range(0.8, 1.2)
		rng.randomize()
		var dmg: int = player.dash_dmg * rand_dmg
		enemi_health -= dmg
		print("Receive %d from player dash" %dmg)
