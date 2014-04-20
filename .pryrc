
Pry.config.theme = "railscasts"
Pry.config.pager = false
Pry.config.auto_indent = true
Pry.config.correct_indent = true
Pry.config.color = true
Pry.config.editor = "subl -wn"
Pry.config.history.file = "~/pry_history"
Pry.config.hooks.add_hook(:before_session, :say_hi_bob) do
  puts "\n\nHi Bob!\nRuby#{RUBY_VERSION}\n\n"
end
Pry.config.hooks.add_hook(:after_session, :say_bye_bob) do
  puts "\n\nbye-bye Bob!\n\n"
end

     
    # color = {
    # :red => "31m",
    # :green => "32m",
    # :yellow => "33m",
    # :blue => "34m",
    # :purple => "35m",
    # :cyan => "36m"
    # }

    Pry.prompt = [
      proc { |target_self, nest_level, pry|
            "[#{pry.input_array.size}]\001\e[0;32m\002#{Pry.config.prompt_name}\001\e[0m\002(\001\e[0;33m\002#{Pry.view_clip(target_self)}\001\e[0m\002)#{":#{nest_level}" unless nest_level.zero?}> "
           },
      proc { |target_self, nest_level, pry|
            "[#{pry.input_array.size}]\001\e[1;32m\002#{Pry.config.prompt_name}\001\e[0m\002(\001\e[1;33m\002#{Pry.view_clip(target_self)}\001\e[0m\002)#{":#{nest_level}" unless nest_level.zero?}* "
           } ]
    require 'rubygems'

# begin
#   require 'awesome_print' 
#   Pry.config.print = proc { |output, value| output.puts value.ai }
# rescue LoadError => err
#   puts "no awesome_print :("
# end

# Same as above, but with Pry's pager:
begin
  require 'awesome_print' 
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }
rescue LoadError => err
  puts "no awesome_print :("
end