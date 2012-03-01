require 'rubygems'
gem 'mysql'
require 'mysql'
require 'optparse'
# require 'mechanize'
# require 'zip/zip'

# configuration
db_host = 'localhost'
db_user = 'root'
db_pass = ''
db_name = 'pha_development'

zip_user = 'kgarrett@pensionrights.org'
zip_pass = 'studebaker'

filedir = '/tmp'

opts = OptionParser.new
opts.on("--db_user=[OPT]")      {|val| db_user  = val }
opts.on("--db_pass=[OPT]")      {|val| db_pass  = val }
opts.on("--db_host=[OPT]")      {|val| db_host  = val }
opts.on("--db_name=[OPT]")      {|val| db_name  = val }
opts.on("--zip_user=[OPT]")     {|val| zip_user = val }
opts.on("--zip_pass=[OPT]")     {|val| zip_pass = val }
opts.on("--filedir=[OPT]")      {|val| filedir  = val }

opts.parse(ARGV)

begin
  # puts "Getting latest zipcode download file..."
  # agent = WWW::Mechanize.new
  # page = agent.get('http://www.zipcodedownload.com/Login/')
  # login_form = page.form('aspnetForm')
  # login_form['ctl01$templateBase$loginLogin$textEmail'] = zip_user
  # login_form['ctl01$templateBase$loginLogin$textPassword'] = zip_pass
  # page = agent.submit(login_form, login_form.buttons.first)
  #
  # File.open("#{filedir}/zip_import.zip", 'w') do |f|
  #   f.write agent.get_file(page.links.text('Download - Tab Delimited (MySQL compatible)').uri)
  # end
  #
  # puts "Unzipping zipcode download file..."
  # File.open("#{filedir}/zip_import.txt", 'w') do |f|
  #   Zip::ZipFile.open("#{filedir}/zip_import.zip", Zip::ZipFile::CREATE) do |zip|
  #     f.write zip.read("5-digit Commercial.txt")
  #   end
  # end
  #
  dbh = Mysql.connect(db_host, db_user, db_pass, db_name)
  dbh.autocommit(false)

  sql = <<-SQL
  truncate table zip_import;

  load data local infile '#{filedir}/zip_import.txt' replace into table zip_import ignore 1 lines (zipcode,zip_type,city,city_type,county,county_fips,state_name,state_abbrev,state_fips,msa_code,area_code,time_zone,utc,dst,latitude,longitude);

  insert ignore into states(abbrev,name) select distinct state_abbrev, state_name from zip_import;

  update counties c join zip_import z on c.fips_code = z.county_fips and c.state_abbrev = z.state_abbrev
  set c.name = z.county;

  insert into counties select distinct null, z.county, z.county_fips, z.state_abbrev from zip_import z
  left join counties c on c.fips_code = z.county_fips and c.state_abbrev = z.state_abbrev
  where c.id is null;

  update zips join zip_import z on zips.zipcode = z.zipcode join counties c on z.county = c.name and z.state_abbrev=c.state_abbrev
  set zips.county_id = c.id;

  insert into zips select distinct z.zipcode, z.state_abbrev, c.id from zip_import z join counties c on z.county = c.name and z.state_abbrev=c.state_abbrev
  left join zips zz on zz.zipcode = z.zipcode
  where zz.zipcode is null;

  insert into cities select distinct null, z.city, c.id, z.state_abbrev from zip_import z
  join counties c on z.county = c.name and z.state_abbrev=c.state_abbrev
  left join cities ci on z.county = c.name and z.state_abbrev = c.state_abbrev and ci.name = z.city
  where z.city_type = 'D' and (z.zip_type = 'S' or z.zip_type = 'P')
  and ci.id is null;

  insert ignore into cities_zips select ci.id, z.zipcode, z.city_type from zip_import z
  join counties co on z.county = co.name and z.state_abbrev = co.state_abbrev
  join cities ci on ci.name = z.city and ci.county_id = co.id;

  SQL

  puts "Loading data into database..."
  sql.split(';').each { |a| dbh.query a.strip unless a.strip.empty? }
    dbh.commit
rescue MysqlError => e
  puts "MySQL Error #{e.errno}: #{e.error}"
end

puts "Done."
