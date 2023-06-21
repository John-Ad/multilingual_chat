drop table Settings;

create table
    Settings(
        id int primary key,
        api_key text DEFAULT '',
        max_tokens int DEFAULT 100,
        context_messages_count int DEFAULT 3
    );

create table
    `Language`(
        id integer primary key autoincrement,
        name text not null
    );

drop table Conversation;

create table
    Conversation(
        id integer primary key autoincrement,
        language_id integer not null,
        name text not null,
        created_at timestamp not null default current_timestamp,
        updated_at timestamp not null default current_timestamp,
        foreign key (language_id) references `Language`(id) on delete cascade
    );

drop table Message;

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

insert into Language(name) values('Afrikaans');

insert into Language(name) values('Arabic');

insert into Language(name) values('Bengali');

insert into Language(name) values('Bulgarian');

insert into Language(name) values('Catalan');

insert into Language(name) values('English');

insert into Language(name) values('French');

insert into Language(name) values('German');

insert into Language(name) values('Hindi');

insert into Language(name) values('Indonesian');

insert into Language(name) values('Italian');

insert into Language(name) values('Japanese');

insert into Language(name) values('Korean');

insert into Language(name) values('Malay');

insert into Language(name) values('Portuguese');

insert into Language(name) values('Russian');

insert into Language(name) values('Spanish');