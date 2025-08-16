extends Sprite2D
class_name Algae

const W:int = 480
const H:int = 272

const S:int = 4
const SV:Vector2i = Vector2i(S, S)
const ST:Vector2i = Vector2i(16, 16)
const DT:float = 1.0/255.0
const C_VOID:Color = Color(0, 0, 0, 0)

var num_algae:int = 0
var num_algae_p:int = -1
var max_algae:int = 0

signal algae_updated(amount:int, total:int)

@export
var land:TileMapLayer

const DIRS:Array[Vector2i] = [
  Vector2i(S, 0),
  Vector2i(S, S),
  Vector2i(0, S),
  Vector2i(-S, S),
  Vector2i(-S, 0),
  Vector2i(-S, -S),
  Vector2i(0, -S),
  Vector2i(S, -S),
]

const DIRS_OFFSET:Array[int] = [
  4 + 0 * W,
  4 + 4 * W,
  0 + 4 * W,
  -4 + 4 * W,
  -4 + 0 * W,
  -4 + -4 * W,
  0 + -4 * W,
  4 + -4 * W,
]

var img:Array[Image] = [null, null]
var idx:int = 0

func _ready() -> void:
  for i:int in range(0, 2):
    img[i] = Image.create_empty(W, H, false, Image.FORMAT_RGBA8)
    img[i].fill(C_VOID)
  # inital algae map
  max_algae = 0
  texture = ImageTexture.create_from_image(img[0])
  for v:Vector2i in land.get_used_cells():
    var td:TileData = land.get_cell_tile_data(v)
    var p:Vector2 = land.map_to_local(v) - Vector2(8, 8)
    if p.x >= 0 && p.x + 8 < W && p.y >= 0 && p.y + 8 < H:
      if td.terrain_set == 0 && td.terrain == 1:
        max_algae += 16
      else:
        var ac:Vector2i = land.get_cell_atlas_coords(v)
        var ts:TileSetAtlasSource = land.tile_set.get_source(land.get_cell_source_id(v))
        var t:Texture2D = ts.texture
        var r:Rect2i = ts.get_tile_texture_region(ac)
        var src:Image = t.get_image();
        # todo: find better way...maybe make water transparent and blit a red image with mask
        for x in range(0, r.size.x, 4):
          for y in range(0, r.size.y, 4):
            var c:Color = src.get_pixel(x + r.position.x, y + r.position.y)
            if c == Color.BLUE:
              max_algae += 1
            else:
              img[0].set_pixel(p.x + x, p.y + y, Color.RED)
  img[1].copy_from(img[0])

func clean(pos:Vector2, radius:int, max_collected:int)->int:
  var src = img[idx]
  pos = pos.snapped(SV) - Vector2(8, 8)
  var collected:int = 0
  for x in range(0, radius * 4, 4):
    for y in range(0, radius * 4, 4):
      if collected >= max_collected:
        return collected
      var v = Vector2(x, y) + pos
      var p:Color = src.get_pixelv(v)
      if p.r == 0:
        src.set_pixelv(v, Color.BLUE)
      if p.g == 1:
        collected += 1
  return collected;


func _process(delta: float) -> void:
  if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
    grow(get_viewport().get_mouse_position())

  update_sim()
  if num_algae_p != num_algae:
    algae_updated.emit(num_algae, max_algae)
    num_algae_p = num_algae

  texture.update(img[idx])

func grow(pos:Vector2)->void:
    pos = pos.snapped(SV)
    img[idx].set_pixelv(pos, Color.GREEN)

func spread(src:Image, dst:Image, pos:Vector2i):
  var a:float = 0.0
  for d:Vector2i in DIRS:
    var v = pos + d
    if v.x >= 0 && v.x < W && v.y >=0 && v.y < H:
      var p = src.get_pixelv(v)
      var s = (100.0 if d.x == 0 || d.y == 0 else 200.0) - randf_range(0.0, 80)
      a += p.g / s
  if a >= DT:
    dst.set_pixelv(pos, Color(0, a, 0, 1))

func update_sim():
  var src:Image = img[idx]
  idx = (idx + 1) % 2
  var dst:Image = img[idx]
  dst.copy_from(src)
  for y:int in range(0, H, S):
    for x:int in range(0, W, S):
      var v:Vector2i = Vector2i(x, y)
      var p:Color = src.get_pixelv(v)
      if p.a == 0:
        spread(src, dst, v)
  num_algae = 0
  for y:int in range(0, H, S):
    for x:int in range(0, W, S):
      var p:Color = dst.get_pixel(x, y)
      if p.g > 0.0 && p.g < 1.0:
        p.g = min(p.g + DT, 1.0)
        dst.set_pixel(x, y, p)
      elif p.b > 0.0:
        p.b -= DT
        if p.b < DT:
          p.b = 0
          p.a = 0
        dst.set_pixel(x, y, p)
      if p.g == 1.0:
        num_algae += 1
