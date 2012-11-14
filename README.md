ideeli_spinup is Ideeli's AWS/EC2 spinup script.

Installation 
============

```
git clone git@github.com:ideeli/ideeli_spinup.git
cd ideeli_spinup
bundle install
```

To Run
======

Use bundler to execute. An example config file is in config/ideeli_spinup.yaml.sample

```
bundle exec bin/spinup -c configfile.yaml OPTIONS
```




Tests
=====

```
bundle exec rspec spec/*.rb
```



