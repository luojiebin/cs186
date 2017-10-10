-- Q5 Iteration

DROP TABLE IF EXISTS q5_extended_paths;
CREATE TABLE q5_extended_paths(src, dest, length, path)
AS
  SELECT p.src, e.dest, p.length + e.length, ARRAY_APPEND(p.path, e.dest)
  FROM q5_paths_to_update AS p, q5_edges AS e
  WHERE p.dest = e.src AND NOT p.path @> ARRAY[e.dest];
;

CREATE TABLE q5_new_paths(src, dest, length, path)
AS
  SELECT *
  FROM q5_extended_paths AS extended
  WHERE NOT EXISTS
              (SELECT *
               FROM q5_paths AS paths
               WHERE paths.src = extended.src
               AND paths.dest = extended.dest)
  UNION
  SELECT extended.*
  FROM q5_extended_paths AS extended, q5_paths AS paths
  WHERE extended.src = paths.src
  AND extended.dest = paths.dest
  AND extended.length < paths.length
;

CREATE TABLE q5_better_paths(src, dest, length, path)
AS 
    SELECT *
    FROM q5_new_paths
    UNION
    SELECT *
    FROM q5_paths
    WHERE NOT EXISTS
                (SELECT *
                 FROM q5_new_paths
                 WHERE q5_new_paths.src = q5_paths.src
                 AND q5_new_paths.dest = q5_paths.dest)
;

DROP TABLE q5_paths;
ALTER TABLE q5_better_paths RENAME TO q5_paths;

DROP TABLE q5_paths_to_update;
ALTER TABLE q5_new_paths RENAME TO q5_paths_to_update;

SELECT COUNT(*) AS path_count,
       CASE WHEN 0 = (SELECT COUNT(*) FROM q5_paths_to_update) 
            THEN 'FINISHED'
            ELSE 'RUN AGAIN' END AS status
  FROM q5_paths;
