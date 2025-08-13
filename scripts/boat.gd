extends CharacterBody2D

@export var speed = 300

@onready var sprite: AnimatedSprite2D = $sprite

@export var algae:Algae

var target_pos: Vector2

func _ready() -> void:
  target_pos = position

@warning_ignore('unused_parameter')
func _physics_process(delta):
  if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
    target_pos = get_viewport().get_mouse_position()

  velocity = target_pos - position
  if velocity.length_squared() > 2:
    var a = rad_to_deg(PI + position.angle_to_point(target_pos))
    if a < 0: a += 360
    a = round(a / 45)
    sprite.frame = a
    algae.clean(position, 8.0)



  move_and_slide()
