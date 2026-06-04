begin;

alter table system.sys_user
    add column if not exists email text;

comment on column system.sys_user.email is '账号邮箱';

create index if not exists ix_sys_user_email
    on system.sys_user (email)
    where email is not null and email <> '';

commit;
