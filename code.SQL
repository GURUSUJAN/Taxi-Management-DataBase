create table taxi
(
taxi_id number not null,
taxi_model varchar2(100),
taxi_number varchar2(15),
taxi_current varchar2(100),
taxi_driver varchar2(100),
taxi_type varchar2(100),
primary key (taxi_id)
);
drop table taxi
insert into taxi values(1029,'VERNA','KA 19 EQ 1316','Running','Mohit','SEDAN');
insert into taxi values(1039,'THAR','AP 19 EQ 1316','Available','Rohit','SUV'); insert into taxi values(1049,'ETIOS','MH 19 EQ 1316','Running','Sam','SEDAN');
insert into taxi values(1059,'SWIFT','MP 19 EQ 1316','Available','David','HATCHBACK');
insert into taxi values(1069,'VERNA','PB 19 EQ 1316','Available','Ben','SEDAN');
select * from taxi
create table user_table
(
user_id number not null, fname varchar2(100),
sname varchar2(100), gender varchar2(10), contact_number number(10), address varchar2(100), taxi_id number,
 primary key(user_id),
foreign key (taxi_id) references taxi(taxi_id) --Using one table data in another relation (RDBMS)!
);
drop table user_table
insert into user_table values(2029,'Tim','Paine','M',12345,'Tasmania',1029); insert into user_table values(2039,'Pat','Cummins','M',12367,'Queensland',1039);
insert into user_table values(2049,'Aron','Finch','M',12389,'Melborne',1049); insert into user_table values(2059,'Nathon','Lyon','M',12445,'Sydeny',1059); insert into user_table values(2069,'Micheal','Starc','M',12467,'Perth',1069); select* from user_table
create table driver
(
driver_id number not null, driver_fname varchar2(100), driver_sname varchar2(100), driver_age number,
driver_gender varchar2(10), driver_contact_number number(10), primary key(driver_id)
);
drop table driver
insert into driver values(3029,'Quinton','Decock',30,'M',12489); insert into driver values(3039,'J.P','Duminy',35,'M',12545); insert into driver values(3049,'Chris','Morris',36,'M',12567); insert into driver values(3059,'Temba','Bavuma',37,'M',12589); insert into driver values(3069,'Kagiso','Rabada',39,'M',12645); select * from driver
create table trip_details
(
trip_id number not null, trip_cost number not null, trip_date date,

 driver_id number,
user_id number,
taxi_id number,
primary key(trip_id),
foreign key (taxi_id) references taxi(taxi_id),
foreign key (user_id) references user_table(user_id), foreign key (driver_id) references driver(driver_id)
);
drop table trip_details
insert into trip_details values(4029,1000,to_date('08/11/2022','mm/dd/ yyyy'),3029,2029,1029);
insert into trip_details values(4039,1500,to_date('11/11/2022','mm/dd/ yyyy'),3049,2069,1069);
insert into trip_details values(4049,1250,to_date('11/11/2022','mm/dd/ yyyy'),3029,2039,1039);
insert into trip_details values(4059,1050,to_date('04/11/2022','mm/dd/ yyyy'),3059,2059,1059);
insert into trip_details values(4069,930,to_date('01/11/2022','mm/dd/ yyyy'),3029,2049,1049);
update trip_details set driver_id=3039 where trip_id=4069;
select * from trip_details
create table bill
(
bill_id number(8) not null,
bill_cost number(8),
bill_discount number(2),
user_id number,
trip_id number,
primary key(bill_id),
foreign key (user_id) references user_table(user_id), foreign key (trip_id) references trip_details(trip_id)
);
drop table bill
insert into bill values(5029,900,10,2029,4029);
insert into bill values(5039,1200,20,2039,4039); insert into bill values(5049,1125,10,2069,4049);
 insert into bill values(5059,892,15,2059,4059); insert into bill values(5069,744,20,2049,4069); select * from bill
--PLSQL
declare
fname driver.driver_fname%type;
sname driver.driver_sname%type;
d_id driver.driver_id%type;
uname user_table.fname%type;
u_id user_table.user_id%type;
u_name user_table.fname%type;
ta_model taxi.taxi_model%type;
ta_number taxi.taxi_number%type;
ta_type taxi.taxi_type%type;
dest varchar2(100);
pick varchar2(100);
begin
--uname:='Nathon';
dest:='Amritsar';
pick:='LPU';
select driver_id,driver_fname,driver_sname into d_id,fname,sname from driver where driver_id=(select driver_id from trip_details where user_id=(select user_id from user_table where fname='Aron')); --dbms_output.put_line('Your Driver Name is'||' '||fname||' '||sname ||' '||'with Driver ID of'||' '||d_id);


dbms_output.put_line('Your Driver Name is'||' '||fname||' '||sname ||' '||'with Driver ID of'||' '||d_id||' '||'is waiting for you near'||' '||pick); dbms_output.put_line('Car Details');
select taxi_model,taxi_number,taxi_type into ta_model,ta_number,ta_type from taxi where taxi_id=(select taxi_id from trip_details where user_id=(select user_id from user_table where fname='Aron'));
dbms_output.put_line('Taxi Model:'||' '||ta_model); dbms_output.put_line('Taxi Number:'||' '||ta_number); dbms_output.put_line('Taxi Type:'||' '||ta_type); dbms_output.put_line('Hope you have a safe journey till'||' '||dest); exception
when no_data_found then dbms_output.put_line('Not a User'); end;
exception
when no_data_found then
dbms_output.put_line('oops!, Sorry no taxi is available for selected address!');
--PLSQL
declare
city user_table.address%type;
tnumber taxi.taxi_number%type;
tmodel taxi.taxi_model%type;
ttype taxi.taxi_type%type;
begin
select taxi_number,taxi_type,taxi_model into tnumber,ttype,tmodel from taxi where taxi_id=(select taxi_id from user_table where address='Melborne') and taxi_current='Available';
dbms_output.put_line('Car Number'||' '||tnumber);
dbms_output.put_line('Car Type'||' '||ttype);
dbms_output.put_line('Car Model'||' '||tmodel);
exception
when no_data_found then
dbms_output.put_line('OOPS!, Sorry Mate No Taxi Near You!');
end;
