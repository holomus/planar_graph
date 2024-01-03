create table t_devices(
  device_code               text not null,
  host                      text not null,
  login                     text not null,
  password                  text not null,
  constraint t_devices_pk primary key (device_code)
);

create table t_employees(
  device_code               text not null,
  employee_id               text not null,
  pin                       text not null,
  name                      text not null,
  constraint t_employees_pk primary key (device_code, employee_id),
  constraint t_employees_f1 foreign key (device_code) references t_devices(device_code)
);

create table t_employee_photos(
  device_code               text not null,
  employee_id               text not null,
  photo_sha                 text not null,
  synced                    text not null,
  constraint t_employee_photos_pk primary key (device_code, employee_id),
  constraint t_employee_photos_f1 foreign key (device_code) references t_devices(device_code),
  constraint t_employee_photos_f2 foreign key (device_code, employee_id) references t_employees(device_code, employee_id)
);

create table t_trackings(
  device_code               text not null,
  track_id                  text not null,
  employee_id               text not null,
  track_date                text not null,
  photo_sha                 text,
  status                    text not null,
  mask                      text not null,
  mark_type                 text not null,
  verified                  text not null,
  synced                    text not null,
  constraint t_trackings_pk primary key (device_code, track_id),
  constraint t_trackings_u1 unique (track_id),
  constraint t_trackings_f1 foreign key (device_code) references t_devices(device_code),
  constraint t_trackings_f2 foreign key (employee_id) references t_employees(employee_id)
);
