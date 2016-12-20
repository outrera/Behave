tool

extends PopupPanel

signal tree_node_selected(instance)

var instance_cache = {}
var utils = preload("res://addons/Behave/Editor/Scripts/utils.gd").new()

onready var NODE_TYPES = {
	"Composite" : utils.load_tree_nodes("res://addons/Behave/Editor/Scenes/Composite/"),
	"Flow":  utils.load_tree_nodes("res://addons/Behave/Editor/Scenes/Composite/")
}

var initialized = false

onready var tree = get_node("Tree")

func _ready():
	if not initialized:
		var root = tree.create_item()
		tree.set_hide_root(true)
		for type in NODE_TYPES:
			var item = tree.create_item(root)
			item.set_text(0, type)
			item.set_selectable(0, false)
			var tree_nodes = NODE_TYPES[type]
			for n in tree_nodes:
				var node_instance = n.instance()
				var node_item_name = node_instance.get_name().replace("Node.tscn", "")
				var node_item = tree.create_item(item)
				node_item.set_text(0, node_item_name)
				instance_cache[node_item_name] = node_instance
		tree.connect("item_selected", self, "_on_item_selected")
		initialized = true
	
func _on_item_selected():
	var item = tree.get_selected()
	var item_name = item.get_text(0)
	emit_signal("tree_node_selected", instance_cache[item_name])