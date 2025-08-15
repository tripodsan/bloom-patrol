extends Control

@onready var logo: TextureRect = $gfx/logo
@onready var buttons: PanelContainer = $MarginContainer/buttons
@onready var gfx: Control = $gfx

signal start()
signal settings()
signal credits()

func _ready():
  reset()

func reset():
  gfx.visible = false
  buttons.visible = false

func animate():
  var tween = create_tween()
  logo.scale = Vector2(0.2, 0.2)
  logo.visible = false
  tween.set_trans(tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
  tween.tween_property(gfx, "visible", true, 0.2)
  tween.tween_interval(1)
  tween.tween_property(logo, "visible", true, 0)
  tween.tween_property(logo, "scale", Vector2.ONE, 1)
  tween.tween_property(buttons, "visible", true, 1)
