extends CharacterBody2D
class_name Boat

@export var speed = 300

@onready var sprite: AnimatedSprite2D = $sprite

var target_pos: Vector2

signal boat_moved(pos:Vector2)

var num_cargo:int = 0
var max_cargo:int = 100

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
    boat_moved.emit(position)

  move_and_slide()
