extends Node2D
class_name Level

@export var algae:Algae
@export var boat:Boat
@export var drop_off:Area2D
@export var spawn:Node2D

signal algae_updated(amount:int, total:int)
signal boat_updated(amount:int, total:int)
signal factory_updated(amount:int)

var num_factory:int = 0

func _ready()->void:
  algae.algae_updated.connect(_on_algae_updated)
  boat.boat_moved.connect(_on_boat_moved)
  drop_off.body_entered.connect(_on_body_entered_drop_off)

func reset()->void:
  num_factory = 0

func start()->void:
  algae.grow(spawn.position)
  pass

func _on_algae_updated(amount:int, total: int)->void:
  algae_updated.emit(amount, total)

func _on_boat_moved(pos:Vector2)->void:
  var collected = algae.clean(pos, 4, boat.max_cargo - boat.num_cargo)
  if collected > 0:
    boat.num_cargo += collected
    boat_updated.emit(boat.num_cargo, boat.max_cargo)

func _on_body_entered_drop_off(body:Node2D)->void:
  num_factory += boat.num_cargo
  boat.num_cargo = 0
  boat_updated.emit(boat.num_cargo, boat.max_cargo)
  factory_updated.emit(num_factory)
