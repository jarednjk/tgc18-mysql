#to start
mysql -u root;

create database employees;

# show databases

show databases;

# befoer we can issue commands for databases

use employees;

#create a new table

create table employees (
    employee_id int unsigned auto_increment primary key,
    email varchar(320),
    gender varchar(1),
    notes text,
    employment_date date,
    designation varchar(100)
) engine = innodb;

create table department (
    department_id int unsigned auto_increment primary key,
    name varchar(100)
) engine = innodb;

create table parents (
    parent_id int unsigned auto_increment primary key,
    name varchar(100),
    contact_no varchar(8),
    occupation varchar(100)
) engine = innodb;

create table addresses (
    address_id int unsigned auto_increment primary key,
    parent_id int unsigned not null,
    block_number varchar(100),
    street_name varchar(100),
    unit_number varchar(100),
    postal_code varchar(10) 
) engine = innodb;

create table locations (
    location_id mediumint unsigned auto_increment primary key,
    name varchar(100) not null,
    address varchar(255) not null
) engine = innodb;

create table students (
    student_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    date_of_birth date not null,
    parent_id int unsigned not null,
    foreign key (parent_id) references parents(parent_id)
) engine = innodb;

# show table
show tables;

# show columns in table
describe employees;

#delete a table

drop table employees;

#inserting rows

insert into employees (
    email, gender, notes, employment_date, designation, name
) values ('asd@asd.com', 'm', 'Newbie', curdate(), 'Intern', 'Henry');

insert into department (name) values ('Accounting'),('Human Resource'),('IT');

insert into parents (name, contact_no, occupation) values ('Alvin', '78765432', 'engineer');

insert into parents (name, contact_no, occupation) values 
    ('Cheena', '78265432', 'lawyer'),
    ('Lucas', '70765432', 'dentist');

insert into locations (name, address) values ("Yishun Swimming Complex", "Yishun Ave 4");

insert into addresses (block_number, street_name, postal_code) values ('66', 'Alvis Road', '233456');

insert into students (name, date_of_birth, parent_id) values ('Cindy Tan', '2020-06-11', 1);

#see all the rows in a table
select * from employees;

#update one row in a table
update employees set email="asd@gmail.com" where employee_id = 1;

#delete one row
delete from employees where employee_id = 1;

# add a new column in a table
alter table employees add column name varchar(100);

alter table employees rename column name first_name;

# add a fk between employees and department
#set 1: add the column
alter table employees add column department_id int unsigned not null;
#step 2: indicate the newly added column to be a fk
alter table employees add constraint fk_employees_department
    foreign key(department_id) references department(department_id)


alter table addresses add constraint fk_addresses_parents
    foreign key (parent_id) references parents (parent_id);

insert into addresses (block_number, street_name, postal_code, parent_id) values ('38', 'Mountbatten Road', '823456', 4);