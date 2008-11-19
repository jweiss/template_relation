require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('template_relations', '0.1.0') do |p|
  p.description    = "Allows you to specify the number of relations in ActiveRecord association declarations"
  p.url            = "http://github.com/jweiss/template_relations"
  p.author         = "Jonathan Weiss"
  p.email          = "jw@innerewut.de"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
