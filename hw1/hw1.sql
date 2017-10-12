DROP VIEW IF EXISTS q0, q1i, q1ii, q1iii, q1iv, q2i, q2ii, q2iii, q3i, q3ii, q3iii, q4i, q4ii, q4iii, q4iv;

-- Question 0
CREATE VIEW q0(era) 
AS
  SELECT MAX(era)
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM master
  WHERE weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM master
  WHERE namefirst LIKE '% %'
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height), COUNT(DISTINCT playerid)
  FROM master
  GROUP BY birthyear
  HAVING COUNT(playerid) > 0
  ORDER BY birthyear
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT *
  FROM q1iii
  WHERE avgheight > 70
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT namefirst, namelast, master.playerid, yearid
  FROM master, halloffame
  WHERE master.playerid = halloffame.playerid AND halloffame.inducted = 'Y'
  ORDER BY yearid DESC
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT q.namefirst, q.namelast, q.playerid, c.schoolid, q.yearid
  FROM q2i q, collegeplaying c, schools s
  WHERE q.playerid = c.playerid AND c.schoolid = s.schoolid AND s.schoolstate = 'CA'
  ORDER BY q.yearid DESC, c.schoolid ASC, q.playerid ASC
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT *
  FROM ((SELECT m.playerid, m.namefirst, m.namelast, c.schoolid
          FROM master m, collegeplaying c
          WHERE m.playerid = c.playerid AND m.playerid IN
              (SELECT q.playerid
              FROM q2i q))
         UNION ALL
         (SELECT m.playerid, m.namefirst, m.namelast, NULL
         FROM master AS m
         WHERE m.playerid IN (SELECT q.playerid FROM q2i q)
             AND m.playerid NOT IN (SELECT c.playerid FROM collegeplaying c))) AS iii(playerid, namefirst, namelast, schoolid)
  ORDER BY playerid DESC, schoolid
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT m.playerid, m.namefirst, m.namelast, b.yearid, CAST(((b.h - b.h2b - b.h3b - b.hr) + 2 * b.h2b + 3 * b.h3b + 4 * b.hr) / (1.0 * b.ab) AS FLOAT) AS slg
  FROM master AS m, batting AS b
  WHERE m.playerid = b.playerid AND b.ab > 50
  ORDER BY slg DESC, b.yearid DESC, m.playerid ASC
  LIMIT 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT m.playerid, m.namefirst, m.namelast, CAST(((b.h - b.h2b - b.h3b - b.hr) + 2 * b.h2b + 3 * b.h3b + 4 * b.hr) / (1.0 * b.ab) AS FLOAT) AS lslg
  FROM master AS m,
          (SELECT playerid, SUM(h), SUM(h2b), SUM(h3b), SUM(hr), SUM(ab)
            FROM batting
            GROUP BY playerid) AS b(playerid, h, h2b, h3b, hr, ab)
  WHERE m.playerid = b.playerid AND b.ab > 50
  ORDER BY lslg DESC, m.playerid ASC
  LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  WITH b(playerid, h, h2b, h3b, hr, ab) AS
  (SELECT playerid, SUM(h), SUM(h2b), SUM(h3b), SUM(hr), SUM(ab)
   FROM batting
   GROUP BY playerid)
  SELECT m.namefirst, m.namelast, CAST(((b.h - b.h2b - b.h3b - b.hr) + 2 * b.h2b + 3 * b.h3b + 4 * b.hr) / (1.0 * b.ab) AS FLOAT) AS lslg
  FROM master AS m, b
  WHERE m.playerid = b.playerid
  AND b.ab > 50
  AND CAST(((b.h - b.h2b - b.h3b - b.hr) + 2 * b.h2b + 3 * b.h3b + 4 * b.hr) / (1.0 * b.ab) AS FLOAT) > ALL
               (SELECT CAST(((b.h - b.h2b - b.h3b - b.hr) + 2 * b.h2b + 3 * b.h3b + 4 * b.hr) / (1.0 * b.ab) AS FLOAT)
                FROM b
                WHERE playerid = 'mayswi01')
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg, stddev)
AS
  SELECT yearid, MIN(salary), MAX(salary), AVG(salary), STDDEV(salary)
  FROM salaries
  GROUP BY yearid
  ORDER BY yearid ASC
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  WITH stat(low, high, wide) AS
  (SELECT MIN(salary), MAX(salary), (MAX(salary) - MIN(salary)) / 10
   FROM salaries
   WHERE yearid = 2016
  )
  SELECT binid, low + wide * binid, low + wide * binid + wide, count
  FROM (
      SELECT binid, COUNT(*)
      FROM (SELECT salary,
              CASE WHEN salary < low + wide THEN 0
                WHEN salary < low + 2 * wide THEN 1
                WHEN salary < low + 3 * wide THEN 2
                WHEN salary < low + 4 * wide THEN 3
                WHEN salary < low + 5 * wide THEN 4
                WHEN salary < low + 6 * wide THEN 5
                WHEN salary < low + 7 * wide THEN 6
                WHEN salary < low + 8 * wide THEN 7
                WHEN salary < low + 9 * wide THEN 8
                ELSE 9
              END
             FROM salaries, stat
             WHERE yearid = 2016) AS data(salary, binid)
      GROUP BY binid) AS separate(binid, count), stat
  ORDER BY binid
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT c.yearid, c.low - l.low, c.high - l.high, c.average - l.average
  FROM (SELECT yearid, MIN(salary), MAX(salary), AVG(salary)
        FROM salaries
        GROUP BY yearid) AS c(yearid, low, high, average),
       (SELECT yearid, MIN(salary), MAX(salary), AVG(salary)
        FROM salaries
        GROUP BY yearid) AS l(yearid, low, high, average)
  WHERE c.yearid - l.yearid = 1
  ORDER BY yearid ASC
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  SELECT s.playerid, m.namefirst, m.namelast, s.salary, s.yearid
  FROM salaries AS s,
       (SELECT MAX(salary)
        FROM salaries
        WHERE yearid = 2000) AS ma(salary),
       master AS m
  WHERE s.playerid = m.playerid
  AND s.yearid = 2000
  AND s.salary = ma.salary
  UNION
  SELECT s.playerid, m.namefirst, m.namelast, s.salary, s.yearid
  FROM salaries AS s,
       (SELECT MAX(salary)
        FROM salaries
        WHERE yearid = 2001) AS ma(salary),
       master AS m
  WHERE s.playerid = m.playerid
  AND s.yearid = 2001
  AND s.salary = ma.salary
;

