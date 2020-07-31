#==============================================================================
# PRCoders - Module
#==============================================================================
# RPGVX 
#==============================================================================

module PRCoders
  
  SCRIPTS = {}
  LOADED_SCRIPTS = {}
  AUTHORS = {}
  @@scripts_counter = 0
  @@loaded_scripts_counter = 0

  #--------------------------------------------------------------------------
  # Adiciona o script na lista dos scripts
  #--------------------------------------------------------------------------
  
  def self.log_script(script_name, version = 1.0, author = "PRCoders")
    key = [script_name, version]
    SCRIPTS[key] = true
    key = [script_name, nil]
    unless SCRIPTS[key]
      SCRIPTS[key] = true
      @@scripts_counter += 1
    end
    return if author.nil?
    AUTHORS[script_name] ||= []
    AUTHORS[script_name].push(author) unless AUTHORS[script_name].include?(author)
  end
  
  #--------------------------------------------------------------------------
  # Adiciona o script na lista dos scripts carregados
  #--------------------------------------------------------------------------
  
  def self.load_script(script_name, version = 1.0, author = "PRCoders")
    key = [script_name, version]
    if SCRIPTS[key].nil?
      message = "Nao foi encontrado o seguinte script: \nNome: #{script_name} \nVersao:#{version}"
      self.call_message(message, "PR Coders", 48)
      exit
    end
    LOADED_SCRIPTS[key] = true
    key = [script_name, nil]
    unless LOADED_SCRIPTS[key]
      LOADED_SCRIPTS[key] = true
      @@loaded_scripts_counter += 1
    end
  end    
  
  #--------------------------------------------------------------------------
  # Verifica se pode carregar o script
  #--------------------------------------------------------------------------
  
  def self.check_enabled?(script_name, version = nil)
    return (self.logged_script?(script_name, version) and (!self.loaded_script?(script_name, version)))
  end
  
  #--------------------------------------------------------------------------
  # Verifica se está carregado e adicionado na lista
  #--------------------------------------------------------------------------
  
  def self.logged_and_loaded?(script_name, version = nil)
    return (self.logged_script?(script_name, version) and self.loaded_script?(script_name, version))
  end
  
  #--------------------------------------------------------------------------
  # Verifica se está carregado
  #--------------------------------------------------------------------------
  
  def self.loaded_script?(script_name, version = nil)
    key = [script_name, version]
    return LOADED_SCRIPTS[key]
  end
  
  #--------------------------------------------------------------------------
  # Verifica se está adicionado na lista
  #--------------------------------------------------------------------------
  
  def self.logged_script?(script_name, version = nil)
    key = [script_name, version]
    return SCRIPTS[key]
  end
  
  #--------------------------------------------------------------------------
  # Pega o Nome do jogo
  #--------------------------------------------------------------------------
  
  def self.game_name
    name = "\0" * 256
    Win32API.new("kernel32", "GetPrivateProfileStringA", "ppppip", "i").call("Game", "Title", "", name, 255, ".\\Game.ini")
    name.delete!("\0")
    return name
  end
  
  #--------------------------------------------------------------------------
  # Pega o Nome da dll do jogo
  #--------------------------------------------------------------------------
  
  def self.game_dll
    library = "\0" * 256
    Win32API.new("kernel32", "GetPrivateProfileStringA", "ppppip", "i").call("Game", "Library", "", library, 255, ".\\Game.ini")
    library.delete!("\0")
    return library
  end
  
  #--------------------------------------------------------------------------
  # Pega o Nome do RTP do jogo
  #--------------------------------------------------------------------------
  
  def self.game_rtp
    rtp = "\0" * 256
    Win32API.new("kernel32", "GetPrivateProfileStringA", "ppppip", "i").call("Game", "RTP", "", rtp, 255, ".\\Game.ini")
    rtp.delete!("\0")
    return rtp
  end
  
  #--------------------------------------------------------------------------
  # Pega a ID da janela do jogo
  #--------------------------------------------------------------------------
  
  def self.handel
    return Win32API.new("user32", "FindWindowA", "pp", "i").call("RGSS Player", self.game_name)
  end
  
  #--------------------------------------------------------------------------
  # Chama uma mensagem
  #--------------------------------------------------------------------------
  
  def self.call_message(message, title, id=0)
    return Win32API.new("user32", "MessageBoxEx", "ippii", "i").call(self.handel, message, title, id, 0)
  end
  
  #--------------------------------------------------------------------------
  # Chama uma mensagem
  #--------------------------------------------------------------------------
  
  def self.data_folder
    return ENV["TEMP"] + "\\PRCoders\\#{self.game_name}"
  end
  
  #--------------------------------------------------------------------------
  # Chama uma mensagem
  #--------------------------------------------------------------------------
  
  def self.data_filename
    return ENV["TEMP"] + "\\PRCoders\\#{self.game_name}\\Data"
  end

  #--------------------------------------------------------------------------
  # Cria os créditos
  #--------------------------------------------------------------------------
  
  def self.create_credits(filename = "PRScripts.txt")
    File.open(filename, "wb") {|file|
      writed = []
      counter = 0
      message =  "============================================\r\n"
      message += " Scripts utilizando o módulo PRCoders\r\n"
      message += " Total:      #{@@scripts_counter}\r\n"
      message += " Utilizados: #{@@loaded_scripts_counter}\r\n"
      message += "============================================\r\n"
      file.write(message)
      for name, enabled in SCRIPTS
        next if name[1].nil?
        next if writed.include?(name)
        writed.push(name)
        counter += 1
        message =  "============================================\r\n"
        message += " - Script #{counter}\r\n"
        message += "--------------------------------------------\r\n"
        message += "Nome: #{name[0]}\r\n"
        message += "Versão: #{name[1]}\r\n"
        authors = AUTHORS[name]
        if authors.nil?
          authors = ["PRCoders"]
        end
        for item in authors
          item.gsub!(/[Pp][Rr][Cc][Oo][Dd][Ee][Rr][Ss]/) {
            "PRCoders (PHCDO e RTH)"
          }
        end
        if authors.size == 1
          message += "Criador: #{authors[0]}\r\n"
        else
          message += "Criadores: "
          for author in authors
            message += "#{author}\r\n         "
          end
        end
        file.write(message)
      end
    }
  end
    
