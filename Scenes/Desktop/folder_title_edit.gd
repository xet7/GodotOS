extends TextEdit

func _input(event: InputEvent):
	if event.is_action_pressed("rename") and $"../../../Selected Highlight".visible:
		get_parent().visible = true
		grab_focus()
	
	if !get_parent().visible:
		return
	
	if event.is_action_pressed("ui_accept"):
		get_parent().visible = false
		#TODO stop file from adding periods
		var folder: FakeFolder = $"../../.."
		if folder.file_type != folder.file_type_enum.FOLDER:
			var old_folder_name: String = folder.folder_name
			folder.folder_name = "%s.%s" % [text, folder.folder_name.split('.')[-1]]
			DirAccess.rename_absolute("user://files/%s/%s" % [folder.folder_path, old_folder_name], "user://files/%s/%s" % [folder.folder_path, folder.folder_name])
			%"Folder Title".text = "[center]%s" % folder.folder_name
			
			# Reloads open windows
			for file_manager in get_tree().get_nodes_in_group("file_manager_window"):
				file_manager.reload_window("")
			for text_editor in get_tree().get_nodes_in_group("text_editor_window"):
				if text_editor.file_path == "%s/%s" % [folder.folder_path, old_folder_name]:
					text_editor.file_path = "%s/%s" % [folder.folder_path, folder.folder_name]
				elif text_editor.file_path == old_folder_name: # In desktop
					text_editor.file_path = folder.folder_name 
		
		elif folder.file_type == folder.file_type_enum.FOLDER:
			var old_folder_name: String = folder.folder_name
			var old_folder_path: String = folder.folder_path
			
			if old_folder_path.contains("/"):
				folder.folder_path = "%s%s" % [folder.folder_path.trim_suffix(old_folder_name), text]
			else:
				folder.folder_path = text
			folder.folder_name = text
			%"Folder Title".text = "[center]%s" % folder.folder_name
			DirAccess.rename_absolute("user://files/%s" % old_folder_path, "user://files/%s" % folder.folder_path)
			
			for file_manager in get_tree().get_nodes_in_group("file_manager_window"):
				file_manager.reload_window("")
		
		text = ""
	
	if event.is_action_pressed("ui_cancel"):
		get_parent().visible = false
		text = ""
