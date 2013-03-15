def load_spreadsheet_into_hash(spreadsheet_key = settings.google_drive["spreadsheet_key"], sheet = 0)
  gsession = GoogleDrive.login(settings.google_drive["login"],settings.google_drive["password"])
  worksheet = gsession.spreadsheet_by_key(spreadsheet_key).worksheets[sheet]
  worksheet.list.map {|row| row.to_hash}
end

def say_str(string_to_say, rate = settings.tropo_tts["rate"])
  if session[:channel] == "VOICE"
    "<speak><prosody rate='#{rate}'>#{string_to_say}</prosody></speak>"
  else
    string_to_say = string_to_say.gsub("Press","Text").gsub("press","text")
    string_to_say
  end
end
