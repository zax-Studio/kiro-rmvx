#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  After defining each class, actual processing begins here.
#==============================================================================



#Fuente por defecto usada por el juego 
Font.default_name = "Calling Code"
#Tamaño de la fuente
Font.default_size = 18

begin
  Graphics.freeze
  $scene = Scene_Title.new
  $scene.main while $scene != nil
  Graphics.transition(30)
rescue Errno::ENOENT
  filename = $!.message.sub("No such file or directory - ", "")
  print("Unable to find file #{filename}.")
end
