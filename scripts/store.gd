extends Control
class_name Store

@onready var lab_cash: Label = %lab_cash
@onready var items: GridContainer = $MarginContainer/VBoxContainer/PanelContainer2/items

var cash:int = 0

class Upgrade:
  var tier:int = 0
  var values:Array[int]
  var prices:Array[int]

  func _init(values:Array[int], prices:Array[int]):
    self.values = values
    self.prices = prices

  func value()->int:
    return values[tier]

  func value_next()->int:
    if tier + 1 == values.size():
      return values[tier]
    return values[tier + 1]

  func price()->String:
    if tier + 1 == prices.size():
      return 'max'
    return '%d$' % prices[tier + 1]

  func buy(cash:int)->int:
    if !enabled(cash): return -1
    tier += 1
    return cash - prices[tier]

  func enabled(cash:int)->bool:
    return tier + 1 < values.size() && cash >= prices[tier + 1]

var upgrades = {
  "speed": Upgrade.new(
    [100, 150, 200],
    [  0,  25,  50]
  ),
  "scrub": Upgrade.new(
    [  4,   6,  8],
    [  0,  50, 500]
  ),
  "cargo": Upgrade.new(
    [100, 200, 500],
    [  0,  40, 100]
  ),
  "turtle": Upgrade.new(
    [0,  1,  2,   3,   4,   5,    6],
    [0, 10, 50, 100, 200, 500, 1000]
  )
}

func _ready()->void:
  init_gfx()

func reset()->void:
  for key in upgrades:
    upgrades[key].tier = 0

func _on_btn_pressed(up:Upgrade)->void:
  var new_cash = up.buy(cash)
  if new_cash >= 0:
    cash = new_cash
    update_gfx()


func open()->void:
  visible = true
  update_gfx()

func close()->void:
  visible = false

func init_gfx()->void:
  for key in upgrades:
    var up:Upgrade = upgrades[key]
    items.get_node('%s_cost' % key).connect('pressed', _on_btn_pressed.bind(up))

func update_gfx()->void:
  lab_cash.text = "cash: %d$" % cash
  for key in upgrades:
    var up:Upgrade = upgrades[key]
    items.get_node('%s_val' % key).text = '%d ->' %up.value()
    items.get_node('%s_upd' % key).text = str(up.value_next())
    var btn:Button = items.get_node('%s_cost' % key)
    btn.disabled = !up.enabled(cash)
    btn.text = up.price()
