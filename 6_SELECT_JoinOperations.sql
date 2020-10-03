-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962;

-- Give year of 'Citizen Kane'.
SELECT yr FROM movie
  WHERE title = 'Citizen Kane';

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr FROM movie
  WHERE title LIKE 'Star Trek%'
ORDER BY yr;

-- What id number does the actor 'Glenn Close' have?
SELECT DISTINCT(id) FROM actor
  JOIN casting ON casting.actorid = actor.id
    WHERE actor.name = 'Glenn Close';

-- What is the id of the film 'Casablanca'
SELECT id FROM movie
  WHERE title = 'Casablanca';

-- Obtain the cast list for 'Casablanca'.
SELECT name FROM actor
  JOIN casting ON actor.id = casting.actorid
    WHERE casting.movieid = (SELECT id FROM movie
                               WHERE title =
                               'Casablanca');

-- Obtain the cast list for the film 'Alien'
SELECT name FROM actor
  JOIN casting ON actor.id = casting.actorid
    WHERE casting.movieid = (SELECT id FROM movie
                               WHERE title =
                               'Alien');

-- List the films in which 'Harrison Ford' has appeared
SELECT DISTINCT(movie.title) FROM movie
 JOIN casting ON movie.id = casting.movieid
  WHERE casting.movieid IN (SELECT casting.movieid FROM
                           casting
                            JOIN actor ON
                            casting.actorid = actor.id
                             WHERE actor.name =
                             'Harrison Ford');

-- List the films where 'Harrison Ford' has appeared - but not in the starring role.
SELECT DISTINCT(movie.title) FROM movie
  JOIN casting ON movie.id = casting.movieid
    WHERE movie.id IN (SELECT casting.movieid FROM
    casting
  JOIN actor ON casting.actorid = actor.id
    WHERE (actor.name = 'Harrison Ford') AND
            (casting.ord != 1));

-- List the films together with the leading star for all 1962 films.
SELECT DISTINCT(movie.title), actor.name FROM movie
  JOIN casting ON movie.id = casting.movieid
  JOIN actor ON casting.actorid = actor.id
    WHERE yr = 1962
      AND ord = 1;

-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT movie.yr AS Year, COUNT(movie.title) AS NumberOfMovies FROM movie
  JOIN casting ON casting.movieid = movie.id
  JOIN actor ON actor.id = casting.actorid
WHERE actor.name = 'Rock Hudson'
GROUP BY movie.yr
HAVING COUNT(movie.title) > 2

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT movie.title, actor.name FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
  WHERE (movie.id IN (SELECT movie.id FROM movie
                  JOIN casting ON casting.movieid = movie.id
                  JOIN actor ON actor.id = casting.actorid
                  WHERE actor.name = 'Julie Andrews'))
        AND (ord = 1)

-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT actor.name FROM actor
  JOIN casting ON actor.id = casting.actorid
  JOIN movie ON casting.movieid = movie.id
    WHERE ord = 1
GROUP BY actor.name
HAVING COUNT(actor.name) >= 15
ORDER BY actor.name ASC

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT movie.title, COUNT(casting.movieid) FROM movie
  JOIN casting ON movie.id = casting.movieid
  JOIN actor ON actor.id = casting.actorid
    WHERE movie.yr = 1978
GROUP BY movie.title
ORDER BY COUNT(casting.movieid) DESC, movie.title

-- List all the people who have worked with 'Art Garfunkel'.
SELECT actor.name FROM actor
  JOIN casting ON actor.id = casting.actorid
  JOIN movie ON casting.movieid = movie.id
    WHERE movie.id IN (SELECT movie.id FROM movie
                   JOIN casting ON movie.id = casting.movieid
                   JOIN actor ON casting.actorid = actor.id
                   WHERE actor.name = 'Art Garfunkel')
    AND actor.name != 'Art Garfunkel'
