--1. Create a database 

CREATE DATABASE MovieDb


--2. Create a table called Director with following columns: FirstName, LastName, Nationality and Birth date. 
--Insert 5 rows into it. 

CREATE TABLE Director (
Id int NOT NULL PRIMARY KEY, 
FirstName varchar(255), 
LastName varchar(255),
Nationality varchar (50),
Birth date)

INSERT INTO Director (Id,FirstName,LastName,Nationality,Birth) VALUES (1, 'Mungiu','Crisian','Romanian','12/28/1967');
INSERT INTO Director (Id,FirstName,LastName,Nationality,Birth) VALUES (2, 'Spielberg','Steven','American','12/18/1946');
INSERT INTO Director (Id,FirstName,LastName,Nationality,Birth) VALUES (3, 'Felini','Frederico','Italian','01/20/1920');
INSERT INTO Director (Id,FirstName,LastName,Nationality,Birth) VALUES (4, 'Potter','Sally','English','09/19/1949');
INSERT INTO Director (Id,FirstName,LastName,Nationality,Birth) VALUES (5, 'Peterson','Wolfgang','German','03/14/1941');

--DROP TABLE Director
SELECT * FROM Director 

--3. Delete the director with id = 3 

DELETE FROM Director WHERE Id=3


--4. Create a table called Movie with following columns: DirectorId, Title, ReleaseDate, Rating and Duration. 
--Each movie has a director. Insert some rows into it 

CREATE TABLE Movie (
Id int PRIMARY KEY NOT NULL,
DirectorId int,
Title varchar (100),
ReleaseDate date,
Rating decimal(2,1),
Duration time(0))


INSERT INTO Movie(Id,DirectorId,Title,ReleaseDate,Rating,Duration) VALUES (1,1,'Beyond the Hills','09/18/2012',4.5,'1:55:00')
INSERT INTO Movie(Id,DirectorId,Title,ReleaseDate,Rating,Duration) VALUES (2,2,'Jurassic Park','04/11/1994',4.0,'1:45:00')
INSERT INTO Movie(Id,DirectorId,Title,ReleaseDate,Rating,Duration) VALUES (4,4,'Ginger si Rosa','10/19/2011',3.1,'1:15:00')
INSERT INTO Movie(Id,DirectorId,Title,ReleaseDate,Rating,Duration) VALUES (5,5,'Troy','05/14/2004',3.5,'2:25:00')
INSERT INTO Movie(Id,DirectorId,Title,ReleaseDate,Rating,Duration) VALUES (6,1,'Fury','05/14/2016',4.5,'2:15:00')
INSERT INTO Movie(Id,DirectorId,Title,ReleaseDate,Rating,Duration) VALUES (7,2,'The Curious Case of Benjamin Button','02/20/2009',5.0,'2:46:00')
INSERT INTO Movie(Id,DirectorId,Title,ReleaseDate,Rating,Duration) VALUES (8,5,'The dark knight','07/25/2008',5.0,'2:32:00')

--5. Update all movies that have a rating lower than 10. 


UPDATE Movie 
SET Rating=Rating+4
WHERE Rating<10

--6. Create a table called Actor with following columns: FirstName, LastName, Nationality, Birth date and PopularityRating. 
--Insert some rows into it. 

CREATE TABLE Actor(
Id int PRIMARY KEY NOT NULL,
FirstName varchar(100),
LastName varchar(100),
Nationality varchar(50),
PopularityRating decimal (2,1) )

INSERT INTO Actor (Id,FirstName, LastName, Nationality,PopularityRating) VALUES (1,'Stratan','Cosmina','Romanian',7.5) 
INSERT INTO Actor (Id,FirstName, LastName, Nationality,PopularityRating) VALUES (2,'Neil','Sam','American',9.5) 
INSERT INTO Actor (Id,FirstName, LastName, Nationality,PopularityRating) VALUES (3,'Fenning','Elle','English',6.5) 
INSERT INTO Actor (Id,FirstName, LastName, Nationality,PopularityRating) VALUES (4,'Pitt','Brad','American',9.7)

SELECT * FROM Actor

--7. Which is the movie with the lowest rating? 

SELECT Title FROM Movie
WHERE Rating=(SELECT MIN(Rating) FROM Movie)

--8. Which director has the most movies directed? 

SELECT DirectorId, COUNT(Id) AS NumberOfMovies
FROM Movie
GROUP BY DirectorId
HAVING COUNT(Id) >= ALL(SELECT COUNT(Id) 
						 FROM Movie 
						 GROUP BY DirectorId)

--9. Display all movies ordered by director's LastName in ascending order, then by birth date descending. 

