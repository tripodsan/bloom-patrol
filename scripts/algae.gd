extends Sprite2D
class_name Algae

const W:int = 480
const H:int = 270

const S:int = 4
const SV:Vector2i = Vector2i(S, S)
const ST:Vector2i = Vector2i(16, 16)
const GROW_STEPS:int = 255
const C_VOID:Color = Color(0, 0, 0, 0)

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

var img:Array[Image] = [null, null]
#var tex:Array[ImageTexture] = [null, null]
var idx:int = 0

func _ready() -> void:
  for i:int in range(0, 2):
    img[i] = Image.create_empty(W, H, false, Image.FORMAT_RGBA8)
    img[i].fill(C_VOID)
  texture = ImageTexture.create_from_image(img[0])
  for v:Vector2i in land.get_used_cells():
    var td:TileData = land.get_cell_tile_data(v)
    var p:Vector2 = land.map_to_local(v) - Vector2(8, 8)
    if p.x >= 0 && p.x + 16 < W && p.y >= 0 && p.y + 16 < H:
      if td.terrain_set != 0 || td.terrain != 1:
        var ac:Vector2i = land.get_cell_atlas_coords(v)
        var ts:TileSetAtlasSource = land.tile_set.get_source(land.get_cell_source_id(v))
        var t:Texture2D = ts.texture
        var r:Rect2i = ts.get_tile_texture_region(ac)
        var src:Image = t.get_image();
        # todo: find better way...maybe make water transparent and blit a red image with mask
        for x in range(0, r.size.x):
          for y in range(0, r.size.y):
            var c:Color = src.get_pixel(x + r.position.x, y + r.position.y)
            if c != Color.BLUE:
              img[0].set_pixel(x + p.x, y + p.y, Color.RED)
    #img[0].fill_rect(Rect2i(p, ST), Color.RED)
  img[1].copy_from(img[0])

func clean(pos:Vector2, radius:float)->float:
  var v = pos.snapped(SV) - Vector2(8, 8)
  img[idx].fill_rect(Rect2i(v, SV * 4), Color.BLUE)
  return 0;


func _process(delta: float) -> void:
  if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
    var v:Vector2 = get_viewport().get_mouse_position()
    v = v.snapped(SV)
    img[idx].fill_rect(Rect2i(v, SV), Color(0, 1.0, 0, 1))

  update_sim()
  texture.update(img[idx])

func spread(src:Image, img:Image, pos:Vector2i):
  var a:float = 0.0
  for d:Vector2i in DIRS:
    var v = pos + d
    if v.x >= 0 && v.x < W && v.y >=0 && v.y < H:
      var p = src.get_pixelv(v)
      var s = (100.0 if d.x == 0 || d.y == 0 else 200.0) - randf_range(0.0, 80)
      a += p.g / s
  if a > 0.0:
    img.fill_rect(Rect2i(pos, SV), Color(0, a, 0, 1))

func update_sim():
  var src:Image = img[idx]
  idx = (idx + 1) % 2
  var dst:Image = img[idx]
  dst.copy_from(src)
  for y:int in range(0, H, S):
    for x:int in range(0, W, S):
      var v:Vector2i = Vector2i(x, y)
      var p:Color = src.get_pixelv(v)
      if p.g == 0.0 && p.r == 0.0 && p.b == 0:
        spread(src, dst, v)
  for y:int in range(0, H, S):
    for x:int in range(0, W, S):
      var v:Vector2i = Vector2i(x, y)
      var p:Color = dst.get_pixelv(v)
      if p.g > 0.0 && p.g < 1.0:
        p.g = min(p.g + 1.0/GROW_STEPS, 1.0)
        dst.fill_rect(Rect2i(v, SV), p)
      elif p.b > 0.0:
        p.b = max(p.b - 1.0/GROW_STEPS, 0.0)
        dst.fill_rect(Rect2i(v, SV), p)
