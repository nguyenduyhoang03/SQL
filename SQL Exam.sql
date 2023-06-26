--1. Create a database as requested above.
create database NTB_DB
--2. Create table based on the above design.
create table Location (
	LocationID char(6) not null unique,
	primary key (locationID),
	Name nvarchar(50) not null,
	Description nvarchar(100)
)
create table Land (
	LandId int identity not null unique,
	primary key(LandId),
	Title nvarchar(100) not null,
	LocationID char(6) not null,
	foreign key (LocationID) references Location(locationID),
	Detail nvarchar(6),
	StartDate datetime not null,
	EndDate datetime not null
)
create table Building (
	BuildingID int identity not null unique,
	primary key(BuildingId),
	LandID int not null,
	foreign key (LandID) references Land(LandID),
	BuildingType nvarchar(50),
	Area int default 50,
	Floors int default 1,
	Rooms int default 1,
	Cost money
)
--3. Insert into each table at least three records.
INSERT INTO Location (LocationID,Name,Description)
values  (118000,'Ba Dinh','Gan lang chu tich'),
		(100000,'My Dinh','Gan san van dong My Dinh'),
		(124600,'Tay Ho','Gan Ho Tay')
INSERT INTO Land (LandId,Title,LocationID,StartDate,EndDate)
values	(01,'My Dinh',100000,'2009-10-10','2010-10-10'),
		(02,'Ba Dinh',118000,'2010-12-12','2012-10-12'),
		(03,'Tay Ho',124600,'2012-5-23','2015-5-23')
INSERT INTO Building (BuildingID,LandID,Area,Floors,Rooms,Cost)
values	(123,01,200,10,100,1000000),
		(124,02,300,12,120,2000000),
		(125,03,400,16,160,3000000)
--4. List all the buildings with a floor area of 100m2 or more.
select * from Building where Area >= 100;
--5. List the construction land will be completed before January 2013.
select * from Land where EndDate < '2013-1-1'
--6. List all buildings to be built in the land of title "My Dinh”
select * from Building b
Join land l On l.LandId = b.LandID
where Title = 'My Dinh'
/*7. Create a view v_Buildings contains the following information (BuildingID, Title, Name,
BuildingType, Area, Floors) from table Building, Land and Location. */
CREATE VIEW v_Buildings AS
SELECT b.BuildingID, l.Title, loc.Name, b.BuildingType, b.Area, b.Floors
FROM Building b
JOIN Land l ON b.LandID = l.LandID
JOIN Location loc ON l.LocationID = loc.LocationID;
--8. Create a view v_TopBuildings about 5 buildings with the most expensive price per m2.
create view v_TopBuildings as
select top 5 b.BuildingID,l.Title,loc.Name,b.Area,b.Cost from Building b
join Land l ON l.LandId = b.LandID
join Location loc ON loc.LocationID = l.LocationID
order by Cost DESC
/*9. Create a store called sp_SearchLandByLocation with input parameter is the area code 
and retrieve planned land for this area. */
create proc sp_SearchLandByLocation @locationID char(6)
as
begin
	select loc.LocationID,loc.Name,loc.Description,l.Title,l.StartDate,l.EndDate
	from Location loc
	join Land l On l.LocationID = loc.LocationID
	where @locationID = loc.LocationID
end
/* 10. Create a store called sp_SearchBuidingByLand procedure input parameter is the land
code and retrieve the buildings built on that land. */
create proc sp_SearchBuildingByLand @LandID int
as
begin
	select l.Title,.BuildingID,b.BuildingType,b.Area,b.Floors,b.Rooms,b.Cost
	from Land l
	join Building b ON b.LandID = l.LandId
	where @LandID = l.LandId
end
/* 11. Create a trigger tg_RemoveLand allows to delete only lands which have not any
buildings built on it.*/
CREATE TRIGGER tg_RemoveLand
ON Land
INSTEAD OF DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Building WHERE LandID IN (SELECT LandID FROM deleted))
    BEGIN
        DELETE FROM Land WHERE LandID IN (SELECT LandID FROM deleted)
    END
    ELSE
    BEGIN
        RAISERROR('This land cannot be deleted because there are buildings built on it.', 16, 1)
    END
END;
