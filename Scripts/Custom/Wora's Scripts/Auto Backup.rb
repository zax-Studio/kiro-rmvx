#===============================================================
# ● [XP/VX] ◦ Auto Backup ◦ □
#--------------------------------------------------------------
# ◦ by Woratana [woratana@hotmail.com]
# ◦ Thaiware RPG Maker Community
# ◦ Released on: 07/12/2008
# ◦ Version: 1.0
#--------------------------------------------------------------
# ◦ Features:
# - Automatically backup your rx/rvdata files when you run the game.
#--------------------------------------------------------------
# ◦ How to use:
# - Setup the script below,
# - You may want to run your game now to backup data files the first time.
#--------------------------------------------------------------

module WData_Backup
  
  BACKUP_WHEN_TEST = true # (true/false) Do you want to backup data files only
  # when running game through editor (When you press F12 in editor) ?
  BACKUP_REPORT = false # (true/false) Show textbox when backup process finish?
  DIRNAME = 'Backup_Data' # Name of the backup folder
  # (Script will automatically create folder if it doesn't exist)

SCRIPT = <<_SCRIPT_
    if (BACKUP_WHEN_TEST && #{defined?(Graphics.wait) ? '$TEST' : '$DEBUG'}) ||
    !BACKUP_WHEN_TEST
      time = Time.now
      Dir.mkdir(DIRNAME) unless File.directory?(DIRNAME) 
      ftype = "#{defined?(Graphics.wait) ? 'rvdata' : 'rxdata'}"
      flist = Dir.glob('./Data/*.{' + ftype + '}')
      flist.each_index do |i|
        flist[i] = flist[i].split('/').last
        save_data(load_data('Data/' + flist[i]), DIRNAME + '/' + flist[i])
      end
      p('Backup Finished!: ' + (Time.now - time).to_s + ' sec') if BACKUP_REPORT
    end
_SCRIPT_

  eval(SCRIPT) unless $@
end