# frozen_string_literal: true

namespace :seeds do
  desc 'Read data from a .json file and load it into the database using a '\
       'model class. Files are read from the "data" directory'

  task :from_json, [:klass, :file] => [:environment] do |_task, args|
    klass = args[:klass].constantize
    filename = Rails.root.join('data', args[:file])

    json = MultiJson.load(File.read(filename), symbolize_keys: true)

    print "Loading #{json.count} #{klass.model_name.collection.capitalize}... "

    ActiveRecord::Base.transaction do
      json.each do |item|
        klass.new(item).save!
      end
    end

    puts 'Done.'
  end
end
