set datestyle to dmy;

insert into ticket_user (user_id, first_name, last_name, email, hashed_password)
values
(1, 'Max', 'Mustermann', 'mm@gmx.de', 'password_1(yes ik it isnt hashed idgaf)'),
(2, 'John', 'Doe', 'jdoe@gmail.com', 'password 2'),
(3, 'Jane', 'Doe', 'jdoe@web.de', 'password 3'),
(4, 'Hans', 'Müller', 'hmueller@gmail.com', 'password 4'),
(5, 'Calle', 'Thomer', 'cthomer@gmail.com', 'password 5');


insert into address (address_id, country, city, postal_code, street, house_number)
values
(1, 'GER', 'Stuttgart', '70376', 'Quellenstraße', '7'),
(2, 'GER', 'München', '80639', 'Reitknechtstraße', '6'),
(3, 'AUS', 'Melbourne', '3000', 'Collins Street', '101'),
(4, 'GER', 'Dortmund', '44135', 'Kampstraße', '45'),
(5, 'GER', 'München', '80636', 'Elvirastraße', '4');

insert into venue (venue_id, name, address)
values
(1, 'Im Wizeman', 1),
(2, 'Backstage', 2);

insert into music_label (name, address)
values
('UNFD', 3),
('Century Media', 4);

insert into organizer (name, address)
values
('Avocado Booking', 5);

insert into artist (artist_id, name, genre, label_name, contract_end, user_id)
values
(1, 'Invent Animate', 'Metalcore', 'UNFD', '01.01.2029', null),
(2, 'Vildhjarta', 'Thall', 'Century Media', '01.11.2028', 5),
(3, 'ERRA', 'Metalcore', 'UNFD', '01.07.2027', null),
(4, 'Northlane', 'Metalcore', null, null, null),
(5, 'Uri Gincel Trio', 'Jazz', null, null, null);

insert into album (album_id, name)
values
(1, 'Heavener'),
(2, 'Måsstaden'),
(3, 'Mesmer'),
(4, 'Love Through the Stained Glass'),
(5, 'The Sun Sleeps, As if it never was');


insert into releases (album_id, artist_id, label_name, released, label_fee)
values
(1, 1, 'UNFD', '17.03.2023',20.00),
(2, 2, 'Century Media', '28.11.2011', 10.00),
(3, 4, 'UNFD', '24.03.2017', 5.00),
(5, 1, 'UNFD', '23.09.2021', 30.00),
(4, 5, null, '22.04.2022', null);

insert into song (song_id, name, album_id, position)
values
(1, 'Absence Persistent', 1, 1),
(2, 'Shade Astray', 1, 2),
(3, 'Immolation of Night', 1, 5),
(4, 'Elysium', 1, 11),
(5, 'Shadow', 2, 1),
(6, 'Dagger', 2, 2),
(7, 'The Lone deranger', 2, 13),
(8, 'Traces', 2, 6),
(9, 'Citizen', 3, 1),
(10, 'Solar', 3, 4),
(11, 'Zero-one', 3, 7),
(12, 'Paragon', 3, 11),
(13, 'Render', 3, 9),
(14, 'The Sun Sleeps', 5, 1),
(15, 'As if it never was', 5, 3),
(16, '5000', 4, 3),
(17, 'Rising up', 4, 1),
(18, 'Phobon Nika', 2, 7);


insert into tour (tour_id, name, organizer, percentage)
values
(1, 'The Grand Thall Tour', 'Avocado Booking', 10.00);

insert into setlist (setlist_id)
values
(1),
(2);

insert into part_of (setlist_id, song_id, position)
values
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(1, 4, 4),
(2, 5, 1),
(2, 6, 2),
(2, 7, 3),
(2, 8, 4),
(2, 18, 5);

insert into plays_in (artist_id, tour_id, setlist_id, position)
values
(1, 1, 1, 1),
(2, 1, 2, 2);

insert into event (event_id, date, begin, doors, venue_id, tour_id)
values
(1, '24.08.2025', '20:00', '19:00', 1, 1),
(2, '25.08.2025', '20:00', '18:30', 2, 1);


insert into ticket (ticket_nr, price, event_id, seat_nr, user_id)
values
(1, 20.00, 1, null, null),
(2, 20.00, 1, null, 1),
(3, 20.00, 1, 20, 2),
(4, 20.00, 1, 21, null),
(7, 25.00, 2, 4, null),
(8, 25.00, 2, 6, 3),
(9, 25.00, 2, null, null),
(10, 25.00, 2, null, 4);




-- todo: some other fucking data 


