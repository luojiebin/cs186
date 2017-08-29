-- Q5 Iteration

DROP TABLE IF EXISTS q5_extended_paths;
CREATE TABLE q5_extended_paths(src, dest, length, path)
AS
    SELECT -- remember to remove duplicates and avoid generating cycles!
;

CREATE TABLE q5_new_paths(src, dest, length, path)
AS
   SELECT -- fill this in

CREATE TABLE q5_better_paths(src, dest, length, path)
AS 
    SELECT -- fill this in

DROP TABLE q5_paths;
ALTER TABLE q5_better_paths RENAME TO q5_paths;

DROP TABLE q5_paths_to_update;
ALTER TABLE q5_new_paths RENAME TO q5_paths_to_update;

SELECT COUNT(*) AS path_count,
       CASE WHEN 0 = (SELECT COUNT(*) FROM q5_paths_to_update) 
            THEN 'FINISHED'
            ELSE 'RUN AGAIN' END AS status
  FROM q5_paths;
