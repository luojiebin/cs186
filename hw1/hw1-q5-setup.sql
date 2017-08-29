-- Question 5 Setup
DROP TABLE IF EXISTS q5_seeds;
CREATE TABLE q5_seeds
AS 
    SELECT DISTINCT a.playerid
      FROM appearances a, halloffame h
     WHERE a.teamid = 'OAK'
       AND a.playerid = h.playerid
       AND h.inducted = 'Y';

DROP TABLE IF EXISTS q5_edges;
CREATE TABLE q5_edges
AS
    SELECT DISTINCT a1.playerid AS src, a2.playerid AS dest, 1 AS length
          FROM q5_seeds s, appearances a1, appearances a2, 
               halloffame h2
         WHERE s.playerid = a1.playerid
           AND a1.yearid = a2.yearid
           AND a1.teamid = a2.teamid
           AND a2.playerid = h2.playerid
           AND h2.inducted = 'Y'
           AND a1.playerid != a2.playerid -- no cycles!
           ;

DROP TABLE IF EXISTS q5_paths;
CREATE TABLE q5_paths
AS
    SELECT *, ARRAY[src, dest] AS path 
      FROM q5_edges
;

DROP TABLE IF EXISTS q5_paths_to_update;
CREATE TABLE q5_paths_to_update
AS
    SELECT * FROM q5_paths
;
