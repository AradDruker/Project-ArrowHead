extends Node


var play_games_services


# Check if plugin was added to the project
func _ready():
	_init()
	_connect_signals()
	sign_in()

func _init() -> void:
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_games_services = Engine.get_singleton("GodotPlayGamesServices")
		
		var show_popups := true
		play_games_services.init(true,false,false,"")

func sign_in() -> void:
	play_games_services.signIn()


func _connect_signals() -> void:
	play_games_services.connect("_on_sign_in_success", self, "_on_sign_in_success")
	play_games_services.connect("_on_sign_in_failed", self, "_on_sign_in_failed")
##
## warning-ignore:unused_argument
#func _on_sign_in_success(account_id : String):
#	print("Successful sign in")
#
#
#func _on_sign_out_failed(error_code : int):
#	print("Failed to sign in with error code %s" % error_code)


