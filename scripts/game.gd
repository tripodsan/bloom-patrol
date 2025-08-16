extends Node2D
class_name Game

@onready var lab_algae: Label = %lab_algae
@onready var lab_cargo: Label = %lab_cargo
@onready var lab_factory: Label = %lab_factory
@onready var lab_collected: Label = %lab_collected

@onready var level: Level = $level
@onready var title: Control = $ui/title
@onready var info: CenterContainer = $ui/info
@onready var gui: MarginContainer = $ui/gui
@onready var lost: CenterContainer = $ui/lost
@onready var store: CenterContainer = $ui/store


func _ready()->void:
  level_init()
  game_start()
  show_title()
  #game_over()

func _on_algae_updated(amount:int, total: int)->void:
  var percent:int = 100 * amount / total
  lab_algae.text = 'ALG %d%%' % percent
  if percent >= 80:
    game_over()

func _on_boat_updated(amount:int, total:int)->void:
  lab_cargo.text = 'CARGO %d' % amount

func _on_factory_updated(amount:int)->void:
  lab_factory.text = 'Factory %d' % amount

func show_title():
  title.visible = true
  level.visible = false
  info.visible = false
  lost.visible = false
  store.visible = false
  gui.visible = false
  get_tree().paused = true
  title.animate()

func level_init():
  title.visible = false
  info.visible = true
  level.visible = true
  level.reset()

func game_start():
  info.visible = false
  gui.visible = true
  get_tree().paused = false
  level.start()

  level.algae_updated.connect(_on_algae_updated)
  level.boat_updated.connect(_on_boat_updated)
  level.factory_updated.connect(_on_factory_updated)

func game_over():
  get_tree().paused = true
  lost.visible = true
  lab_collected.text = "%d\n" % level.num_factory

func _on_btn_start_pressed() -> void:
  level_init()

func _on_btn_level_start_pressed() -> void:
  game_start()

func _on_btn_settings_pressed() -> void:
  pass # Replace with function body.


func _on_btn_credits_pressed() -> void:
  pass # Replace with function body.

func _on_btn_continue_pressed() -> void:
  lost.visible = false
  store.visible = true
