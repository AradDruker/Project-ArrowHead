extends Label

signal message_done


func _ready():
	self.visible_characters = 0


func _on_TypingTimer_timeout():
	if self.visible_characters < len(self.text):
		self.visible_characters += 1
	else:
		emit_signal("message_done")
