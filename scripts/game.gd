extends Node2D
class_name Game

@onready var lab_algae: Label = %lab_algae
@onready var lab_cargo: Label = %lab_cargo
@onready var lab_factory: Label = %lab_factory
@onready var lab_collected: Label = %lab_collected

@onready var level: Level = $level
@onready var title: Control = $ui/title
@onready var info: Control = $ui/info
@onready var gui: Control = $ui/gui
@onready var lost: Control = $ui/lost
@onready var store: Store = $ui/store
@onready var credits: Control = $ui/credits
@onready var win: Control = $ui/win
@onready var bg_sound: AudioStreamPlayer = $bg_sound

var algae_price:float = 0.1

func _ready()->void:
  credits.visible = false
  title.visible = false
  level.visible = false
  info.visible = false
  lost.visible = false
  store.visible = false
  gui.visible = false
  win.visible = false
  #level_init()
  #game_start()
  show_title()
  #_on_btn_continue_pressed()
  #game_over()

func _on_algae_updated(amount:int, total: int, spawning:int)->void:
  var percent:int = 100 * amount / total
  lab_algae.text = 'BLOOM %d%%' % percent
  if percent >= 80:
    game_over()
  if amount == 0 && spawning == 0:
    game_win()

func _on_boat_updated(amount:int, total:int)->void:
  lab_cargo.text = 'CARGO %d' % amount

func _on_factory_updated(amount:int)->void:
  lab_factory.text = 'Factory %d' % amount

func show_title():
  title.visible = true
  get_tree().paused = true
  title.animate()

func level_init():
  title.visible = false
  info.visible = true
  level.visible = true
  level.algae_updated.connect(_on_algae_updated)
  level.boat_updated.connect(_on_boat_updated)
  level.factory_updated.connect(_on_factory_updated)
  level.reset()

func game_start():
  info.visible = false
  gui.visible = true
  get_tree().paused = false
  level.apply_upgrades(store)
  level.start()
  bg_sound.bus = 'bg'
  if !bg_sound.playing:
    bg_sound.play()

func game_over():
  level.stop()
  bg_sound.bus = 'bg_muffled'
  $sfx_game_over.play()
  get_tree().paused = true
  lost.visible = true
  var earning:int = ceil(level.num_factory * algae_price)
  store.cash += earning
  _update_collected(0)
  create_tween() \
    .set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) \
    .tween_method(_update_collected, 0, earning, 1.5) \
    .set_delay(1)

func game_win():
  win.visible = true
  gui.visible = false
  bg_sound.stop()
  get_tree().paused = true
  $sfx_game_win.play()
  $%lab_win_cash.text = '%d$' % store.cash

func _update_collected(v:int)->void:
  lab_collected.text = "%d $\n" % v
  _on_factory_updated(max(level.num_factory - v / algae_price, 0))

func _on_btn_start_pressed() -> void:
  $sfx_klick.play()
  level_init()

func _on_btn_level_start_pressed() -> void:
  $sfx_klick.play()
  game_start()

func _on_btn_settings_pressed() -> void:
  pass

func _on_btn_credits_pressed() -> void:
  $sfx_klick.play()
  title.visible = false
  credits.visible = true

func _on_btn_continue_pressed() -> void:
  $sfx_klick.play()
  lost.visible = false
  gui.visible = false
  store.open()

func _on_btn_credits_back_pressed() -> void:
  $sfx_klick.play()
  title.visible = true
  credits.visible = false

func _on_btn_restart_pressed() -> void:
  $sfx_klick.play()
  store.close()
  level_init()
  game_start()

func _on_btn_win_continue_pressed() -> void:
  $sfx_klick.play()
  store.reset()
  win.visible = false
  level.visible = false
  gui.visible = false
  show_title()
