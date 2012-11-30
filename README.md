ideeli_spinup is Ideeli's AWS/EC2 spinup script.

Installation 
============

```
git clone git@github.com:ideeli/ideeli_spinup.git
cd ideeli_spinup
bundle install
```

or download the gem
```
curl -u 'github username' -L -O https://github.com/downloads/ideeli/ideeli_spinup/ideeli_spinup-0.0.3.gem
gem install ideeli_spinup-0.0.3.gem
```

To Run
======

If running from a git checkout, use bundler to execute. An example config file is in config/ideeli_spinup.yaml.sample

```
bundle exec bin/spinup -c configfile.yaml OPTIONS
```

If installed from a gem, just run spinup directly
```
spinup -f configfile.yaml OPTIONS
```

Tests
=====

```
bundle exec rspec spec/*.rb
```



