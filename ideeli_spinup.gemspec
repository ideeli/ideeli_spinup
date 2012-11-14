# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ideeli_spinup/version"

Gem::Specification.new do |s|
  s.name        = "ideeli_spinup"
  s.version     = IdeeliSpinup::VERSION
  s.authors     = ["Aaron Brown"]
  s.email       = ["abrown@ideeli.com"]
  s.homepage    = "https://github.com/ideeli/ideeli_spinup"
  s.summary     = "Ideeli's AWS spinup script"
  s.description = "Ideeli's AWS spinup script"

  s.rubyforge_project = "ideeli_spinup"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "fog", ">= 1.7.0"
  s.add_runtime_dependency "iclassify-interface"
  s.add_development_dependency "rspec"
end
