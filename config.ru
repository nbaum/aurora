#\ -w -o 127.0.0.1 -p 9001

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
