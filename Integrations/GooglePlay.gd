extends Node


var play_games_services = null

func _ready():
	_start_services()
	_connect_signals()

func _start_services() -> void:
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_games_services = Engine.get_singleton("GodotPlayGamesServices")
		
		play_games_services.init(true,false,false,"")
		sign_in()


func sign_in() -> void:
	if play_games_services:
		play_games_services.signIn()
		pass


func _connect_signals() -> void:
	if play_games_services:
		play_games_services.connect("_on_sign_in_success", self, "_on_sign_in_success")
		play_games_services.connect("_on_sign_in_failed", self, "_on_sign_in_failed")
		play_games_services.connect("_on_leaderboard_score_submitted", self, "_on_leaderboard_score_submitted")
		play_games_services.connect("_on_leaderboard_score_submitting_failed", self, "_on_leaderboard_score_submitting_failed")


func show_leaderboard():
	if play_games_services:
		play_games_services.showLeaderBoard("CgkIvLa__74fEAIQAA")
