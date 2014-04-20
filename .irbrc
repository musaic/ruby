# https://github.com/carlhuda/bundler/issues/183#issuecomment-1149953

if defined?(::Bundler)
  global_gemset = ENV['GEM_PATH'].split(':').grep(/ruby.*@global/).first
  if global_gemset
    all_global_gem_paths = Dir.glob("#{global_gemset}/gems/*")
    all_global_gem_paths.each do |p|
      gem_path = "#{p}/lib"
      $LOAD_PATH << gem_path
    end
  end
end



# From: https://raw.github.com/robhurring/dotfiles/master/etc/irbrc

exit if RUBY_ENGINE == 'macruby'

require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'
require 'pp'

def try_require(*names)
  names.each do |name|
    begin
      require name.to_s
    rescue LoadError
      # don't care
    end
  end
end

try_require :awesome_print, :commands

IRB.conf.merge!({
  :USE_READLINE => true,
  :SAVE_HISTORY => 100,
  :HISTORY_FILE => "#{ENV['HOME']}/.irb_history",
  :AUTO_INDENT => true,
  :PROMPT_MODE => :SIMPLE
})

class Object
  def ivg name
    instance_variable_get name
  end

  def ivs name, value
    instance_variable_set name, value
  end

  def copy
    IO.popen('pbcopy', 'w'){ |f| f << self.to_s }
    self
  end
end

def save(filename = '/Desktop/irb-session.txt', &block)
  path = File.join ENV['HOME'], filename
  File.open(path, 'w+') do |f|
    f << block.call
  end
end

def benchmark
  require 'benchmark'
  bm = Benchmark.realtime{ yield }
  puts "%0.2f Second(s)" % bm
end
alias bm benchmark

def paste
  `pbpaste`.chomp
end

alias x exit

# Rails Specific Helpers

module Rails
  module IRBHelpers
    def sql(query)
      ActiveRecord::Base.connection.select_all(query)
    end

    def change_log(stream)
      ActiveRecord::Base.logger = Logger.new(stream)
      ActiveRecord::Base.clear_active_connections!
    end

    def show_log
      change_log(STDOUT)
    end

    def hide_log
      change_log(nil)
    end
  end
end

include Rails::IRBHelpers if defined?(Rails)

unless defined?(y)
  try_require 'syck'
end

# Machine specific helpers
localrc = File.expand_path('.localirbrc', ENV['HOME'])
if File.exists?(localrc)
  load localrc.to_s
end

# # Use Pry everywhere
# require "rubygems"
# require 'pry'
# require "pry-nav"
# Pry.start
# exit
