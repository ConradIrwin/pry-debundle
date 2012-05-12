# Copyright (c) Conrad Irwin <conrad.irwin@gmail.com> -- MIT License
# Source: https://github.com/ConradIrwin/pry-debundle
#
# To install and use this:
#
# 1. Recommended
#   Add 'pry' to your Gemfile (in the development group)
#   Add 'pry-debundle' to your Gemfile (in the development group)
#
# 2. OK, if colleagues are wary of pry-debundle:
#   Add 'pry' to your Gemfile (in the development group)
#   Copy this file into ~/.pryrc
#
# 3. Meh, if colleagues don't like Pry at all:
#   Copy this file into ~/.pryrc
#   Create a wrapper script that runs `pry -r<your-application>`
#
# 4. Pants, if you don't like Pry:
#   Copy the definition of the debundle! method into your ~/.irbrc
#   Call 'debundle!' from IRB when you need to.
#
class << Pry

  # Break out of the Bundler jail.
  #
  # This can be used to load files in development that are not in your Gemfile (for
  # example if you want to test something with a tool that you have locally).
  #
  # @example
  #   Pry.debundle!
  #   require 'all_the_things'
  #
  # Normally you don't need to cal this directly though, as it is called for you when Pry
  # starts.
  #
  # See https://github.com/carlhuda/bundler/issues/183 for some background.
  # 
  def debundle!
    loaded = false

    # Rubygems 1.8
    if defined?(Gem.post_reset_hooks)
      Gem.post_reset_hooks.reject!{ |hook| hook.source_location.first =~ %r{/bundler/} }
      Gem::Specification.reset
      load 'rubygems/custom_require.rb'
      loaded = true

    # Rubygems 1.6 — TODO might be quite slow.
    elsif Gem.source_index && Gem.send(:class_variable_get, :@@source_index)
      Gem.source_index.refresh!
      load 'rubygems/custom_require.rb'
      loaded = true

    else
      raise "No hacks found :("
    end
  rescue => e
    puts "Debundling failed: #{e.message}"
    puts "When reporting bugs to https://github.com/ConradIrwin/pry-debundle, please include:"
    puts "* gem version: #{Gem::VERSION rescue 'undefined'}"
    puts "* bundler version: #{Bundler::VERSION rescue 'undefined'}"
    puts "* pry version: #{Pry::VERSION rescue 'undefined'}"
    puts "* ruby version: #{RUBY_VERSION rescue 'undefined'}"
    puts "* ruby engine: #{RUBY_ENGINE rescue 'undefined'}"
  else
    load_additional_plugins if loaded
  end

  # After we've escaped from Bundler we want to look around and find any plugins the user
  # has installed locally but not added to their Gemfile.
  #
  def load_additional_plugins
    old_plugins = Pry.plugins.values
    Pry.locate_plugins
    new_plugins = Pry.plugins.values - old_plugins

    new_plugins.each(&:activate!)
  end
end

# Run just after a binding.pry, before you get dumped in the REPL.
# This handles the case where Bundler is loaded before Pry.
Pry.config.hooks.add_hook(:before_session, :debundle){ Pry.debundle! }

# Run after every line of code typed.
# This handles the case where you load something that loads bundler
# into your Pry.
Pry.config.hooks.add_hook(:after_eval, :debundle){ Pry.debundle! }
