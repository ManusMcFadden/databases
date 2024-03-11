/*
@Manus McFadden

This is an sql file to put your queries for SQL coursework. 
You can write your comment in sqlite with -- or / * * /

To read the sql and execute it in the sqlite, simply
type .read sqlcwk.sql on the terminal after sqlite3 musicstore.db.
*/

/* =====================================================
   WARNNIG: DO NOT REMOVE THE DROP VIEW
   Dropping existing views if exists
   =====================================================
*/
DROP VIEW IF EXISTS vNoCustomerEmployee; 
DROP VIEW IF EXISTS v10MostSoldMusicGenres; 
DROP VIEW IF EXISTS vTopAlbumEachGenre; 
DROP VIEW IF EXISTS v20TopSellingArtists; 
DROP VIEW IF EXISTS vTopCustomerEachGenre; 

/*
============================================================================
Task 1: Complete the query for vNoCustomerEmployee.
DO NOT REMOVE THE STATEMENT "CREATE VIEW vNoCustomerEmployee AS"
============================================================================
*/
CREATE VIEW vNoCustomerEmployee AS
SELECT EmployeeId, FirstName, LastName, Title
FROM employees
WHERE employees.EmployeeId NOT IN (SELECT SupportRepId FROM customers)
/*
============================================================================
Task 2: Complete the query for v10MostSoldMusicGenres
DO NOT REMOVE THE STATEMENT "CREATE VIEW v10MostSoldMusicGenres AS"
============================================================================
*/
CREATE VIEW v10MostSoldMusicGenres AS
SELECT genres.Name AS Genre, SUM(invoice_items.Quantity) AS Sales
FROM genres, tracks, invoice_items
WHERE genres.GenreId = tracks.GenreId AND tracks.TrackId = invoice_items.TrackId
GROUP BY genres.Name
ORDER BY sales DESC
LIMIT 10
/*
============================================================================
Task 3: Complete the query for vTopAlbumEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopAlbumEachGenre AS"
============================================================================
*/
DROP VIEW IF EXISTS view2;
CREATE VIEW view2 AS
SELECT genres.GenreId, genres.Name AS Genre, albums.Title As Album, artists.Name As Artist, SUM(invoice_items.Quantity) AS Sales
FROM genres, albums, artists, invoice_items, tracks
WHERE genres.GenreId = tracks.GenreId AND tracks.TrackId = invoice_items.TrackId AND tracks.AlbumId = Albums.AlbumId AND albums.ArtistID = artists.ArtistId
GROUP BY genres.GenreId, albums.AlbumId, artists.artistId;

CREATE VIEW vTopAlbumEachGenre AS
SELECT Genre, Album, Artist, MAX(Sales)
FROM view2
GROUP BY Genre
ORDER BY GenreId;
/*
============================================================================
Task 4: Complete the query for v20TopSellingArtists
DO NOT REMOVE THE STATEMENT "CREATE VIEW v20TopSellingArtists AS"
============================================================================
*/
DROP VIEW IF EXISTS view1;
CREATE VIEW view1 AS
SELECT artists.Name AS Artist, COUNT(DISTINCT albums.AlbumId) AS TotalAlbum, SUM(invoice_items.Quantity) AS TrackSold
FROM artists, albums, tracks, invoice_items
WHERE artists.ArtistId = albums.ArtistId AND albums.AlbumId = tracks.AlbumId AND tracks.TrackId = invoice_items.TrackId
GROUP BY artists.Name;

CREATE VIEW v20TopSellingArtists AS
SELECT * FROM view1
ORDER BY TrackSold DESC
LIMIT 20;
/*
============================================================================
Task 5: Complete the query for vTopCustomerEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopCustomerEachGenre AS" 
============================================================================
*/
DROP VIEW IF EXISTS view3;
CREATE VIEW view3 AS
SELECT genres.Name AS Genre, customers.FirstName || ' ' || customers.LastName AS TopSpender, ROUND(SUM(invoice_items.Quantity * invoice_items.UnitPrice), 2) AS TotalSpending
FROM genres, albums, tracks, invoice_items, invoices, customers
WHERE genres.GenreId = tracks.GenreId AND tracks.AlbumId = albums.AlbumId AND tracks.TrackId = invoice_items.TrackId AND invoice_items.InvoiceId = invoices.InvoiceId AND invoices.CustomerId = customers.CustomerId
GROUP BY genres.Name, customers.CustomerId;

CREATE VIEW vTopCustomerEachGenre AS
SELECT Genre, TopSpender, Max(TotalSpending)
FROM view3
GROUP BY Genre;






