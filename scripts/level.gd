extends Node2D
class_name Level

@export var algae:Algae
@export var boat:Boat
@export var drop_off:Area2D
@export var spawn:Node2D
@export var start_location:Node2D

signal algae_updated(amount:int, total:int, spawning:int)
signal boat_updated(amount:int, total:int)
signal factory_updated(amount:int)

var num_factory:int = 0

var scrub_radius:int = 4

var tween:Tween

func _ready()->void:
  algae.algae_updated.connect(_on_algae_updated)
  boat.boat_moved.connect(_on_boat_moved)
  drop_off.body_entered.connect(_on_body_entered_drop_off)

func reset()->void:
  num_factory = 0
  boat.num_cargo = 0
  boat_updated.emit(boat.num_cargo, boat.max_cargo)
  boat.position = start_location.position
  factory_updated.emit(num_factory)
  algae.clear()

func start()->void:
  algae.grow(spawn.position)

func stop()->void:
  if tween:
    tween.stop()

func apply_upgrades(store:Store)->void:
  boat.max_cargo = store.upgrades.cargo.value()
  boat.speed = store.upgrades.speed.value()
  scrub_radius = store.upgrades.scrub.value()

func _on_algae_updated(amount:int, total: int, spawning:int)->void:
  algae_updated.emit(amount, total, spawning)

func _on_boat_moved(pos:Vector2)->void:
  var collected = algae.clean(pos, scrub_radius, boat.max_cargo - boat.num_cargo)
  if collected > 0:
    boat.num_cargo += collected
    boat_updated.emit(boat.num_cargo, boat.max_cargo)
    if boat.num_cargo == boat.max_cargo:
      $full.play()
    else:
      boat.scrub()

func _on_body_entered_drop_off(body:Node2D)->void:
  if boat.num_cargo == 0:
    return
  if tween:
    tween.stop()
  tween = create_tween()
  var from = Vector2i(num_factory, boat.num_cargo)
  var to = Vector2i(num_factory + boat.num_cargo, 0)
  num_factory += boat.num_cargo
  boat.num_cargo = 0
  tween.tween_method(_transfer_algae, from, to, 1)
  $drop.play()

func _transfer_algae(v:Vector2i)->void:
  factory_updated.emit(v.x)
  boat_updated.emit(boat.num_cargo + v.y, boat.max_cargo)
