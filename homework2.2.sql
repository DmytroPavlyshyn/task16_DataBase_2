drop database if exists students;
create database students
character set utf8
collate utf8_general_ci;

use students;

drop table if exists county;
create table country(
	id int auto_increment not null primary key,
	name varchar(45) not null unique
);

drop table if exists region;
create table region(
	id int auto_increment not null primary key,
	name varchar(45) not null unique,
    country_id int,
    constraint fk_county_id
    foreign key(country_id)
		references country(id)
);

drop table if exists city;
create table city(
	id int auto_increment not null primary key,
	name varchar(45) not null unique,
    region_id int,
    constraint fk_region_id
    foreign key(region_id)
		references region(id)
);

drop table if exists academic_group;
create table academic_group(
	id int  auto_increment not null primary key,
	speciality varchar(45) not null,
    code int not null,
    start_date date not null
);

drop table if exists student;
create table student(
	id int auto_increment not null primary key,
	first_name varchar(45) not null,
    last_name varchar(45) not null,
    middle_name varchar(45) not null,
    photo blob null,
    autobiography text null,
    academic_group_id int  null,
    entry_year year not null,
    birth_year year not null,
    rating float,
	scholarship int,
    city_id int
);

alter table student
	add constraint fk_academic_group_id
    foreign key (academic_group_id)
		references academic_group(id);
alter table student
	add constraint fk_city_id
    foreign key (city_id)
		references city(id);	

drop table if exists teacher;
create table teacher(
	id int auto_increment primary key,
	flm_name varchar(45)
);

drop table if exists subject;
create table subject(
	id int auto_increment unique,
	name varchar(45),
	teacher_id int,
	foreign key(teacher_id)
		references teacher(id)
);

drop table if exists student_has_subject;
create table student_has_subject (
	student_id int not null,
    subject_id int not null,
    module_1 float not null,
    module_2 float not null,
    type_of_control enum('exam', 'test'),
    mark_in_100 int,
    mark_in_5 int,
    term int
);
alter table student_has_subject
	add constraint pk_student_subject
		primary key(student_id, subject_id);

