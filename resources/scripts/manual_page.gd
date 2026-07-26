class_name ManualPage extends Resource

@export var text : String
@export var type : PageType = PageType.PAGE

## [b]PAGE[/b] = Page normale[nl][br]
## [b]BEGINNING_FRONT_COVER[/b] = Recto de la couverture[br]
## [b]BEGINNING_BACK_COVER[/b] = Verso de la couverture[br]
## [b]ENDING_FRONT_COVER[/b] = Recto de la 4ème de couverture[br]
## [b]ENDING_BACK_COVER[/b] = Verso de la 4ème de couverture[br]
enum PageType {PAGE, BEGINNING_FRONT_COVER, BEGINNING_BACK_COVER, ENDING_FRONT_COVER, ENDING_BACK_COVER}

const PAGE_SPRITE : Dictionary = {
	PageType.PAGE : preload("res://assets/images/placeholders/blankpage.png"),
	PageType.BEGINNING_FRONT_COVER: preload("res://assets/images/placeholders/front.png"),
	PageType.BEGINNING_BACK_COVER: null,
	PageType.ENDING_FRONT_COVER: preload("res://assets/images/placeholders/back.png"),
	PageType.ENDING_BACK_COVER: null
}

var sprite : Texture2D:
	get:
		return PAGE_SPRITE.get(type, null)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
