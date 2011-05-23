-- schema valid as of 6/24/2008

-- use pha_fmp;

-- before running:
-- update date formats in FMP view to be yyyy-mm-dd
-- convert CR/LF to unix for all *.csv
-- convert ¶ to "," for all multi-select fields in agencies, restrictions
-- convert ¶ to "" for all subagencies, fmp2
-- sudo cp *.csv /opt/local/var/db/mysql5/pha_fmp/

-- alter table fmp2 drop column primary_serial, drop column loc_serial, drop column plan_serial;

-- truncate table fmp2;
-- load data local infile 'fmp2-feds05.csv' into table fmp2 fields terminated by ',' enclosed by '"' (newDbSerial, AgencyDropInCity, AgencyDropInState, AgencyDropInStreet1, AgencyDropInStreet2,AgencyDropInZip, AgencyEmail, AgencyFax, AgencyLocalPhone, AgencyLocalPhoneExt, AgencyMailCity,AgencyMailState, AgencyMailStreet1, AgencyMailStreet2, AgencyMailZip, AgencyName1, AgencyName2,AgencyPubsLocalPhone, AgencyPubsLocalPhoneExt, AgencyPubsTollFreePhone, AgencyPubsTollFreePhoneExt,AgencyPubsTTYPhone, AgencyPubsTTYPhoneExt, AgencyPubsURL, AgencyPubsURLTitle, AgencyTollFreePhone,AgencyTollFreePhoneExt, AgencyTTYPhone, AgencyTTYPhoneExt, AgencyURL, AgencyURLTitle,CatchallEmployees, Comments, CoveredEmployee, GeographicServiceInformation, GovtCounty,GovtEmployerType, GovtSpDist, GovtState, MultipleOffices, OldPHA_AgencySerialNumber,OldPHA_BabiesSerialNumber, PlanDescription, PlanEndDate, PlanName1, PlanName2, PlanStartDate,PlanType1, PlanType2, PlanType3, PlanURL, PlanURLTitle, RecordStatus, ResultType,ServiceGeographyType, SPDURL, SPDURLTitle, TPAURL, TPAURL_Title);

update fmp2 set OldPHA_AgencySerialNumber = null where OldPHA_AgencySerialNumber = 0;
update fmp2 set OldPHA_BabiesSerialNumber = null where OldPHA_BabiesSerialNumber = 0;
update fmp2 set AgencyName1=concat('[plan] ', PlanName1) where AgencyName1='';
update fmp2 set planStartDate = null where planStartDate = '0000-00-00';
update fmp2 set planEndDate = null where planEndDate = '0000-00-00';

-- alter table fmp2 add column primary_serial int;
create temporary table fmp2_primaries (agencyname1 varchar(255), agencyname2 varchar(255), planname1 varchar(255), serial int, primary_serial int);
insert into fmp2_primaries select agencyname1, agencyname2, planname1, newDbSerial, 0 from fmp2;
update fmp2_primaries p set p.primary_serial = (select min(f.newDbSerial) from fmp2 f where f.agencyname1=p.agencyname1);
update fmp2 f join fmp2_primaries p on p.serial=f.newDbSerial set f.primary_serial=p.primary_serial;
drop table fmp2_primaries;

-- alter table fmp2 add column loc_serial int;
create temporary table fmp2_loc (agencyname1 varchar(255), agencyname2 varchar(255), agencydropincity varchar(255), agencydropinstate varchar(255), serial int, loc_serial int, multipleoffices varchar(100));
insert into fmp2_loc select agencyname1, agencyname2, agencydropincity, agencydropinstate, newDbSerial, 0, multipleoffices from fmp2;
update fmp2_loc h set h.loc_serial = (select min(f.newDbSerial) from fmp2 f where f.agencyname1=h.agencyname1 and f.agencydropincity=h.agencydropincity and f.agencydropinstate=h.agencydropinstate);
update fmp2 f join fmp2_loc h on h.serial=f.newDbSerial set f.loc_serial=h.loc_serial;
drop table fmp2_loc;

