-- Active: 1743599450736@@127.0.0.1@5432@ticketsystem





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
    begin timestamp not null,
    doors timestamp not null,
    date date not null,
    venue_id bigint not null,
    tour_id bigint not null,

    primary key (event_id),
    unique (venue_id, date, begin) -- do not allow multiple events at the same time
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
    organizer_id varchar(128) not null,
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
    check (contract_end > now() or contract_end is null) -- don't create artists with expired contracts
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

    primary key (artist_id, tour_id, setlist_id)
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
    name varchar(128) not null,
    setlist_id bigint,

    primary key (song_id, album_id)
);

create table if not exists album (
    album_id bigint,
    name varchar(128) not null,
    released date,
    label_name varchar(128) not null,

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
    label_name varchar(128) not null,
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
    add foreign key (user_id) references ticket_user on delete set null,
    add foreign key (event_id) references event on delete cascade;

alter table event
    add foreign key (venue_id) references venue on delete restrict,
    add foreign key (tour_id) references tour on delete restrict;

alter table venue
    add foreign key (address) references address on delete restrict;

alter table tour
    add foreign key (organizer_id) references organizer on delete restrict;


alter table artist
    add foreign key (user_id) references ticket_user on delete set null,
    add foreign key (label_name) references music_label on delete restrict;

-- relationship relation -> if any reference gets deleted, any existing relationship tuple is deleted too
alter table plays_in
    add foreign key (artist_id) references artist on delete cascade,
    add foreign key (tour_id) references tour on delete cascade,
    add foreign key (setlist_id) references setlist on delete cascade;

alter table part_of
    add column if not exists album_id bigint,
    add foreign key (setlist_id) references setlist on delete cascade,
    add foreign key (song_id, album_id) references song on delete cascade;

alter table song
    add foreign key (album_id) references album on delete cascade;

alter table music_label
    add foreign key (user_id) references ticket_user on delete set null,
    add foreign key (address) references address on delete restrict;

alter table releases
    add foreign key (artist_id) references artist on delete cascade,
    add foreign key (album_id) references album on delete cascade,
    add foreign key (label_name) references music_label on delete cascade;

alter table organizer
    add foreign key (user_id) references ticket_user on delete set null,
    add foreign key (address) references address on delete restrict;


