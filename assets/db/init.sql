create table
    Settings(
        id int primary key,
        api_key text DEFAULT '',
        max_tokens int DEFAULT 100,
        context_messages_count int DEFAULT 3
    );

create table
    `Language`(
        id int primary key autoincrement,
        name text not null
    );

create table
    Conversation(
        id integer primary key autoincrement,
        language_id int not null,
        name text not null,
        created_at timestamp not null default current_timestamp,
        updated_at timestamp not null default current_timestamp,
        foreign key (language_id) references `Language`(id) on delete cascade
    );

create table
    Message(
        id integer primary key autoincrement,
        is_user_message bit not null,
        conversation_id integer not null,
        correction text,
        content text not null,
        translation text,
        created_at timestamp not null default current_timestamp,
        updated_at timestamp not null default current_timestamp,
        foreign key (conversation_id) references Conversation(id) on delete cascade
    );

insert into Settings(id, api_key) values(1,'');

/*Insert 2 popular languages into Language table from each continent that uses latin characters*/

insert into Language(id, name) values('Afrikaans');

insert into Language(id, name) values('Arabic');

insert into Language(id, name) values('Bengali');

insert into Language(id, name) values('Bulgarian');

insert into Language(id, name) values('Catalan');

insert into Language(id, name) values('English');

insert into Language(id, name) values('French');

insert into Language(id, name) values('German');

insert into Language(id, name) values('Hindi');

insert into Language(id, name) values('Indonesian');

insert into Language(id, name) values('Italian');

insert into Language(id, name) values('Japanese');

insert into Language(id, name) values('Korean');

insert into Language(id, name) values('Malay');

insert into Language(id, name) values('Portuguese');

insert into Language(id, name) values('Russian');

insert into Language(id, name) values('Spanish');