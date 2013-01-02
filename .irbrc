# .irbrc
# vim: set syntax=ruby :
require 'irb/completion'
require 'irb/ext/save-history'
require 'fileutils'
require 'pp'
require 'rubygems'
require 'irb'

ARGV.concat [ "--readline",
  "--prompt-mode",
  "simple" ]

class Object
  def to_clipboard(msg = nil, &block)
    msg ||= block.call.to_s
    Kernel.open("|pbcopy", "w+") { |f| f.write msg } if msg && !msg.empty?
  end
end

# 25 entries in the list
IRB.conf[:SAVE_HISTORY] = 1000

# Store results in home directory with specified file name
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"


module IRB
  def IRB.start_with_binding binding
    IRB.setup __FILE__
    w = WorkSpace.new binding
    irb = Irb.new w
    @CONF[:MAIN_CONTEXT] = irb.context
    irb.eval_input
  end
end

## call me like this: breakpoint binding
def breakpoint binding; IRB.start_with_binding binding end

# Giles Bowkett, Greg Brown, and several audience members from Giles' Ruby East presentation.
# http://gilesbowkett.blogspot.com/2007/10/use-vi-or-any-text-editor-from-within.html
require 'tempfile'

module Exec
  extend self

  def system(file, *args)
    Kernel::system(file, *args)
  end
end

if RUBY_PLATFORM =~ /java/
  #http://github.com/headius/spoon
  require 'ffi'

  module Spoon
    extend FFI::Library
    ffi_lib 'c'

    # int
    # posix_spawn(pid_t *restrict pid, const char *restrict path,
    #     const posix_spawn_file_actions_t *file_actions,
    #     const posix_spawnattr_t *restrict attrp, char *const argv[restrict],
    #     char *const envp[restrict]);

    attach_function :_posix_spawn, :posix_spawn, [:pointer, :string, :pointer, :pointer, :pointer, :pointer], :int
    attach_function :_posix_spawnp, :posix_spawnp, [:pointer, :string, :pointer, :pointer, :pointer, :pointer], :int

    def self.spawn(*args)
      spawn_args = _prepare_spawn_args(args)
      _posix_spawn(*spawn_args)
      spawn_args[0].read_int
    end

    def self.spawnp(*args)
      spawn_args = _prepare_spawn_args(args)
      _posix_spawnp(*spawn_args)
      spawn_args[0].read_int
    end

    private

    def self._prepare_spawn_args(args)
      pid_ptr = FFI::MemoryPointer.new(:pid_t, 1)

      args_ary = FFI::MemoryPointer.new(:pointer, args.length + 1)
      str_ptrs = args.map {|str| FFI::MemoryPointer.from_string(str)}
      args_ary.put_array_of_pointer(0, str_ptrs)

      env_ary = FFI::MemoryPointer.new(:pointer, ENV.length + 1)
      env_ptrs = ENV.map {|key,value| FFI::MemoryPointer.from_string("#{key}=#{value}")}
      env_ary.put_array_of_pointer(0, env_ptrs)

      [pid_ptr, args[0], nil, nil, args_ary, env_ary]
    end
  end

  def Exec.system(*args)
    Process.waitpid(Spoon.spawnp(*args))
  end
end

class InteractiveEditor
  attr_accessor :editor

  def initialize(editor)
    @editor = editor.to_s
  end

  def edit(file=nil)
    @file = if file
       FileUtils.touch(file) unless File.exist?(file)
       File.new(file)
      else
       (@file && File.exist?(@file.path)) ? @file : Tempfile.new(["irb_tempfile", ".rb"])
    end
    mtime = File.stat(@file.path).mtime
    Exec.system(@editor, @file.path)

    execute if mtime < File.stat(@file.path).mtime
  end

  def execute
    Object.class_eval(IO.read(@file.path))
  end

  def self.edit(editor, file=nil)
    #idea serialise last file to disk, for recovery
    unless IRB.conf[:interactive_editors] && IRB.conf[:interactive_editors][editor]
      IRB.conf[:interactive_editors] ||= {}
      IRB.conf[:interactive_editors][editor] = InteractiveEditor.new(editor)
    end
    IRB.conf[:interactive_editors][editor].edit(file)
  end
end

class << self
  def vim(name=nil)
     InteractiveEditor.edit('vim', name)
  end

  def mvim(name=nil)
    InteractiveEditor.edit('/Applications/MacVim.app/Contents/MacOS/Vim -g -f', name)
  end

  def mate(name=nil)
    InteractiveEditor.edit('mate -w', name)
  end

  def emacs(name=nil)
    InteractiveEditor.edit('emacs', name)
  end

  def nano(name=nil)
    InteractiveEditor.edit('nano', name)
  end

  def pbcopy(stuff)
    IO.popen('pbcopy', 'w+') {|clipboard| clipboard.write(stuff)}
  end
end

# This extension adds a UNIX-style pipe to strings
#
# Synopsis:
#
# >> puts "UtilityBelt is better than alfalfa" | "cowsay"
#  ____________________________________
# < UtilityBelt is better than alfalfa >
#  ------------------------------------
#         \   ^__^
#          \  (oo)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||
# => nil
class String
  def |(cmd)
    IO.popen(cmd.to_s, 'r+') do |pipe|
      pipe.write(self)
      pipe.close_write
      pipe.read
    end
  end
end

class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end

  # print documentation
  #
  #   ri 'Array#pop'
  #   Array.ri
  #   Array.ri :pop
  #   arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end
end

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def paste
  `pbpaste`
end

load File.dirname(__FILE__) + '/.railsrc' if defined?(Rails)
