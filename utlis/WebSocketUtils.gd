extends Node

	
#Returns locally loaded JWT token
func load_token():
	var token_file = File.new()
	if not token_file.file_exists("user://token.jwt"):
		printerr("Could not find JWT token, note: This application requires 3rd party cookies to be enabled")
		# TODO Return to login screen
		return # Error! We don't have a save to load.
	token_file.open("user://token.jwt", File.READ)
	return token_file.get_line()

#Encodes Data when passingto server
func encode_data(data, mode):
	if mode == WebSocketPeer.WRITE_MODE_TEXT:
		return data.to_utf8()
	return var2bytes(data)

#Decodes data retrieved from server
func decode_data(data, is_string):
	if is_string:
		return data.get_string_from_utf8()
	return bytes2var(data)

