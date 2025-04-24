set datestyle to dmy;

insert into ticket_user (user_id, first_name, last_name, email, hashed_password)
values
(1, 'Max', 'Mustermann', 'mm@gmx.de', 'password_1(yes ik it isn\'t hashed idgaf)'),
(2, 'John', 'Doe', 'jdoe@gmail.com', 'password 2'),
(3, 'Jane', 'Doe', 'jdoe@web.de', 'password 3'),
(4, 'Hans', 'Müller', 'hmueller@gmail.com', 'password 4'),
(5, 'Calle', 'Thomer', 'cthomer@gmail.com', 'passwoed 5');


insert into address (address_id, country, city, postal_code, street, house_number)
values
(1, 'GER', 'Stuttgart', '70376', 'Quellenstraße', '7'),
(2, 'GER', 'München', '80639', 'Reitknechtstraße', '6'),
(3, 'AUS', 'Melbourne', '3000', 'Collins Street', '101'),
(4, 'GER', 'Dortmund', '44135', 'Kampstraße', '45'),
(5, 'GER', 'München', '80636', 'Elvirastraße', '4');

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


-- todo: some other fucking data 


