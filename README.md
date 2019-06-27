# INSTALLATION

### To use gems from vendor/gems add the following code into environment.rb

config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir|
  File.directory?(lib = "#{dir}/lib") ? lib : dir
end

or

export RAILS_ENV='development'


# Setting up the application
### Create database.yml, example

development:
  adapter: mysql
  encoding: utf8
  database: pha_development
  username: root
  password:
  host: localhost


### Create database and load schema

As migration script were broken as of 2014-10-22. Use dump that reflects state of dba at 107_add_fields_to_partners.rb.
To set up your env load db/dumps/pha_2014-10-22.sql. From now on migrations should be run.

You can use `script/reload-and-migrate-db` to clear and repopulate your db from dump.

`export RAILS_ENV='development'; ./script/reload-and-migrate-db`

Password to all accounts: stuart eg. stuart/fmetrics1017 (old passwords before add_devise.. migration)

To migrate:

`rake db:migrate`


## Loading data

Download dump from qa server .Then load sql file into the database (from command line, via sequel pro or other tool)

## Running app
script/server

(NY postal code: 10001)

# Testing zip import
> ruby shell/load_zip_download.rb --db_user=root --db_pass= --db_host=localhost --db_name=pha_development --filedir=test/files/

Please reload db afterwards as zip file contains only couple sample codes

# Staging configuration

- Add secret before_bundle.rb to deploy folder with following commands ( deploy folder is located in project dir ).  {This appears to be already in repository, so we can skip this step - Dan 2015-01-02}

run `rm -rf #{config.release_path}/config/secrets.yml`
run `ln -nfs #{config.shared_path}/config/secrets.yml #{config.release_path}/config/secrets.yml`

- Add secret key to secrets.yml file on QA server ( shared folder ).  Use same rollbar key for all environments.  Use unique key for devise for each environment. Add rollbar keys: 
**rollbar_key_base**,
**secret_key_base**
- Staging environment is using basic http authentication to protect application from unauthorized access. Name: **pha**, password: **ph2012a**.

## Selenium Configuration

Download Selenium IDE plugin for firefox and install it.

#### !!!Please be aware that automated tests were not maintained and can be out-of-date!!!

### How to run test

1. Copy and paste specific test case file content from test/selenium directory
2. Paste it inside plugin input window ( Firefox browser ), or switch to selenium Window and use File -> Open Test Case
3. Run test case

- Important! You have to run rails server to perform tests!

### TO RUN SELENIUM TEST FROM CONSOLE YOU HAVE TO RUN FOLLOWING COMMAND IN CONSOLE ( you have to be in directory where selenium-server file is placed )

`java -jar selenium-server-standalone-2.44.0.jar -port 4444 -htmlSuite "*firefox /Applications/Firefox.app/Contents/MacOS/firefox-bin" "http://localhost:3000/" "./selenium/complete_test_suite.html" "TestSuiteResult.html"`