end

#===============================================================================
# - Classe Win32::Registry 
# ------------------------------------------------------------------------------
# Retirado do Ruby.
#===============================================================================

module Win32
  class Registry
    module Constants
      HKEY_CLASSES_ROOT = 0x80000000
      HKEY_CURRENT_USER = 0x80000001
      HKEY_LOCAL_MACHINE = 0x80000002
      HKEY_USERS = 0x80000003
      HKEY_PERFORMANCE_DATA = 0x80000004
      HKEY_PERFORMANCE_TEXT = 0x80000050
      HKEY_PERFORMANCE_NLSTEXT = 0x80000060
      HKEY_CURRENT_CONFIG = 0x80000005
      HKEY_DYN_DATA = 0x80000006
      
      REG_NONE = 0
      REG_SZ = 1
      REG_EXPAND_SZ = 2
      REG_BINARY = 3
      REG_DWORD = 4
      REG_DWORD_LITTLE_ENDIAN = 4
      REG_DWORD_BIG_ENDIAN = 5
      REG_LINK = 6
      REG_MULTI_SZ = 7
      REG_RESOURCE_LIST = 8
      REG_FULL_RESOURCE_DESCRIPTOR = 9
      REG_RESOURCE_REQUIREMENTS_LIST = 10
      REG_QWORD = 11
      REG_QWORD_LITTLE_ENDIAN = 11
      
      STANDARD_RIGHTS_READ = 0x00020000
      STANDARD_RIGHTS_WRITE = 0x00020000
      KEY_QUERY_VALUE = 0x0001
      KEY_SET_VALUE = 0x0002
      KEY_CREATE_SUB_KEY = 0x0004
      KEY_ENUMERATE_SUB_KEYS = 0x0008
      KEY_NOTIFY = 0x0010
      KEY_CREATE_LINK = 0x0020
      KEY_READ = STANDARD_RIGHTS_READ |
        KEY_QUERY_VALUE | KEY_ENUMERATE_SUB_KEYS | KEY_NOTIFY
      KEY_WRITE = STANDARD_RIGHTS_WRITE |
        KEY_SET_VALUE | KEY_CREATE_SUB_KEY
      KEY_EXECUTE = KEY_READ
      KEY_ALL_ACCESS = KEY_READ | KEY_WRITE | KEY_CREATE_LINK
      
      REG_OPTION_RESERVED = 0x0000
      REG_OPTION_NON_VOLATILE = 0x0000
      REG_OPTION_VOLATILE = 0x0001
      REG_OPTION_CREATE_LINK = 0x0002
      REG_OPTION_BACKUP_RESTORE = 0x0004
      REG_OPTION_OPEN_LINK = 0x0008
      REG_LEGAL_OPTION = REG_OPTION_RESERVED |
        REG_OPTION_NON_VOLATILE | REG_OPTION_CREATE_LINK |
        REG_OPTION_BACKUP_RESTORE | REG_OPTION_OPEN_LINK
      
      REG_CREATED_NEW_KEY = 1
      REG_OPENED_EXISTING_KEY = 2
      
      REG_WHOLE_HIVE_VOLATILE = 0x0001
      REG_REFRESH_HIVE = 0x0002
      REG_NO_LAZY_FLUSH = 0x0004
      REG_FORCE_RESTORE = 0x0008
      
      MAX_KEY_LENGTH = 514
      MAX_VALUE_LENGTH = 32768
    end
    include Constants
    include Enumerable
    
    #
    # Error
    #
    class Error < ::StandardError
      FormatMessageA = Win32API.new('kernel32.dll', 'FormatMessageA', 'LPLLPLP', 'L')
      def initialize(code)
        @code = code
        msg = "\0" * 1024
        len = FormatMessageA.call(0x1200, 0, code, 0, msg, 1024, 0)
        super msg[0, len].tr("\r", '').chomp
      end
      attr_reader :code
    end
    
    #
    # Predefined Keys
    #
    class PredefinedKey < Registry
      def initialize(hkey, keyname)
        @hkey = hkey
        @parent = nil
        @keyname = keyname
        @disposition = REG_OPENED_EXISTING_KEY
      end
      
      # Predefined keys cannot be closed
      def close
        raise Error.new(5) ## ERROR_ACCESS_DENIED
      end
      
      # Fake class for Registry#open, Registry#create
      def class
        Registry
      end
      
      # Make all
      Constants.constants.grep(/^HKEY_/) do |c|
        Registry.const_set c, new(Constants.const_get(c), c)
      end
    end
    
    #
    # Win32 APIs
    #
    module API
      [
        %w/RegOpenKeyExA    LPLLP        L/,
        %w/RegCreateKeyExA  LPLLLLPPP    L/,
        %w/RegEnumValueA    LLPPPPPP     L/,
        %w/RegEnumKeyExA    LLPPLLLP     L/,
        %w/RegQueryValueExA LPLPPP       L/,
        %w/RegSetValueExA   LPLLPL       L/,
        %w/RegDeleteValue   LP           L/,
        %w/RegDeleteKey     LP           L/,
        %w/RegFlushKey      L            L/,
        %w/RegCloseKey      L            L/,
        %w/RegQueryInfoKey  LPPPPPPPPPPP L/,
      ].each do |fn|
        const_set fn[0].intern, Win32API.new('advapi32.dll', *fn)
      end
      
      module_function
      
      def check(result)
        raise Error, result, caller(2) if result != 0
      end
      
      def packdw(dw)
        [dw].pack('V')
      end
      
      def unpackdw(dw)
        dw += [0].pack('V')
        dw.unpack('V')[0]
      end
      
      def packqw(qw)
        [ qw & 0xFFFFFFFF, qw >> 32 ].pack('VV')
      end
      
      def unpackqw(qw)
        qw = qw.unpack('VV')
        (qw[1] << 32) | qw[0]
      end
      
      def OpenKey(hkey, name, opt, desired)
        result = packdw(0)
        check RegOpenKeyExA.call(hkey, name, opt, desired, result)
        unpackdw(result)
      end
      
      def CreateKey(hkey, name, opt, desired)
        result = packdw(0)
        disp = packdw(0)
        check RegCreateKeyExA.call(hkey, name, 0, 0, opt, desired,
                                   0, result, disp)
        [ unpackdw(result), unpackdw(disp) ]
      end
      
      def EnumValue(hkey, index)
        name = ' ' * Constants::MAX_KEY_LENGTH
        size = packdw(Constants::MAX_KEY_LENGTH)
        check RegEnumValueA.call(hkey, index, name, size, 0, 0, 0, 0)
        name[0, unpackdw(size)]
      end
      
      def EnumKey(hkey, index)
        name = ' ' * Constants::MAX_KEY_LENGTH
        size = packdw(Constants::MAX_KEY_LENGTH)
        wtime = ' ' * 8
        check RegEnumKeyExA.call(hkey, index, name, size, 0, 0, 0, wtime)
        [ name[0, unpackdw(size)], unpackqw(wtime) ]
      end
      
      def QueryValue(hkey, name)
        type = packdw(0)
        size = packdw(0)
        check RegQueryValueExA.call(hkey, name, 0, type, 0, size)
        data = ' ' * unpackdw(size)
        check RegQueryValueExA.call(hkey, name, 0, type, data, size)
        [ unpackdw(type), data[0, unpackdw(size)] ]
      end
      
      def SetValue(hkey, name, type, data, size)
        check RegSetValueExA.call(hkey, name, 0, type, data, size)
      end
      
      def DeleteValue(hkey, name)
        check RegDeleteValue.call(hkey, name)
      end
      
      def DeleteKey(hkey, name)
        check RegDeleteKey.call(hkey, name)
      end
      
      def FlushKey(hkey)
        check RegFlushKey.call(hkey)
      end
      
      def CloseKey(hkey)
        check RegCloseKey.call(hkey)
      end
      
      def QueryInfoKey(hkey)
        subkeys = packdw(0)
        maxsubkeylen = packdw(0)
        values = packdw(0)
        maxvaluenamelen = packdw(0)
        maxvaluelen = packdw(0)
        secdescs = packdw(0)
        wtime = ' ' * 8
        check RegQueryInfoKey.call(hkey, 0, 0, 0, subkeys, maxsubkeylen, 0,
          values, maxvaluenamelen, maxvaluelen, secdescs, wtime)
        [ unpackdw(subkeys), unpackdw(maxsubkeylen), unpackdw(values),
          unpackdw(maxvaluenamelen), unpackdw(maxvaluelen),
          unpackdw(secdescs), unpackqw(wtime) ]
      end
    end
    
    #
    # utility functions
    #
    def self.expand_environ(str)
      str.gsub(/%([^%]+)%/) { ENV[$1] || $& }
    end
    
    @@type2name = { }
    %w[
      REG_NONE REG_SZ REG_EXPAND_SZ REG_BINARY REG_DWORD
      REG_DWORD_BIG_ENDIAN REG_LINK REG_MULTI_SZ
      REG_RESOURCE_LIST REG_FULL_RESOURCE_DESCRIPTOR
      REG_RESOURCE_REQUIREMENTS_LIST REG_QWORD
    ].each do |type|
      @@type2name[Constants.const_get(type)] = type
    end
    
    def self.type2name(type)
      @@type2name[type] || type.to_s
    end
    
    def self.wtime2time(wtime)
      Time.at((wtime - 116444736000000000) / 10000000)
    end
    
    def self.time2wtime(time)
      time.to_i * 10000000 + 116444736000000000
    end
    
    #
    # constructors
    #
    private_class_method :new
    
    def self.open(hkey, subkey, desired = KEY_READ, opt = REG_OPTION_RESERVED)
      subkey = subkey.chomp('\\')
      newkey = API.OpenKey(hkey.hkey, subkey, opt, desired)
      obj = new(newkey, hkey, subkey, REG_OPENED_EXISTING_KEY)
      if block_given?
        begin
          yield obj
        ensure
          obj.close
        end
      else
        obj
      end
    end
    
    def self.create(hkey, subkey, desired = KEY_ALL_ACCESS, opt = REG_OPTION_RESERVED)
      newkey, disp = API.CreateKey(hkey.hkey, subkey, opt, desired)
      obj = new(newkey, hkey, subkey, disp)
      if block_given?
        begin
          yield obj
        ensure
          obj.close
        end
      else
        obj
      end
    end
    
    #
    # finalizer
    #
    @@final = proc { |hkey| proc { API.CloseKey(hkey[0]) if hkey[0] } }
    
    #
    # initialize
    #
    def initialize(hkey, parent, keyname, disposition)
      @hkey = hkey
      @parent = parent
      @keyname = keyname
      @disposition = disposition
      @hkeyfinal = [ hkey ]
      ObjectSpace.define_finalizer self, @@final.call(@hkeyfinal)
    end
    attr_reader :hkey, :parent, :keyname, :disposition
    
    #
    # attributes
    #
    def created?
      @disposition == REG_CREATED_NEW_KEY
    end
    
    def open?
      !@hkey.nil?
    end
    
    def name
      parent = self
      name = @keyname
      while parent = parent.parent
        name = parent.keyname + '\\' + name
      end
      name
    end
    
    def inspect
      "\#<Win32::Registry key=#{name.inspect}>"
    end
    
    #
    # marshalling
    #
    def _dump(depth)
      raise TypeError, "can't dump Win32::Registry"
    end
    
    #
    # open/close
    #
    def open(subkey, desired = KEY_READ, opt = REG_OPTION_RESERVED, &blk)
      self.class.open(self, subkey, desired, opt, &blk)
    end
    
    def create(subkey, desired = KEY_ALL_ACCESS, opt = REG_OPTION_RESERVED, &blk)
      self.class.create(self, subkey, desired, opt, &blk)
    end
    
    def close
      API.CloseKey(@hkey)
      @hkey = @parent = @keyname = nil
      @hkeyfinal[0] = nil
    end
    
    #
    # iterator
    #
    def each_value
      index = 0
      while true
        begin
          subkey = API.EnumValue(@hkey, index)
        rescue Error
          break
        end
        begin
          type, data = read(subkey)
        rescue Error
          next
        end
        yield subkey, type, data
        index += 1
      end
      index
    end
    alias each each_value
    
    def each_key
      index = 0
      while true
        begin
          subkey, wtime = API.EnumKey(@hkey, index)
        rescue Error
          break
        end
        yield subkey, wtime
        index += 1
      end
      index
    end
    
    def keys
      keys_ary = []
      each_key { |key,| keys_ary << key }
      keys_ary
    end
    
    #
    # reader
    #
    def read(name, *rtype)
      type, data = API.QueryValue(@hkey, name)
      unless rtype.empty? or rtype.include?(type)
        raise TypeError, "Type mismatch (expect #{rtype.inspect} but #{type} present)"
      end
      case type
      when REG_SZ, REG_EXPAND_SZ
        [ type, data.chop ]
      when REG_MULTI_SZ
        [ type, data.split(/\0/) ]
      when REG_BINARY
        [ type, data ]
      when REG_DWORD
        [ type, API.unpackdw(data) ]
      when REG_DWORD_BIG_ENDIAN
        [ type, data.unpack('N')[0] ]
      when REG_QWORD
        [ type, API.unpackqw(data) ]
      else
        raise TypeError, "Type #{type} is not supported."
      end
    end
    
    def [](name, *rtype)
      type, data = read(name, *rtype)
      case type
      when REG_SZ, REG_DWORD, REG_QWORD, REG_MULTI_SZ
        data
      when REG_EXPAND_SZ
        Registry.expand_environ(data)
      else
        raise TypeError, "Type #{type} is not supported."
      end
    end
    
    def read_s(name)
      read(name, REG_SZ)[1]
    end
    
    def read_s_expand(name)
      type, data = read(name, REG_SZ, REG_EXPAND_SZ)
      if type == REG_EXPAND_SZ
        Registry.expand_environ(data)
      else
        data
      end
    end
    
    def read_i(name)
      read(name, REG_DWORD, REG_DWORD_BIG_ENDIAN, REG_QWORD)[1]
    end
    
    def read_bin(name)
      read(name, REG_BINARY)[1]
    end
    
    #
    # writer
    #
    def write(name, type, data)
      case type
      when REG_SZ, REG_EXPAND_SZ
        data = data.to_s + "\0"
      when REG_MULTI_SZ
        data = data.to_a.join("\0") + "\0\0"
      when REG_BINARY
        data = data.to_s
      when REG_DWORD
        data = API.packdw(data.to_i)
      when REG_DWORD_BIG_ENDIAN
        data = [data.to_i].pack('N')
      when REG_QWORD
        data = API.packqw(data.to_i)
      else
        raise TypeError, "Unsupported type #{type}"
      end
      API.SetValue(@hkey, name, type, data, data.length)
    end
    
    def []=(name, rtype, value = nil)
      if value
        write name, rtype, value
      else
        case value = rtype
        when Integer
          write name, REG_DWORD, value
        when String
          write name, REG_SZ, value
        when Array
          write name, REG_MULTI_SZ, value
        else
          raise TypeError, "Unexpected type #{value.class}"
        end
      end
      value
    end
    
    def write_s(name, value)
      write name, REG_SZ, value.to_s
    end
    
    def write_i(name, value)
      write name, REG_DWORD, value.to_i
    end
    
    def write_bin(name, value)
      write name, REG_BINARY, value.to_s
    end
    
    #
    # delete
    #
    def delete_value(name)
      API.DeleteValue(@hkey, name)
    end
    alias delete delete_value
    
    def delete_key(name, recursive = false)
      if recursive
        open(name, KEY_ALL_ACCESS) do |reg|
          reg.keys.each do |key|
            begin
              reg.delete_key(key, true)
            rescue Error
              #
            end
          end
        end
        API.DeleteKey(@hkey, name)
      else
        begin
          API.EnumKey @hkey, 0
        rescue Error
          return API.DeleteKey(@hkey, name)
        end
        raise Error.new(5) ## ERROR_ACCESS_DENIED
      end
    end
    
    #
    # flush
    #
    def flush
      API.FlushKey @hkey
    end
    
    #
    # key information
    #
    def info
      API.QueryInfoKey(@hkey)
    end
    %w[
      num_keys max_key_length
      num_values max_value_name_length max_value_length
      descriptor_length wtime
    ].each_with_index do |s, i|
      eval <<-__END__
        def #{s}
          info[#{i}]
        end
      __END__
    end
  end
  
end
  
#==============================================================================
# FileRTPTest - Módulo
#==============================================================================

module RTP
  
  RTP_PATHS = []
  
  def self.paths
    return RTP_PATHS
  end
  
  def self.exist?(name)
    for rtp in RTP_PATHS
      if FileTest.exist?(rtp + "/" + name)
        return true
      end
    end
    return false
  end
  
  def self.files(diretorio)
    files = []
    for rtp in RTP_PATHS
      files += Dir.dirfiles(rtp + "/" + diretorio)
    end
    return files
  end
  
  def self.all_exist?(name)
    for rtp in RTP_PATHS
      if FileTest.exist?(rtp + "/" + name)
        return true
      end
    end
    return FileTest.exist?(name)
  end
      
end

class Bitmap
  
  def draw_stroked_text(*args)
    case args[0]
    when Rect
      x = args[0].x
      y = args[0].y
      w = args[0].width
      h = args[0].height
      text = args[1]
      align = (args[2].nil? ? 0 : args[2])
    when Numeric
      x, y, w, h = args[0..3]
      text = args[4]
      align = (args[5].nil? ? 0 : args[5])
    else
      return
    end
    color = self.font.color.dup
    self.font.color.set(0, 0, 0)
    draw_text(x, y, w - 2, h - 2, text, align)
    draw_text(x + 2, y, w - 2, h - 2, text, align)
    draw_text(x, y + 2, w - 2, h - 2, text, align)
    draw_text(x + 2, y + 2, w - 2, h - 2, text, align)
    self.font.color = color
    draw_text(x + 1, y + 1, w - 2, h - 2, text, align)
  end
      
  #-------------------------------------------------------------------------
  # Grava o Bitmap em um arquivo
  #-------------------------------------------------------------------------
  
  def save_png(name = "", path = "./", mode = 0)
    File.open(path + name + ".png", "wb") {|f| f.write("\211PNG\r\n\032\n" + png_ihdr + png_idat + png_iend) }
  end
    
  #--------------------------------------------------------------------------
  # - Pega o IHDR do PNG
  #--------------------------------------------------------------------------
    
  def png_ihdr
    string = "IHDR" + [self.width].pack("N") + [self.height].pack("N") + "\010\006\000\000\000"
    ih_crc = [Zlib.crc32(string)].pack("N")
    return "\000\000\000\r" + string + [Zlib.crc32(string)].pack("N")
  end
  
  #--------------------------------------------------------------------------
  # - Pega a Data do PNG
  #--------------------------------------------------------------------------
    
  def png_idat
    data = Zlib::Deflate.deflate(make_png_data, 8)
    return [data.length].pack("N") + "\x49\x44\x41\x54" + data + [Zlib.crc32("\x49\x44\x41\x54" + data)].pack("N")
  end
  
  #--------------------------------------------------------------------------
  # - Pega a Data dos pixels do PNG
  #--------------------------------------------------------------------------
    
  def make_png_data
    w = self.width
    h = self.height
    data = []
    for y in 0...h
      data.push(0)
      for x in 0...w
        color = self.get_pixel(x, y)
        data.push(color.red, color.green, color.blue, color.alpha)
      end
    end
    string = data.pack("C*")
    data.clear
    return string
  end
  
  #--------------------------------------------------------------------------
  # - Pega o Final do PNG
  #--------------------------------------------------------------------------
  
  def png_iend
    return "\000\000\000\000IEND" + [Zlib.crc32("IEND")].pack('N')
  end
    
end

#===============================================================================
# FILETEST_FIX
#===============================================================================

module FILETEST_FIX
  
  FILENAME = "Folders.dll"
  
  FOLDERS_TO_CATCH = ["Data", "Graphics"]
  
  @@data = {}
  
  def self.start_dump
    for folder in FOLDERS_TO_CATCH
      self.catch_files(folder)
    end
    file = File.open(FILENAME, "wb")
    Marshal.dump(@@data, file)
    file.close
  end
  
  def self.load_data
    file = File.open(FILENAME, "rb")
    @@data = Marshal.load(file)
    file.close
  end
    
  def self.catch_files(directory=".")
    unless ["/", "\\"].include?(directory[directory.size-1, 1])
      directory += "/"
    end
    directory.gsub!("/", "\\")
    return [] unless FileTest.directory?(directory)
    @@data[directory] = []
    for file in Dir.entries(directory)
      next if file == "."
      next if file == ".."
      if FileTest.directory?(directory + file)
        self.catch_files(directory + file)
      end
      @@data[directory].push(directory + file)
    end
    @@data[directory].push(directory + ".")
    @@data[directory].push(directory + "..")
  end
  
  def self.entries(directory)
    unless ["/", "\\"].include?(directory[directory.size-1, 1])
      directory += "/"
    end
    directory.gsub!("/", "\\")
    return @@data[directory].dup
  end
  
  def self.data
    return @@data
  end
  
end


if $TEST
  FILETEST_FIX.start_dump
else
  FILETEST_FIX.load_data
end

class Dir
  
  class << self
    unless method_defined?("dir_fix_dir_entries")
      alias dir_fix_dir_entries entries
    end
  end
  
  def self.entries(directory, corrected=true)
    data_entries = []
    unless $TEST
      if corrected
        data_entries = self.encripted_entries(directory)
      end
    end
    data_entries ||= []
    if FileTest.directory?(directory, false)
      data_entries = data_entries + dir_fix_dir_entries(directory)
    end
    return data_entries
  end
  
  def self.encripted_entries(directory)
    if $TEST
      return []
    end
    unless ["/", "\\"].include?(directory[directory.size-1, 1])
      directory += "/"
    end
    if ["/", "\\"].include?(directory[0, 1])
      directory = "." + directory
    elsif !(["./", ".\\"].include?(directory[0, 2]))
      directory = "./" + directory
    end          
    directory.gsub!("/", "\\")
    data_entries = FILETEST_FIX.data[directory]
  end
  
end

module FileTest
  
  class << self
    unless method_defined?("dir_fix_filetext_exist?")
      alias dir_fix_filetext_exist? exist?
      alias dir_fix_filetext_directory? directory?
    end
  end
  
  def self.exist?(filename, corrected=true)
    if corrected
      unless $TEST
        directory = File.dirname(filename)
        filebase = File.basename(filename)
        unless ["/", "\\"].include?(directory[directory.size-1, 1])
          directory += "/"
        end
        if ["/", "\\"].include?(directory[0, 1])
          directory = "." + directory
        elsif !(["./", ".\\"].include?(directory[0, 2]))
          directory = "./" + directory
        end          
        directory.gsub!("/", "\\")
        data_entries = FILETEST_FIX.data[directory]
        data_entries ||= []
        for file in data_entries
          next if file.nil?
          if File.basename(file) == filebase
            return true
          end
        end
      end
    end
    return self.dir_fix_filetext_exist?(filename)
  end
  
  def self.directory?(directory, corrected=true)
    if corrected
      return true if self.encripted_directory?(directory)
    end
    return self.dir_fix_filetext_directory?(directory)
  end
  
  def self.encripted_directory?(directory)
    if $TEST
      return false
    end
    unless ["/", "\\"].include?(directory[directory.size-1, 1])
      directory += "/"
    end
    if ["/", "\\"].include?(directory[0, 1])
      directory = "." + directory
    elsif !(["./", ".\\"].include?(directory[0, 2]))
      directory = "./" + directory
    end          
    directory.gsub!("/", "\\")
    if FILETEST_FIX.data[directory] != nil
      return true
    end
  end
  
end

PRCODERS_MODULE = true