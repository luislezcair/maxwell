# frozen_string_literal: true

namespace :apis do
  desc 'Ask the user to fill an attribute for all entities of a class'

  task :interactive_fill, [:klass, :param] => [:environment] do |_task, args|
    klass = "::#{args[:klass]}".constantize
    param = args[:param].to_sym
    filter = Hash[param, nil]

    klass.where(filter).each do |c|
      print "Enter #{param} for #{klass.name} #{c.name}: "

      new_val = STDIN.gets
      if new_val
        c[param] = new_val.chomp
        c.save!
      else
        puts
      end
    end
  end
end
