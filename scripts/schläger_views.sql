-- Active: 1743599450736@@127.0.0.1@5432@ticketsystem

drop view if exists events_per_user;
drop view if exists tickets_sold_for_event;

-- purpose: users want to see relevant information about all events they're attending
create view events_per_user
as
select first_name, last_name, email, date, doors, begin, tour.name, price
from ticket_user
natural join ticket
natural join event
natural join tour;


-- purpose: helper view to make organizer & label views easier to manage
create view tickets_sold_for_event
as
select event_id, tour_id, sum(ticket.price) as total_income, count(ticket.ticket_nr) as tickets_sold 
from ticket
natural join ticket_user
natural join event
group by (event_id, event.date, tour_id)
order by event.date asc;



-- purpose: view the total income an organizer makes from a tour
create view organizer_income_by_tour
as
select organizer.name, (percentage / 100) * sum(total_income) 
from tour
natural join tickets_sold_for_event
join organizer on organizer.name = tour.organizer
group by organizer.name, percentage;


create view num_songs_per_album_per_tour
as
select tour.tour_id, tour.name as tour_name, album.name as album_name, label_fee, label_name, count(song.song_id) as num_songs
from setlist
join plays_in using (setlist_id)
join tour using (tour_id)
join part_of using (setlist_id)
join song using (song_id)
join album on album.album_id = song.album_id
join releases on releases.album_id = album.album_id
group by (tour.tour_id, tour.name), (album.name, label_fee, label_name);


-- purpose: view the total fees that need to be paid to the organizer based on how often the songs are played on the tour
-- DISCLAIMER: numbers are fucking unrealistic because the label fee is higher than the ticket price. I guess stuff like that happens when you make up data
create view label_income_by_tour
as
select label_name, tour.name, label_fee * count(event_id) * num_songs as total_fees
from num_songs_per_album_per_tour
join tour using (tour_id)
natural join tickets_sold_for_event
group by (label_name, label_fee), (tour.name, num_songs);



