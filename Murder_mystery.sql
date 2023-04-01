-- pull the information for all murders that happened on Jan 18 2015 in SQL City using the crime scene report table

SELECT *
FROM crime_scene_report
WHERE type = 'murder' AND city = 'SQL City' AND date = 20180115;

-- figure out any information known about Annabel

SELECT *
FROM person
WHERE name LIKE 'Annabel%' AND address_street_name = 'Franklin Ave';

-- info from the person table doesn’t give any extra clues to move forward but can join tables using her id number to get more info
-- check if Annabel is a get fit now member

SELECT *
FROM get_fit_now_member AS fit
INNER JOIN person
ON fit.name = person.name
WHERE person.name LIKE 'Annabel%' AND address_street_name = 'Franklin Ave';

-- figure out if Annabel was interviewed AND if yes what she said

SELECT *
FROM interview
LEFT JOIN get_fit_now_member AS fit
ON interview.person_id = fit.person_id
LEFT JOIN person
ON fit.name = person.name
WHERE person.name LIKE 'Annabel%' AND address_street_name = 'Franklin Ave';

-- has Annabel attended any events?

SELECT *
FROM facebook_event_checkin
WHERE person_id = 16371;

-- who else has attended The Funky Grooves Tour

SELECT *
FROM facebook_event_checkin
WHERE event_name = 'The Funky Grooves Tour';

-- the two other people who attended this event are Morty Schapiro and Jeremy Bowers and should be evaluated further

SELECT *
FROM facebook_event_checkin AS fb
INNER JOIN person
ON fb.person_id = person.id
WHERE event_name = 'The Funky Grooves Tour';

-- pull list of members who checked into the gym on Jan 09 2018

SELECT *
FROM get_fit_now_check_in
WHERE check_in_date = 20180109;

-- figure out what information witness 1 can provide

SELECT *
FROM interview
LEFT JOIN person
ON interview.person_id = person.id
WHERE address_street_name = "Northwestern Dr"
ORDER BY address_number DESC
LIMIT 1;

-- two members with IDs that begin with 48Z were checked in on Jan 09 2018

SELECT *
FROM get_fit_now_check_in
WHERE check_in_date = 20180109 AND membership_id LIKE '48Z%';

-- details of the two suspects

SELECT *
FROM get_fit_now_check_in AS check_in
LEFT JOIN get_fit_now_member AS member
ON check_in.membership_id = member.id
WHERE check_in_date = 20180109 AND membership_id LIKE '48Z%';

-- figure out who drives a car with plate number H42W

SELECT *
FROM drivers_license AS dl
LEFT JOIN person
ON dl.id = person.license_id
WHERE plate_number LIKE 'H42W%';

-- is Maxine Whitley connected to our suspect at all? She was not interviewed by police

SELECT *
FROM drivers_license AS dl
INNER JOIN person
ON dl.id = person.license_id
INNER JOIN interview
ON person.id = interview.person_id
WHERE plate_number LIKE 'H42W%';

-- she also had not checked into any facebook events on this day
-- used primary key id column on the drivers license table and foreign key license id on the person table to join the drivers license and person tables
-- used alias’ for drivers license and fb to make the query less busy and because it’s more efficient than typing long table names

SELECT *
FROM drivers_license AS dl
INNER JOIN person
ON dl.id = person.license_id
INNER JOIN facebook_event_checkin AS fb
ON person.id = fb.person_id
WHERE plate_number LIKE 'H42W%';

-- what info overlaps with Maxine Whitley? She lives on Fisk Rd and so does one suspect (Joe Germuska)

SELECT *
FROM get_fit_now_check_in AS check_in
INNER JOIN get_fit_now_member AS member
ON check_in.membership_id = member.id
INNER JOIN person
ON member.person_id = person.id
WHERE check_in_date = 20180109 AND membership_id LIKE '48Z%';

-- let’s get more info on each suspect
-- Jeremy Bowers might have an alibi as he was checked into a concert on Jan 15 2018
-- we also did not get any additional info about Joe Germuska from this as he has not checked into any events

SELECT *
FROM get_fit_now_check_in AS check_in
INNER JOIN get_fit_now_member AS member
ON check_in.membership_id = member.id
INNER JOIN person
ON member.person_id = person.id
INNER JOIN facebook_event_checkin AS fb
ON person.id = fb.person_id
WHERE check_in_date = 20180109 AND membership_id LIKE '48Z%' AND date = 20180115;

-- check to see if either of our suspects were interviewed

SELECT *
FROM get_fit_now_check_in AS check_in
INNER JOIN get_fit_now_member AS member
ON check_in.membership_id = member.id
INNER JOIN person
ON member.person_id = person.id
INNER JOIN interview
ON person.id = interview.person_id
WHERE check_in_date = 20180109 AND membership_id LIKE '48Z%';

-- what information can we find based on the info Jeremy Bowers gave about the mysterious lady?

SELECT *
FROM drivers_license AS dl
INNER JOIN person
ON dl.id = person.license_id
INNER JOIN income
ON person.ssn = income.ssn
WHERE gender = 'female'
	AND hair_color = 'red'
	AND height BETWEEN 65 AND 67
	AND car_make = 'Tesla'
	AND car_model = 'Model S';

-- filtered based on event check in since he knew she attended SQL symphony concerts

SELECT *
FROM drivers_license AS dl
INNER JOIN person
ON dl.id = person.license_id
INNER JOIN facebook_event_checkin AS fb
ON person.id = fb.person_id
WHERE gender = 'female'
	AND hair_color = 'red'
	AND height BETWEEN 65 AND 67
	AND car_make = 'Tesla'
	AND car_model = 'Model S'
GROUP BY name;

-- unfortunately our new suspect Miranda Priestly was not interviewed

SELECT *
FROM person
INNER JOIN interview
ON person.id = interview.person_id
WHERE name = 'Miranda Priestly';

-- she does make a lot of money though

SELECT *
FROM income
INNER JOIN person
ON income.ssn = person.ssn
WHERE name = 'Miranda Priestly';

-- how is she connected to Maxine Whitley or Joe Germuska? None of these three were interviewed by police, the sus car that was seen was Maxine’s Prius
-- look into person_ids for those who attended symphony concerts in December

SELECT *
FROM facebook_event_checkin
WHERE event_name LIKE '%Symphony%' AND date > 20171130 AND date < 20180101
ORDER BY date;
              
-- no one who attended symphony concerts in DEC 2017 ever spoke to police with clues that help us aside from Jeremy Bowers

SELECT *
FROM facebook_event_checkin AS fb
INNER JOIN interview
ON fb.person_id = interview.person_id
WHERE event_name LIKE '%Symphony%' AND date > 20171130 AND date < 20180101
ORDER BY date;

-- Annabel and Jeremy Bowers the only attendees at the gym on the day of the murder that were interviewed by police

SELECT *
FROM interview
INNER JOIN get_fit_now_member AS member
ON interview.person_id = member.person_id
INNER JOIN get_fit_now_check_in AS check_in
ON member.id = check_in.membership_id
WHERE check_in_date = 20180109;

-- I think it might have been Miranda
-- it…it was Miranda
