require 'rubygems'
require 'test/unit'
require 'spec'
require 'mocha'
require 'tempfile'
 
require 'active_record'
require 'active_support'

ROOT       = File.join(File.dirname(__FILE__), '..')
RAILS_ROOT = ROOT
 
$LOAD_PATH << File.join(ROOT, 'lib')
 
require File.join(ROOT, 'lib', 'template_relation.rb')
 
ENV['RAILS_ENV'] ||= 'test'
 
FIXTURES_DIR = File.join(File.dirname(__FILE__), "fixtures") 
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['RAILS_ENV'] || 'test'])
 
def init_models
  ActiveRecord::Base.connection.create_table :samples, :force => true do |table|
    table.column :name, :string
    table.column :body, :string
  end
  
  ActiveRecord::Base.connection.create_table :images, :force => true do |table|
    table.column :sample_id, :integer
    table.column :name, :string
    table.column :position, :integer
  end
 
  Object.send(:remove_const, "Sample") rescue nil
  Object.send(:remove_const, "Image") rescue nil
  Object.const_set("Sample", Class.new(ActiveRecord::Base))
  Object.const_set("Image", Class.new(ActiveRecord::Base))
  Sample.class_eval do
    include TemplateRelation
    template_relation :images, :number => 5
  end
  
  Image.class_eval do
    belongs_to :sample
  end
end
 
def temporary_rails_env(new_env)
  old_env = defined?(RAILS_ENV) ? RAILS_ENV : nil
  silence_warnings do
    Object.const_set("RAILS_ENV", new_env)
  end
  yield
  silence_warnings do
    Object.const_set("RAILS_ENV", old_env)
  end
end