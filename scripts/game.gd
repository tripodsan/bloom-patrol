extends Node2D
class_name Game

@onready var lab_algae: Label = %lab_algae
@onready var lab_cargo: Label = %lab_cargo

@onready var level: Node2D = $level
@onready var title: Control = $ui/title
@onready var info: CenterContainer = $ui/info
@onready var gui: MarginContainer = $ui/gui


func _ready()->void:
  show_title()

func _on_algae_updated(amount:int, total: int)->void:
  lab_algae.text = 'ALGAE: %d / %d' % [amount, total]

func _on_boat_updated(amount:int, total:int)->void:
  lab_cargo.text = 'CARGO: %d / %d' % [amount, total]

func show_title():
  title.visible = true
  level.visible = false
  info.visible = false
  gui.visible = false
  get_tree().paused = true
  title.animate()

func level_init():
  title.visible = false
  info.visible = true
  level.visible = true

func game_start():
  info.visible = false
  gui.visible = true
  get_tree().paused = false

  level.algae_updated.connect(_on_algae_updated)
  level.boat_updated.connect(_on_boat_updated)


func _on_btn_start_pressed() -> void:
  level_init()

func _on_btn_level_start_pressed() -> void:
  game_start()

func _on_btn_settings_pressed() -> void:
  pass # Replace with function body.


func _on_btn_credits_pressed() -> void:
  pass # Replace with function body.
