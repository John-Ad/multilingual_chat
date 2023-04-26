drop table Settings;

create table
    Settings(
        id int primary key,
        api_key text DEFAULT '',
        max_tokens int DEFAULT 100,
        context_messages_count int DEFAULT 3
    );

drop table Conversation;

create table
    Conversation(
        id integer primary key autoincrement,
        name text not null,
        created_at timestamp not null default current_timestamp,
        updated_at timestamp not null default current_timestamp
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
        foreign key (conversation_id) references Conversation(id)
    );

insert into Settings(id, api_key) values(1,'');