-- alter table fmp2 add column plan_serial int;
create temporary table fmp2_plan (agencyname1 varchar(255), agencyname2 varchar(255), planname1 varchar(255), planname2 varchar(255), serial int, plan_serial int, multipleoffices varchar(100));
insert into fmp2_plan select agencyname1, agencyname2, planname1, planname2, newDbSerial, 0, multipleoffices from fmp2;
update fmp2_plan p set p.plan_serial = (select min(f.newDbSerial) from fmp2 f where f.agencyname1=p.agencyname1 and f.planname1=p.planname1 and f.planname2=p.planname2);
update fmp2 f join fmp2_plan p on p.serial=f.newdbserial set f.plan_serial=p.plan_serial;
drop table fmp2_plan;

-- use pha_development;

-- clear old fmp2 data
-- truncate plan_catch_all_employees;
-- delete rs from restrictions_states rs join restrictions r on rs.restriction_id = r.id and r.fmp2_code is not null;
-- delete rs from restrictions_cities rs join restrictions r on rs.restriction_id = r.id and r.fmp2_code is not null;
-- delete rs from restrictions_counties rs join restrictions r on rs.restriction_id = r.id and r.fmp2_code is not null;
-- delete rs from restrictions_zips rs join restrictions r on rs.restriction_id = r.id and r.fmp2_code is not null;
-- delete r from restrictions r join agencies a on r.agency_id = a.id and a.fmp2_code is not null;
-- delete from addresses where fmp2_code is not null;
-- delete from restrictions where fmp2_code is not null;
-- delete from locations where fmp2_code is not null;
-- delete c from counselings c join plans p on c.selected_plan_id = p.id and p.fmp2_code is not null;
-- delete from plans where fmp2_code is not null;
-- delete from publications where fmp2_code is not null;
-- delete from agencies where fmp2_code is not null;

-- import agencies from fmp2
insert into agencies select null, 1, null, agencyname1, '', '', 'FMP2', 1, agencyurl, agencyurltitle, '','','','',1,now(),now(),'FMP2 Import',null,null,null,null,newdbserial,null,null,null,null from  fmp2 where primary_serial=newdbserial;

-- import locations from fmp2
insert into locations select null, a.id, agencyname2, '', 0, 1, agencytollfreephone, agencytollfreephoneext, agencylocalphone, agencylocalphoneext, agencyttyphone, agencyttyphoneext, agencyfax, agencyemail, '', '', now(), null, null, newdbserial,'FMP2 Import',null,null,null,null,null,null,null,null,null,null,1 from  fmp2 f join agencies a on f.primary_serial=a.fmp2_code where f.loc_serial=f.newdbserial;
update locations l join agencies a on l.fmp2_code = a.fmp2_code set is_hq=1;

-- import addresses from fmp2
insert into addresses select null, l.id, f.agencydropinstreet1, f.agencydropinstreet2, f.agencydropincity, f.agencydropinstate, f.agencydropinzip, 'dropin', null, null, newdbserial, null, null from  fmp2 f join locations l on f.newdbserial=l.fmp2_code;

insert into addresses select null, l.id, f.agencymailstreet1, f.agencymailstreet2, f.agencymailcity, f.agencymailstate, f.agencymailzip, 'mailing', null, null, newdbserial, null, null from  fmp2 f join locations l on f.newdbserial=l.fmp2_code;

update addresses m join addresses d on d.fmp2_code = m.fmp2_code set m.line1=d.line1, m.line2=d.line2, m.city=d.city, m.state_abbrev=d.state_abbrev, m.zip=d.zip where m.city='' and m.state_abbrev='' and d.address_type='dropin' and m.address_type='mailing';

-- import publications from fmp2
insert into publications select null, a.id, f.agencypubstollfreephone, f.agencypubstollfreephoneext, f.agencypubslocalphone, f.agencypubslocalphoneext, f.agencypubsttyphone, f.agencypubsttyphoneext, '', '', f.agencypubsurl, '', null, newdbserial from  fmp2 f join agencies a on f.newdbserial = a.fmp2_code;

