-- Active: 1743599450736@@127.0.0.1@5432@ticketsystem

drop table if exists ticket_user;

drop table if exists ticket;

drop table if exists event;

drop table if exists venue;

drop table if exists tour;

drop table if exists artist;

drop table if exists setlist;

drop table if exists plays_in;

drop table if exists part_of;

drop table if exists song;

drop table if exists album;

drop table if exists music_label;

drop table if exists releases;

drop table if exists organizer;

drop table if exists address;

create table if not exists ticket_user ( -- postgres doesn't allow to name a table "user"
    user_id bigint,
    first_name varchar(32) not null,
    last_name varchar(32) not null,
    email varchar(64) not null,
    hashed_password varchar(512) not null, -- it also doesn't allow to name a column "password"
    primary key (user_id),
    unique (email)
);

create table if not exists ticket (
    ticket_nr bigint,
    price decimal(8, 2) not null,
    seat_nr int,
    user_id bigint,
    event_id bigint not null,
    primary key (ticket_nr)
);

create table if not exists event (
    event_id bigint,
    begin varchar(5) not null, -- format: HH:MM (I'm not bothering figuring out how to use timestamps correctly)
    doors varchar(5) not null,
    date date not null,
    venue_id bigint not null,
    tour_id bigint not null,
    primary key (event_id),
    unique (
        venue_id,
        date,
        begin
    ) -- do not allow multiple events at the same time
);

create table if not exists venue (
    venue_id bigint,
    name varchar(128) not null,
    address bigint not null,
    capacity_standing int,
    capacity_seated int,
    primary key (venue_id)
);

create table if not exists tour (
    tour_id bigint,
    name varchar(128) not null,
    organizer varchar(128) not null,
    percentage decimal(5, 2),
    primary key (tour_id)
);

create table if not exists artist (
    artist_id bigint,
    name varchar(128) not null,
    genre varchar(64),
    label_name varchar(128),
    contract_end date,
    user_id bigint,
    primary key (artist_id),
    check (
        contract_end > now()
        or contract_end is null
    ) -- don't create artists with expired contracts
);

create table if not exists setlist (
    setlist_id bigint,
    primary key (setlist_id)
);

create table if not exists plays_in (
    artist_id bigint not null,
    tour_id bigint not null,
    setlist_id bigint not null,
    position int not null,
    primary key (
        artist_id,
        tour_id,
        setlist_id
    )
);

create table if not exists part_of (
    setlist_id bigint not null,
    song_id bigint not null,
    position int not null,
    primary key (setlist_id, song_id)
);

create table if not exists song (
    song_id bigint,
    album_id bigint not null,
    position int not null,
    name varchar(128) not null,
    primary key (song_id, album_id)
);

create table if not exists album (
    album_id bigint,
    name varchar(128) not null,
    primary key (album_id)
);

create table if not exists music_label (
    name varchar(128),
    address bigint not null,
    user_id bigint,
    primary key (name)
);

create table if not exists releases (
    artist_id bigint not null,
    album_id bigint not null,
    label_name varchar(128),
    released date,
    label_fee decimal(8, 2),
    primary key (artist_id, album_id)
);

create table if not exists organizer (
    name varchar(128),
    address bigint not null,
    user_id bigint,
    primary key (name)
);

create table if not exists address (
    address_id bigint,
    country varchar(64) not null,
    city varchar(64) not null,
    postal_code varchar(16) not null,
    street varchar(128) not null,
    house_number varchar(16) not null,
    primary key (address_id)
);

-- define foreign key constraints

alter table ticket
add foreign key (user_id) references ticket_user on delete set null on update cascade,
add foreign key (event_id) references event on delete cascade on update cascade;

alter table event
add foreign key (venue_id) references venue on delete restrict on update cascade,
add foreign key (tour_id) references tour on delete restrict on update cascade;

alter table venue
add foreign key (address) references address on delete restrict on update cascade;

alter table tour
add foreign key (organizer) references organizer on delete restrict on update cascade;

alter table artist
add foreign key (user_id) references ticket_user on delete set null on update cascade,
add foreign key (label_name) references music_label on delete restrict on update cascade;

-- relationship relation -> if any reference gets deleted, any existing relationship tuple is deleted too
alter table plays_in
add foreign key (artist_id) references artist on delete cascade on update cascade,
add foreign key (tour_id) references tour on delete cascade on update cascade,
add foreign key (setlist_id) references setlist on delete cascade on update cascade;

alter table part_of
add column if not exists album_id bigint,
add foreign key (setlist_id) references setlist on delete cascade on update cascade,
add foreign key (song_id, album_id) references song on delete cascade on update cascade;

alter table song
add foreign key (album_id) references album on delete cascade on update cascade;

alter table music_label
add foreign key (user_id) references ticket_user on delete set null on update cascade,
add foreign key (address) references address on delete restrict on update cascade;

alter table releases
add foreign key (artist_id) references artist on delete cascade on update cascade,
add foreign key (album_id) references album on delete cascade on update cascade,
add foreign key (label_name) references music_label on delete cascade on update cascade;

alter table organizer
add foreign key (user_id) references ticket_user on delete set null on update cascade,
add foreign key (address) references address on delete restrict on update cascade;

set datestyle to dmy;

insert into
    ticket_user (
        user_id,
        first_name,
        last_name,
        email,
        hashed_password
    )
values (
        1,
        'Max',
        'Mustermann',
        'mm@gmx.de',
        'password_1(yes ik it isnt hashed idgaf)'
    ),
    (
        2,
        'John',
        'Doe',
        'jdoe@gmail.com',
        'password 2'
    ),
    (
        3,
        'Jane',
        'Doe',
        'jdoe@web.de',
        'password 3'
    ),
    (
        4,
        'Hans',
        'Müller',
        'hmueller@gmail.com',
        'password 4'
    ),
    (
        5,
        'Calle',
        'Thomer',
        'cthomer@gmail.com',
        'password 5'
    );

insert into
    address (
        address_id,
        country,
        city,
        postal_code,
        street,
        house_number
    )
values (
        1,
        'GER',
        'Stuttgart',
        '70376',
        'Quellenstraße',
        '7'
    ),
    (
        2,
        'GER',
        'München',
        '80639',
        'Reitknechtstraße',
        '6'
    ),
    (
        3,
        'AUS',
        'Melbourne',
        '3000',
        'Collins Street',
        '101'
    ),
    (
        4,
        'GER',
        'Dortmund',
        '44135',
        'Kampstraße',
        '45'
    ),
    (
        5,
        'GER',
        'München',
        '80636',
        'Elvirastraße',
        '4'
    );

insert into
    venue (venue_id, name, address)
values (1, 'Im Wizeman', 1),
    (2, 'Backstage', 2);

insert into
    music_label (name, address)
values ('UNFD', 3),
    ('Century Media', 4);

insert into organizer (name, address) values ('Avocado Booking', 5);

insert into
    artist (
        artist_id,
        name,
        genre,
        label_name,
        contract_end,
        user_id
    )
values (
        1,
        'Invent Animate',
        'Metalcore',
        'UNFD',
        '01.01.2029',
        null
    ),
    (
        2,
        'Vildhjarta',
        'Thall',
        'Century Media',
        '01.11.2028',
        5
    ),
    (
        3,
        'ERRA',
        'Metalcore',
        'UNFD',
        '01.07.2027',
        null
    ),
    (
        4,
        'Northlane',
        'Metalcore',
        null,
        null,
        null
    ),
    (
        5,
        'Uri Gincel Trio',
        'Jazz',
        null,
        null,
        null
    );

insert into
    album (album_id, name)
values (1, 'Heavener'),
    (2, 'Måsstaden'),
    (3, 'Mesmer'),
    (
        4,
        'Love Through the Stained Glass'
    ),
    (
        5,
        'The Sun Sleeps, As if it never was'
    );

insert into
    releases (
        album_id,
        artist_id,
        label_name,
        released,
        label_fee
    )
values (
        1,
        1,
        'UNFD',
        '17.03.2023',
        20.00
    ),
    (
        2,
        2,
        'Century Media',
        '28.11.2011',
        10.00
    ),
    (
        3,
        4,
        'UNFD',
        '24.03.2017',
        5.00
    ),
    (
        5,
        1,
        'UNFD',
        '23.09.2021',
        30.00
    ),
    (
        4,
        5,
        null,
        '22.04.2022',
        null
    );

insert into
    song (
        song_id,
        name,
        album_id,
        position
    )
values (1, 'Absence Persistent', 1, 1),
    (2, 'Shade Astray', 1, 2),
    (
        3,
        'Immolation of Night',
        1,
        5
    ),
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
    (
        15,
        'As if it never was',
        5,
        3
    ),
    (16, '5000', 4, 3),
    (17, 'Rising up', 4, 1),
    (18, 'Phobon Nika', 2, 7);

insert into
    tour (
        tour_id,
        name,
        organizer,
        percentage
    )
values (
        1,
        'The Grand Thall Tour',
        'Avocado Booking',
        10.00
    );

insert into setlist (setlist_id) values (1), (2);

insert into
    part_of (setlist_id, song_id, position)
values (1, 1, 1),
    (1, 2, 2),
    (1, 3, 3),
    (1, 4, 4),
    (2, 5, 1),
    (2, 6, 2),
    (2, 7, 3),
    (2, 8, 4),
    (2, 18, 5);

insert into
    plays_in (
        artist_id,
        tour_id,
        setlist_id,
        position
    )
values (1, 1, 1, 1),
    (2, 1, 2, 2);

insert into
    event (
        event_id,
        date,
        begin,
        doors,
        venue_id,
        tour_id
    )
values (
        1,
        '24.08.2025',
        '20:00',
        '19:00',
        1,
        1
    ),
    (
        2,
        '25.08.2025',
        '20:00',
        '18:30',
        2,
        1
    );

insert into
    ticket (
        ticket_nr,
        price,
        event_id,
        seat_nr,
        user_id
    )
values (1, 20.00, 1, null, null),
    (2, 20.00, 1, null, 1),
    (3, 20.00, 1, 20, 2),
    (4, 20.00, 1, 21, null),
    (7, 25.00, 2, 4, null),
    (8, 25.00, 2, 6, 3),
    (9, 25.00, 2, null, null),
    (10, 25.00, 2, null, 4);

-- todo: some other fucking data