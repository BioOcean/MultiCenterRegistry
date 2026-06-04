create table if not exists mcr.article (
    id uuid primary key,
    old_article_id text null,
    topic_id text null,
    type integer not null default 1,
    status integer not null default 0,
    title text not null default '',
    content text not null default '',
    cover text null,
    created_at timestamp not null default now(),
    created_by text null,
    updated_at timestamp null,
    updated_by text null
);

comment on table mcr.article is '文献、门户介绍和系统消息';
comment on column mcr.article.type is '1 门户介绍，2 系统消息';
comment on column mcr.article.status is '0 草稿/未发布，1 已发布';

create unique index if not exists ux_article_old_article_id
    on mcr.article(old_article_id)
    where old_article_id is not null;

create index if not exists ix_article_type_status_created
    on mcr.article(type, status, created_at desc);

create table if not exists mcr.portal_config (
    code text primary key,
    title text null,
    value text not null default '',
    updated_at timestamp not null default now(),
    updated_by text null
);

comment on table mcr.portal_config is '门户和登录页配置';

insert into mcr.portal_config (code, title, value, updated_at)
values
    ('MCR.loginset.headerTitle', '门户标题', '', now()),
    ('MCR.loginset.headerContent', '门户介绍', '', now())
on conflict (code) do nothing;
