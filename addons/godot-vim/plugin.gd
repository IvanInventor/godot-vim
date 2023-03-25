@tool
extends EditorPlugin


func _enable_plugin():
	_dump_config()
	_apply_vim_config()
	pass


func _disable_plugin():
	_load_config()
	pass


func _dump_config():
	if not FileAccess.file_exists("res://addons/godot-vim/old_config.cfg"):
		var file = FileAccess.open("res://addons/godot-vim/old_config.cfg", FileAccess.WRITE)
		var cfg = {
			enabled = get_editor_interface().get_editor_settings().get_setting("text_editor/external/use_external_editor"),
			exec_path = get_editor_interface().get_editor_settings().get_setting("text_editor/external/exec_path"),
			exec_flags = get_editor_interface().get_editor_settings().get_setting("text_editor/external/exec_flags"),
		}
		file.store_line(JSON.stringify(cfg, "\n"))

func _load_config():
	if FileAccess.file_exists("res://addons/godot-vim/old_config.cfg"):
		var file = FileAccess.open("res://addons/godot-vim/old_config.cfg", FileAccess.READ)
		var cfg = JSON.parse_string(file.get_as_text())
		get_editor_interface().get_editor_settings().set_setting("text_editor/external/use_external_editor", cfg.enabled)
		get_editor_interface().get_editor_settings().set_setting("text_editor/external/exec_path", cfg.exec_path)
		get_editor_interface().get_editor_settings().set_setting("text_editor/external/exec_flags", cfg.exec_flags)
		file.close()
		DirAccess.open("res://addons/godot-vim").remove("old_config.cfg")


func _apply_vim_config():
	get_editor_interface().get_editor_settings().set_setting("text_editor/external/use_external_editor", true)
	get_editor_interface().get_editor_settings().set_setting("text_editor/external/exec_path", ProjectSettings.globalize_path("res://addons/godot-vim/godot-vim.sh"))
	get_editor_interface().get_editor_settings().set_setting("text_editor/external/exec_flags", "\"{project}\" \"{file}\" {line} {col}")