-- import plans from fmp2
insert into plans (id, agency_id, name, name2, description, comments, start_date, end_date, covered_employees, plan_type1, plan_type2, plan_type3, url, url_title, admin_url, admin_url_title, tpa_url, tpa_url_title, spd_url, spd_url_title, govt_employee_type, fmp2_code, legacy_category, legacy_status, updated_at, updated_by, email, is_active)
  select null, a.id, f.planname1, f.planname2, f.plandescription, f.comments, f.planstartdate, f.planenddate, f.coveredemployee, f.plantype1, f.plantype2, f.plantype3, f.planurl, f.planurltitle, '', '', f.tpaurl, f.tpaurl_title, f.spdurl, f.spdurltitle, f.govtemployertype, f.newdbserial, f.resulttype, f.recordstatus, now(), 'FMP2 Import', AgencyEmail, 1 from  fmp2 f join agencies a on f.primary_serial = a.fmp2_code where f.plan_serial=f.newdbserial;



-- import restrictions from fmp2
insert into restrictions select null, null, l.id, null, null, null, null, '', now(), now(), ad.state_abbrev, null, null, newdbserial, null, null,null,null from  fmp2 f join locations l on l.fmp2_code = f.newdbserial join addresses ad on ad.location_id = l.id and ad.address_type='dropin';

insert into restrictions select null, null, null, p.id, null, null, null, '', now(), now(), govtstate, null, null, newdbserial, null, null,null,null from  fmp2 f join plans p on p.fmp2_code = f.newdbserial;

-- update agency_categories and result_types based on legacy info:
-- update agencies set agency_category_id=3 where fmp2_code is not null;

-- update agency/subagency names for field offices
-- Where Agency Name 2 is empty, and record is a Head Office, fill with [Drop-In City] + “Head Office”
-- Where Agency Name 2 is empty, and record is a Field Office, fill with [Drop-In City] + “Office”
update agencies a, locations l, addresses dr set l.name = concat(dr.city, ' Head Office') where (l.name is null or l.name = '') and l.agency_id = a.id and dr.location_id = l.id and dr.address_type='dropin' and l.is_hq = 1 and a.fmp2_code is not null;

update agencies a, locations l, addresses dr set l.name = concat(dr.city, ' Office') where (l.name is null or l.name = '') and l.agency_id = a.id and dr.location_id = l.id and dr.address_type='dropin' and l.is_hq = 0 and a.fmp2_code is not null;

-- OLD update agencies set name2 = '' where (name2 like '% office' or name2 like '% site') and fmp2_code is not null;
-- OLD update locations set name = name2, name2 = '' where (name2 like '% office' or name2 like '% site') and fmp2_code is not null;

-- set legacy_geo_states to be "home state" if it doesn't exist. this lets us match counties & cities more accurately
update restrictions r join agencies a on r.agency_id = a.id join locations l on l.agency_id = a.id  join addresses ad on ad.location_id = l.id and address_type = 'dropin' set r.legacy_geo_states = ad.state_abbrev where (r.legacy_geo_states is null or r.legacy_geo_states = '') and a.fmp2_code is not null;
update restrictions r join locations l on r.location_id = l.id join addresses ad on ad.location_id = l.id and address_type = 'dropin' set r.legacy_geo_states = ad.state_abbrev where (r.legacy_geo_states is null or r.legacy_geo_states = '') and l.fmp2_code is not null;
update restrictions r join plans p on r.plan_id = p.id join agencies a on p.agency_id = a.id and a.fmp2_code is not null join locations l on l.agency_id = a.id join addresses ad on ad.location_id = l.id and address_type = 'dropin' set r.legacy_geo_states = ad.state_abbrev where (r.legacy_geo_states is null or r.legacy_geo_states = '') and a.fmp2_code is not null;

UPDATE addresses a SET a.latitude = ( SELECT latitude
FROM zip_import z
WHERE LEFT( a.zip, 5 ) = z.zipcode
LIMIT 1 )
WHERE a.latitude IS NULL ;

UPDATE addresses a SET a.longitude = ( SELECT longitude
FROM zip_import z
WHERE LEFT( a.zip, 5 ) = z.zipcode
LIMIT 1 )
WHERE a.longitude IS NULL ;

# then run pha_fmp2_geo_csv_conversion.rb
# and dan's plan_catch_all_employees migration scripts

-- assume that there exists only one location for the agency related to this plan, and make it the servicing location
insert into location_plan_relationships (is_hq, location_id, plan_id) select 1, l.id, p.id from plans p join agencies a on p.agency_id = a.id join locations l on l.agency_id = a.id where p.id >= #first 'new' plan from above;
