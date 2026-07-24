class_name ManualPage extends Node

@export var text : String
@export var type : PageType = PageType.PAGE

## [b]PAGE[/b] = Page normale[nl][br]
## [b]BEGINNING_FRONT_COVER[/b] = Recto de la couverture[br]
## [b]BEGINNING_BACK_COVER[/b] = Verso de la couverture[br]
## [b]ENDING_FRONT_COVER[/b] = Recto de la 4ème de couverture[br]
## [b]ENDING_BACK_COVER[/b] = Verso de la 4ème de couverture[br]
enum PageType {PAGE, BEGINNING_FRONT_COVER, BEGINNING_BACK_COVER, ENDING_FRONT_COVER, ENDING_BACK_COVER}

const PAGE_SPRITE : Dictionary = {
	PageType.PAGE : {
		#Sprite
	},
	PageType.BEGINNING_FRONT_COVER: {
		#Sprite
	},
	PageType.BEGINNING_BACK_COVER: {
		#Sprite
	},
	PageType.ENDING_FRONT_COVER: {
		#Sprite
	},
	PageType.ENDING_BACK_COVER: {
		#Sprite
	}
}

@onready var sprite : Texture2D = PAGE_SPRITE[type]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
