prompt HES External systems
prompt (c) 2023 Verifix HR

----------------------------------------------------------------------------------------------------
create table hes_billz_credentials(
  company_id                      number(20)     not null,
  filial_id                       number(20)     not null,
  subject_name                    varchar2(4000) not null,
  secret_key                      varchar2(4000) not null,
  constraint hes_billz_credentials_pk primary key (company_id, filial_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hes_billz_credentials is 'credentials to access Billz API';

----------------------------------------------------------------------------------------------------
create table hes_billz_consolidated_sales(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  sale_id                         number(20)         not null,
  billz_office_id                 number(20)         not null,
  billz_office_name               varchar2(500 char) not null,
  billz_seller_id                 number(20)         not null,
  billz_seller_name               varchar2(500 char) not null,
  sale_date                       date               not null,
  sale_amount                     number(20, 6),
  constraint hes_billz_consolidated_sales_pk primary key (company_id, filial_id, sale_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hes_billz_consolidated_sales is 'consolidated daily sales amount for each user from Billz';

----------------------------------------------------------------------------------------------------    
create global temporary table hes_billz_raw_sales(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  billz_office_id                 number(20)         not null,
  billz_office_name               varchar2(500 char) not null,
  billz_seller_id                 number(20)         not null,
  billz_seller_name               varchar2(500 char) not null,
  sale_date                       date               not null,
  sale_amount                     number(20, 6)
);

comment on table hes_billz_raw_sales is 'raw Billz sales data';

----------------------------------------------------------------------------------------------------
create table hes_billz_sale_dates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  sale_date                       date       not null,
  constraint hes_billz_sale_dates_pk primary key (company_id, filial_id, sale_date) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hes_billz_sale_dates is 'service table used for locking sale data by dates';

----------------------------------------------------------------------------------------------------
create table hes_oauth2_providers(
  provider_id                     number(20)    not null,
  token_url                       varchar2(250) not null,
  auth_url                        varchar2(250) not null,
  provider_name                   varchar2(250) not null,
  redirect_uri                    varchar2(250) not null,
  content_type                    varchar2(250) not null,
  scope                           varchar2(250),
  constraint hes_oauth2_providers_pk primary key (provider_id) using index tablespace GWS_INDEX,
  constraint hes_oauth2_providers_u1 unique (redirect_uri) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on column hes_oauth2_providers.content_type is 'Content type of get access token request to provider. (application/json or application/x-www-form-urlencoded)';

----------------------------------------------------------------------------------------------------
create table hes_oauth2_credentials(
  company_id                      number(20)    not null,
  provider_id                     number(20)    not null,
  client_id                       varchar2(128) not null,
  client_secret                   varchar2(128) not null,
  constraint hes_oauth2_credentials_pk primary key (company_id, provider_id) using index tablespace GWS_INDEX,
  constraint hes_oauth2_credentials_f2 foreign key (company_id) references md_companies(company_id) on delete cascade,
  constraint hes_oauth2_credentials_f1 foreign key (provider_id) references hes_oauth2_providers(provider_id) on delete cascade
) tablespace GWS_DATA;

create index hes_oauth2_credentials_i1 on hes_oauth2_credentials(provider_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hes_oauth2_session_states(
  company_id                      number(20)    not null,
  session_id                      number(20)    not null,
  provider_id                     number(20)    not null,
  state_token                     varchar2(128) not null,
  constraint hes_oauth2_session_states_pk primary key (company_id, session_id, provider_id) using index tablespace GWS_INDEX,
  constraint hes_oauth2_session_states_u1 unique (state_token) using index tablespace GWS_INDEX,
  constraint hes_oauth2_session_states_f1 foreign key (company_id, session_id) references kauth_sessions(company_id, session_id) on delete cascade,
  constraint hes_oauth2_session_states_f2 foreign key (provider_id) references hes_oauth2_providers(provider_id) on delete cascade
) tablespace GWS_DATA;

create index hes_oauth2_session_states_i1 on hes_oauth2_session_states(provider_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hes_oauth2_tokens(
  company_id                      number(20)    not null,
  user_id                         number(20)    not null,
  provider_id                     number(20)    not null,
  access_token                    varchar2(128) not null,
  refresh_token                   varchar2(128),
  expires_on                      timestamp with local time zone,
  constraint hes_oauth2_tokens_pk primary key (company_id, user_id, provider_id) using index tablespace GWS_INDEX,
  constraint hes_oauth2_tokens_f1 foreign key (company_id, user_id) references md_users(company_id, user_id) on delete cascade,
  constraint hes_oauth2_tokens_f2 foreign key (provider_id) references hes_oauth2_providers(provider_id) on delete cascade
) tablespace GWS_DATA;

create index hes_oauth2_tokens_i1 on hes_oauth2_tokens(provider_id) tablespace GWS_INDEX;
