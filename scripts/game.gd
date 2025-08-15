extends Node2D

@onready var lab_algae: Label = %lab_algae
@onready var lab_cargo: Label = %lab_cargo

@export var algae:Algae
@export var boat:Boat

@export var drop_off:Area2D

func _ready()->void:
  algae.algae_updated.connect(_on_algae_updated)
  boat.boat_moved.connect(_on_boat_moved)
  drop_off.body_entered.connect(_on_body_entered_drop_off)
  update_cargo_label()

func _on_algae_updated(amount:int, total: int)->void:
  lab_algae.text = 'ALGAE: %d / %d' % [amount, total]

func _on_boat_moved(pos:Vector2)->void:
  var collected = algae.clean(pos, 4, boat.max_cargo - boat.num_cargo)
  if collected > 0:
    boat.num_cargo += collected
    update_cargo_label()

func update_cargo_label()->void:
  lab_cargo.text = 'CARGO: %d / %d' % [boat.num_cargo, boat.max_cargo]

func _on_body_entered_drop_off(body:Node2D)->void:
  boat.num_cargo = 0
  update_cargo_label()
