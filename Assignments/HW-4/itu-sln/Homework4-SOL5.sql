-- (a)

select count(*) 
from Songs 
where Duration <= interval '1 minute';
-- 372

select count(*)
from Songs
where Duration > interval '1 hour';
-- 2

-- (b)

select extract(epoch from sum(Duration))
from Songs;
-- 3883371

-- (c)

select count(*)
from Songs
where extract(year from ReleaseDate) = 1953;
-- 5

select max(C) 
from (
	select extract(year from ReleaseDate), count(*) C 
	from Songs 
	group by extract(year from ReleaseDate)
) X;
-- 833

select max(C) 
from (
	select count(*) C 
	from Songs 
	group by extract(year from ReleaseDate)
) X;
-- 833

-- year of most songs
select extract(year from ReleaseDate) 
from Songs 
group by extract(year from ReleaseDate)
having count(*) = (
	select max(C) 
	from (
		select extract(year from ReleaseDate), count(*) C 
		from Songs 
		group by extract(year from ReleaseDate)
	)X
);
-- 2009

drop view if exists year_count;
create view year_count 
as
select extract(year from ReleaseDate) as yr, count(*) as cnt
from Songs 
group by extract(year from ReleaseDate);

select yr
from year_count YC
where cnt = (select max(cnt) from year_count);

select 
	
-- (d)

select count(AA.AlbumId) 
from AlbumArtists AA 
	join Artists AR on AA.ArtistId = AR.ArtistId 
where artist='Queen';
-- 12

select count(AA.AlbumId) 
from AlbumArtists AA 
	join Artists AR on AA.ArtistId = AR.ArtistId 
where artist='Tom Waits';
-- 24

-- (e)

select count(distinct AG.AlbumId) 
from Genres G
	join AlbumGenres AG on AG.GenreId = G.GenreId
where G.Genre LIKE 'Ele%';
-- 187

select count(distinct AG.AlbumId) 
from Genres G
	join AlbumGenres AG on AG.GenreId = G.GenreId
where G.Genre LIKE 'Alt%';
-- 421

-- (f)

-- grouping solution

-- near miss: number of titles with > 1 songs
select count(*)
from (
	select S.title, count (S.songId) as num
	from Songs S
	group by S.title
	having count(*) > 1
) X;

-- correct: number of songs with duplicate titles
select sum(num)
from (
	select count (S.songId) as num
	from Songs S
	group by S.title
	having count(*) > 1
) X;
-- 2072

-- self-join solution (the note is about this solution)

-- explain analyse
select count(distinct S2.songId) 
from Songs S1
	join Songs S2 on S1.title = S2.title
where S1.songId <> S2.songId;
-- 2072

-- Does an index improve performance?
-- (only for the self-join, and even then the answer should be "no")
create index i1 on Songs(Title, SongId);

-- (g)

select count(*) 
from Albums 
where AlbumId not in (
	select AG.AlbumId 
	from Genres G
		join AlbumGenres AG on G.GenreId = AG.GenreId
	where genre='Rock'
);
-- 1215

-- Near miss: all albums with some genre other than rock
select count(distinct AG.albumId) 
from AlbumGenres AG 
	join Genres G on G.GenreId = AG.GenreId
where G.genre <>'Rock';
-- 1222

-- Near miss: all albums with some genre, where one is not rock
select count(distinct AlbumId) 
from AlbumGenres 
where AlbumId not in (
	select AG.AlbumId 
	from Genres G
		join AlbumGenres AG on G.GenreId = AG.GenreId
	where genre='Rock'
);
-- 1213

select count(*) 
from Albums 
where AlbumId not in (
	select AG.AlbumId 
	from Genres G
		join AlbumGenres AG on G.GenreId = AG.GenreId
	where genre='HipHop'
);
-- 1278

