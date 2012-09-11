require "bundler"
Bundler.require


$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| 
  require File.basename(lib, '.*') 
}

require File.join(File.dirname(__FILE__),'my_app')

run MyApp