SELECT Title FROM Movie m
JOIN Director d ON d.Id=m.DirectorId
ORDER BY d.LastName ASC, d.Birth DESC

--12. Create a stored procedure that will increment the rating by 1 for a given movie id. 

USE MovieDb
GO
CREATE PROCEDURE IncrementRating @Id int
AS
BEGIN
UPDATE Movie
SET Rating = Rating +1 
WHERE Id=@Id
END
GO

SELECT * FROM Movie

--15. Implement many to many relationship between Movie and Actor 

CREATE TABLE MovieActor(
MovieId int NOT NULL,
ActorId int NOT NULL)

INSERT INTO MovieActor (MovieId, Actorid) VALUES(1,1)
INSERT INTO MovieActor (MovieId, Actorid) VALUES(2,2)
INSERT INTO MovieActor (MovieId, Actorid) VALUES(4,3)
INSERT INTO MovieActor (MovieId, Actorid) VALUES(5,4)
INSERT INTO MovieActor (MovieId, Actorid) VALUES(6,4)
INSERT INTO MovieActor (MovieId, Actorid) VALUES(7,4)
INSERT INTO MovieActor (MovieId, Actorid) VALUES(8,1)

--SELECT ALL MOVIES FOR AN ACTOR

SELECT m.Id, m.Title  
FROM MovieActor ma
INNER JOIN Movie m ON m.Id=ma.MovieId
WHERE ma.ActorId=4

--SELECT ALL ACTORS FOR A MOVIE

SELECT a.FirstName, a.LastName
FROM MovieActor ma
INNER JOIN Actor a ON a.Id=ma.ActorId
WHERE ma.MovieId=6


--16. Implement many to many relationship between Movie and Genre 

--a)create table MovieGenre

CREATE TABLE MovieGenre(
MovieId int NOT NULL,
GenreId int NOT NULL)

--b)create table Genre

CREATE TABLE Genre(
Id int PRIMARY KEY NOT NULL,
NameGenre varchar(20))

--c)insert data into Genre

INSERT INTO Genre (Id,NameGenre) VALUES (1,'Drama')
INSERT INTO Genre (Id,NameGenre) VALUES (2,'Adventure')
INSERT INTO Genre(Id,NameGenre) VALUES(3,'History')
INSERT INTO Genre(Id,NameGenre) VALUES(4,'Action')

--d)insert data into MovieGenre

INSERT INTO MovieGenre (MovieId,GenreId) VALUES (1,1)
INSERT INTO MovieGenre (MovieId,GenreId) VALUES (2,2)
INSERT INTO MovieGenre (MovieId,GenreId) VALUES (4,1)
INSERT INTO MovieGenre (MovieId,GenreId) VALUES (5,3)
INSERT INTO MovieGenre (MovieId,GenreId) VALUES (6,4)
INSERT INTO MovieGenre (MovieId,GenreId) VALUES (7,1)
INSERT INTO MovieGenre (MovieId,GenreId) VALUES (5,1)
INSERT INTO MovieGenre (MovieId,GenreId) VALUES (8,4)

SELECT * FROM MovieGenre

--e)Select all movies for a genre

SELECT m.Title 
FROM MovieGenre mg
INNER JOIN Movie m ON mg.MovieId=m.Id
WHERE mg.GenreId=1

--f)Select all genres for a movie

SELECT g.NameGenre 
FROM MovieGenre mg
INNER JOIN Genre g ON mg.GenreId=g.Id
WHERE mg.MovieId=5

--17. Which actor has worked with the most distinct movie directors? 

SELECT a.Id,COUNT(d.Id) AS NumberOfDirectors 
FROM Actor a
INNER JOIN MovieActor ma ON ma.ActorId=a.Id
INNER JOIN Movie m ON m.Id=ma.MovieId
INNER JOIN Director d ON m.DirectorId=d.Id
GROUP BY a.Id 
HAVING COUNT(d.Id)>=ALL(SELECT COUNT(d.Id)
FROM Actor a
INNER JOIN MovieActor ma ON  a.Id=ma.ActorId
INNER JOIN Movie m ON ma.MovieId=m.Id
INNER JOIN Director d ON m.DirectorId=d.Id
GROUP BY a.Id)



--18. Which is the preferred genre of each actor?

SELECT a.FirstName, a.LastName,g.NameGenre
FROM Actor a 
INNER JOIN MovieActor ma ON a.Id=ma.ActorId 
INNER JOIN Movie m ON ma.MovieId =m.Id 
INNER JOIN MovieGenre mg ON m.Id=mg.MovieId 
INNER JOIN Genre g ON mg.GenreId=g.Id
