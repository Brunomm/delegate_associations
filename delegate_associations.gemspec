# -*- encoding: utf-8 -*-
require File.expand_path('../lib/delegate_associations/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "delegate_associations"
  s.version     = DelegateAssociations::VERSION
  s.description = "A gem for delegate attributes and associations of belongs_to and has_one"
  s.summary     = "A gem for delegate attributes and associations of belongs_to and has_one"
  s.homepage    = "https://github.com/Brunomm/delegate_associations"
  s.author      = "Bruno Mucelini Mergen"
  s.files       = Dir["{lib/**/*.rb,README.rdoc,test/**/*.rb,Rakefile,*.gemspec}"]
  s.email       = ["brunomergen@gmail.com"]
  s.licenses      = ['MIT']
end