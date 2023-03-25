@tool
extends EditorPlugin


func _enable_plugin():
	print(_find_term_emulator())
	_dump_config()
	_apply_vim_config()
	get_editor_interface().get_editor_settings().add_property_info({
		name = "text_editor/external/exec_flags",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_NONE,
		hint_string = "Change first argument with a name of your terminal emulator."
	})
	return


func _disable_plugin():
	_load_config()
	get_editor_interface().get_editor_settings().add_property_info({
		name = "text_editor/external/exec_flags",
		type = TYPE_STRING,
		hint_string = ""
	})
	get_editor_interface().get_editor_settings().set_setting("text_editor/external/terminal_emulator", null)
	return


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


func _find_term_emulator():
	var emulators = [
	"gnome-terminal",
	"alacritty",
	"xfce4-terminal",
	"kitty",
	"konsole",
	"mate-terminal",
	"terminator",
	"termite",
	"st",
	"urxvt",
	"lxterminal",
	"guake",
	"tilix",
	"cool-retro-term",
	"xterm",
	"qterminal",
	"tilda",
	]
	for i in emulators:
		var found = []
		if OS.execute("which", [i], found) == 0:
			return found[0].strip_edges()
	return "xterm"
