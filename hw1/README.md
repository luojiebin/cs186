# Homework 1: SQL queries and scalable algorithms
#### CS186, UC Berkeley, Fall 2017
#### Note: *This homework is to be done individually!*
#### Due: 2PM Thursday, 9/7/2017

### Description

In this homework, we will exercise your newly acquired SQL skills. You will be writing queries against Postgres using public data.

### Getting Started
To follow these instructions **use your CS186 Vagrant VM**. If you do not use the VM, your tests may not execute correctly.

First, open up Virtual Box and power on the CS186 virtual machine. Once the machine is booted up, open a terminal and go to the `course-projects` folder you created in hw0.
```
$ cd course-projects
```
Make sure that you switch to the master branch:
```
$ git checkout master
```
It is good practice to run `git status` to make sure that you haven't inadvertently changed anything in the master branch.
Now, you want to add the reference to the staff repository so you call pull the new homework files:
```
$ git remote add staff https://github.com/berkeley-cs186/course.git
$ git fetch staff master
$ git merge staff/master master
```
The `git merge` will give you a warning and a merge prompt if you have made any conflicting changes to master (not really possible with hw1!).

As with hw0, create a new branch for your work: 
```
git checkout -b hw1
```
Now, you should be ready to start the homework, don't forget to push to this branch when you are done with everything.
### About the schema

In this homework we will be working with the famous [Lahman baseball statistics database](http://www.seanlahman.com/baseball-archive/statistics/). The database contains pitching, hitting, and fielding statistics for Major League Baseball from 1871 through 2016.  It includes data from the two current leagues (American and National), four other "major" leagues (American Association, Union Association, Players League, and Federal League), and the National Association of 1871-1875.

The database is comprised of the following main tables:

	MASTER - Player names, DOB, and biographical info
	Batting - batting statistics
	Pitching - pitching statistics
	Fielding - fielding statistics

It is supplemented by these tables:

	AllStarFull - All-Star appearance
	HallofFame - Hall of Fame voting data
	Managers - managerial statistics
	Teams - yearly stats and standings
	BattingPost - post-season batting statistics
	PitchingPost - post-season pitching statistics
	TeamFranchises - franchise information
	FieldingOF - outfield position data
	FieldingPost- post-season fielding data
	ManagersHalf - split season data for managers
	TeamsHalf - split season data for teams
	Salaries - player salary data
	SeriesPost - post-season series information
	AwardsManagers - awards won by managers
	AwardsPlayers - awards won by players
	AwardsShareManagers - award voting for manager awards
	AwardsSharePlayers - award voting for player awards
	Appearances - details on the positions a player appeared at
	Schools - list of colleges that players attended
	CollegePlaying - list of players and the colleges they attended

For more detailed information, see the [docs online](https://github.com/chadwickbureau/baseballdatabank/blob/master/core/readme2014.txt).

### Using Postgres

You can create a database, and start up the command-line interface `psql` to send SQL commands to that database:

	$ createdb test
	$ psql test

The `psql` interface to postgres has a number of built-in commands, all of which begin with a backslash. Use the `\d` command to see a description of your current relations. Use SQL's `CREATE TABLE` to create new relations. You can also enter `INSERT`, `UPDATE`, `DELETE`, and `SELECT` commands at the `psql` prompt. Remember that each command must be terminated with a semicolon (`;`).

Type `help` at the psql prompt to get more help options on `psql` commands or SQL statements.

When you're done, use `\q` or `ctrl-d` to exit `psql`.

If you messed up creating your database, you can issue the `dropdb` command to delete it.

    $ createdb tst  # oops!
    $ dropdb tst   # drops the db named 'tst'

### Getting started

Follow the steps above to test that Postgres is set up properly.

At this point you can load up the sample data:

	$ ./setup.sh

This will take a little while as it extracts and imports into your database. When you are done you have a database called `baseball`.  You can connect to it with `psql` and verify that the schema was loaded with the `\d` command:

	$ psql baseball
	baseball=# \d

Try running a few sample commands in the `psql` console and see what they do:

    baseball=# \d master
    baseball=# SELECT playerid, namefirst, namelast FROM master;
    baseball=# SELECT COUNT(*) FROM fielding;

For queries with many results, you can use arrow keys to scroll through the
results, or the spacebar to page through the results (much like the UNIX [`less`](https://www.tutorialspoint.com/unix_commands/less.htm) command). Press `q` to stop viewing the results.

### Write these queries

We've provided a skeleton solution, `hw1.sql`, to help you get started. In the file, you'll find a `CREATE VIEW` statement for each of the first 4 questions below, specifying a particular view name (like `q2`) and list of column names (like `playerid`, `lastname`). The view name and column names constitute the interface against which we will grade this assignment. In other words, *don't change or remove these names*. Your job is to fill out the view definitions in a way that populates the views with the right tuples.

For example, consider Question 0: "What is the highest `era` ([earned run average](https://en.wikipedia.org/wiki/Earned_run_average)) recorded in baseball history?".

In the `hw1.sql` file we provide:

	CREATE VIEW q0(era) AS
        SELECT 1 -- replace this line
	;

You would edit this with your answer, keeping the schema the same:

	-- solution you provide
	CREATE VIEW q0(era) AS
	 SELECT MAX(era)
	 FROM pitching
	;


To complete the homework, create a view for `q0` as above (via [copy-paste](http://i0.kym-cdn.com/photos/images/original/000/005/713/copypasta.jpg)), and for all of the following queries, which you will need to write yourself.

1. Basics
    1. In the `master` table, find the `namefirst`, `namelast` and `birthyear` for all players with weight greater than 300 pounds.
    2. Find the `namefirst`, `namelast` and `birthyear` of all players whose `namefirst` field contains a space.
    3. From the `master` table, group together players with the same `birthyear`, and report the `birthyear`, average `height`, and number of players for each `birthyear`. Order the results by `birthyear` in *ascending* order.

       Note: some birthyears have no players; your answer can simply skip those years. In some other years, you may find that all the players have a `NULL` height value in the dataset (i.e. `height IS NULL`); your query should return `NULL` for the height in those years.

    4. Following the results of Part iii, now only include groups with an average height > `70`. Again order the results by `birthyear` in *ascending* order.

2. Hall of Fame Schools
    1. Find the `namefirst`, `namelast`, `playerid` and `yearid` of all people who were successfully inducted into the Hall of Fame in *descending* order of `yearid`.

        Note: a player with id `drewj.01` is listed as having failed to be
        inducted into the Hall of Fame, but does not show up in the `master`
        table. Your query may assume that all people inducted into the Hall of Fame
        appear in the `master` table.

    2. Find the people who were successfully inducted into the Hall of Fame and played in college at a school located in the state of California. For each person, return their `namefirst`, `namelast`, `playerid`, `schoolid`, and `yearid` in *descending* order of `yearid`. Break ties on `yearid` by `schoolid, playerid` (ascending). (For this question, `yearid` refers to the year of induction into the Hall of Fame).

        Note: a player may appear in the results multiple times (once per year
        in a college in California).
 
    3. Find the `playerid`, `namefirst`, `namelast` and `schoolid` of all people who were successfully inducted into the Hall of Fame -- whether or not they played in college. Return people in *descending* order of `playerid`. Break ties on `playerid` by `schoolid` (ascending). (Note: `schoolid` will be `NULL` if they did not play in college.)

3. [SaberMetrics](https://en.wikipedia.org/wiki/Sabermetrics)
    1. Find the `playerid`, `namefirst`, `namelast`, `yearid` and single-year `slg` (Slugging Percentage) of the players with the 10 best annual Slugging Percentage recorded over all time. For statistical significance, only include players with more than 50 at-bats in the season. Order the results by `slg` descending, and break ties by `yearid, playerid` (ascending).

       *Baseball note*: Slugging Percentage is not provided in the database; it is computed according to a [simple formula](https://en.wikipedia.org/wiki/Slugging_percentage) you can calculate from the data in the database.

       *SQL note*: You should compute `slg` properly as a floating point number---you'll need to figure out how to convince SQL to do this!

    2. Following the results from Part i, find the `playerid`, `firstname`, `lastname` and `lslg` (Lifetime Slugging Percentage) for the players with the top 10 Lifetime Slugging Percentage. Note that the database only gives batting information broken down by year; you will need to convert to total information (from the earliest date recorded up to the last date recorded) to compute `lslg`.

       Order the results by `lslg` descending, and break ties by `playerid` (ascending order).

    3. Find the `namefirst`, `namelast` and Lifetime Slugging Percentage (`lslg`) of batters whose lifetime slugging percentage is higher than that of San Francisco favorite Willie Mays. You may include Willie Mays' playerid in your query (`mayswi01`), but you *may not* include his slugging percentage -- you should calculate that as part of the query. (Test your query by replacing `mayswi01` with the playerid of another player -- it should work for that player as well! We may do the same in the autograder.)

    *Just for fun*: For those of you who are baseball buffs, variants of the above queries can be used to find other more detailed SaberMetrics, like [Runs Created](https://en.wikipedia.org/wiki/Runs_created) or [Value Over Replacement Player](https://en.wikipedia.org/wiki/Value_over_replacement_player). Wikipedia has a nice page on [baseball statistics](https://en.wikipedia.org/wiki/Baseball_statistics); most of these can be computed fairly directly in SQL.

4. Salaries
    1. Find the `yearid`, min, max, average and standard deviation of all player salaries for each year recorded, ordered by `yearid` in *ascending* order.

    2. For salaries in 2016, compute a [histogram](https://en.wikipedia.org/wiki/Histogram). Divide the salary range into 10 equal bins from min to max, with `binid`s 0 through 9, and count the salaries in each bin. Return the `binid`, `low` and `high` values for each bin, as well as the number of salaries in each bin, with results sorted from smallest bin to largest.

       *Note*: `binid` 0 corresponds to the lowest salaries, and `binid` 9 corresponds to the highest. The ranges are left-inclusive (i.e. `[low, high)`) -- so the `high` value is excluded. For example, if bin 2 has a `high` value of 100000, salaries of 100000 belong in bin 3, and bin 3 should have a `low` value of 100000.

       *Note*: The `high` value of bin 9 just needs to be no smaller than the largest salary (the `high` value for only this bin may be inclusive).
   
    3. Now let's compute the Year-over-Year change in min, max and average player salary. For each year with recorded salaries after the first, return the `yearid`, `mindiff`, `maxdiff`, and `avgdiff` with respect to the previous year. Order the output by `yearid` in *ascending* order. (You should omit the very first year of recorded salaries from the result.)

    4. In 2001, the max salary went up by over $6 million. Write a query to find the players that had the max salary in 2000 and 2001. Return the `playerid`, `namefirst`, `namelast`, `salary` and `yearid` for those two years. If multiple players tied for the max salary in a year, return all of them.

        *Note on notation:* you are computing a relational variant of the [argmax](https://en.wikipedia.org/wiki/Arg_max) for each of those two years.


5. Shortest Paths.

    In this question, we're going to study the stars of the Oakland A's, whose weird glory years in the early 1970s formed the subject of the recent book [Dynastic, Bombastic, Fantastic](https://www.amazon.com/Dynastic-Bombastic-Fantastic-Catfish-Charlie/dp/0544303172). Your challenge will be to write a [single-source shortest path](https://en.wikipedia.org/wiki/Shortest_path_problem#Single-source_shortest_paths) algorithm that makes use of SQL for its heavy lifting. We'll take this in pieces. The basic idea is a batch-oriented variant of [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm), which forms "shortest" paths of increasing hop-count.  The pseudocode looks like this:

    ```
        // (paths): the set of shortest paths we've seen so far
        // (paths_to_update): the set of paths we added at step i
        // (new_paths): the set of paths that are on the frontier of our
        //      exploration, and are of length i+1 hops
        // (better_paths): best paths found up to this iteration

        // Initialize.
        insert all edges of 1 hop into (paths) and (paths_to_update)

        // Iterate.
        // the variable i is unnecessary, but illustrates the fact that we're
        // building paths of i+1 hops out of paths of i hops!
        i = 1
        while there are paths of i hops (paths_to_update):
            // find all paths of i+1 hops
            (extended_paths) = join of paths of i hops (paths_to_update)
                               with 1-hop paths (i.e. edges)
                               to form paths of i+1 hops

            // find paths of i+1 hops that are "better" than our current paths
            (new_paths) = paths of i+1 hops that either
                a. connect two vertices that were previously disconnected
                b. connect two vertices with a shorter-length path than previously found

            (better_paths) = the best paths among those in either (new_paths) or (paths)

            // when we go to the next iteration, need to swap the sets
            (paths) = (better_paths)
            (paths_to_update) = (new_paths)
            (new_paths) = empty set
        i++
    ```

    We begin with the initial graph construction in the `hw1-q5-setup.sql`(./hw1-q5-setup.sql) file; these queries are provided for you.

      - First, we identify the initial "seed" vertices of a graph. These vertices are `playerid` values of A's players who were successful inducted into the hall of fame. (`q5_seeds`)
      - Next we define the edges of the graph: players (on any team!) who played with one of the seed players. Two players are said to play together if they appear in the `appearances` table with matching `teamid` and `yearid` values. We are careful to ensure that each pair only appears once, and we don't create "cycles" by having the `src` and `dest` of the edge be the same! (`q5_edges`)
      - Next we initialize a table of paths between vertices by starting with paths of length 1: namely, the pairs of `q5_edges`. In the path relation we  store a source node `src`, a destination node `dest`, path-length `length` of 1 (for direct neighbors), and a `path` from the source to the destination, which in this case is simple `[src, dest]`. We use the [Postgres array type](https://www.postgresql.org/docs/9.6/static/arrays.html) for the `path` column. (`q5_paths`)
      - Finally we create the initial set of paths we need to update, which contains all the `q5_paths` to start. (`q5_paths_to_update`)

    Now you will write the workhorse queries that will run in the interior of a simple `while` loop, which we'll keep in the `hw1-q5-while.sql` file. This loop could be implemented in a scripting language like Python, but we'll just run it by hand ourselves. Each iteration of this `while` loop is going to examine paths that are one hop longer than the previous iteration.

      1. Create the `q5_extended_paths` query, which forms paths one hop longer than we've seen before. It should have the same columns as the `q5_paths_to_update` table. Be sure that the output includes a correct length, as well as a correct array of vertices in the `path` attribute. You may want to reference the `PostgreSQL manual on array functions`(https://www.postgresql.org/docs/9.6/static/functions-array.html) to see how to manipulate PostgreSQL arrays. Also, note that although lengths of edges in our setup are all `1`, your code should handle the general case of "weighted" edges with different lengths.
      2. Create the `q5_new_paths` table that should contain paths that either (a) connect previously unconnected nodes, or (b) provide a shorter path between a pair of nodes that were previously connected by a longer path. Again, it should have the same columns as the table from Part i, `q5_extended_paths`.
      3. Now, the `q5_better_paths` table should include the shortest paths found so far, whether they come from the `q5_paths` table or the `q5_new_paths` table. For any two nodes, there should be 0, 1 or more paths; if there are more than 1, they should all have the same length. You may find SQL's [conditional expressions](https://www.postgresql.org/docs/9.6/static/functions-conditional.html) helpful here (e.g. `CASE`, `COALESCE`, `LEAST`, etc.)

    The remaining steps are provided for you:

      - Now we can swap `q5_better_paths` for `q5_paths`, and `q5_new_paths` for `q5_paths_to_update` by renaming them.
      - As a last step, we check to see if `q5_new_paths` is empty, and produce output to inform a user whether to run the loop again or not.

    You can test your code by importing the SQL files from `psql`:

    ```
    % psql baseball
    baseball=# \i /<path-to-your-homework>/hw1-q5-setup.sql'
    baseball=# \i /<path-to-your-homework>/hw1-q5-while.sql'
    baseball=# \i /<path-to-your-homework>/hw1-q5-while.sql'
    baseball=# \i /<path-to-your-homework>/hw1-q5-while.sql'
    ```
    ...etc. Until you see a message like this:
    ```
    baseball=# \i '/Users/jmh/Box Sync/cs186/fa17/course-solutions/hw1/hw1-q5-while.sql'
    DROP TABLE
    SELECT 0
    SELECT 0
    SELECT 1587
    DROP TABLE
    ALTER TABLE
    DROP TABLE
    ALTER TABLE
     count |  status
    -------+----------
      1587 | FINISHED
    (1 row)
    ```

    *Note for the curious:* Many social network and web ranking algorithms are based on analyzing graphs in this manner---given the scale of those datasets, an approach using a scalable data processingbackend as we do here is important. Some of these techniques require finding shortest paths as a subroutine. You could extend your code above to compute [betweenness centrality](https://en.wikipedia.org/wiki/Betweenness_centrality), for example, and identify players who are at the center of the hall-of-fame network.

## Testing

You can run questions 1-4 directly using:

	$ psql baseball < hw1.sql

This can help you catch any syntax errors in your SQL.

To help debug your logic, we've provided output from each of the views you need to define in questions 1-4 for the data set you've been given.  Your views should match ours, but note that your SQL queries should work on ANY data set. We reserve the right to test your queries on a (set of) different database(s), so it is *NOT* sufficient to simply return these results in all cases!

To run the test, from within the `hw1` directory:

	$ ./test.sh

Become familiar with the UNIX [diff](http://en.wikipedia.org/wiki/Diff) command, if you're not already, because our tests saves the `diff` for any query executions that don't match in `diffs/`.  If you care to look at the query outputs directly, ours are located in the `expected_output` directory. Your view output should be located in your solution's `your_output` directory once you run the tests.

**Note:** For queries where we don't specify the order, it doesn't matter how
you sort your results; we will reorder before comparing. Note, however, that our
test query output is sorted for these cases, so if you're trying to compare
yours and ours manually line-by-line, make sure you use the proper ORDER BY
clause (you can determine this by looking in `test.sh`).

To help you with question 5, we have provided an alternative setup file, `hw1-q5-test-setup.sql`, which provides a more familiar graph: the states of the United States and their geographic neighbors. You can use it in place of `hw1-q5-setup.sql` in the instructions above. We are not providing test results for question 5, but you can use this dataset to manually verify your results. When it completes, try a query like
```sql
SELECT * FROM q5_paths WHERE src = 'CA' AND dest = 'FL';
```

## Submission
When you are done, run the following git commands similar to like what you did in HW0 to push it to Github. And you are done!
```
$ git add .
$ git commit -m "Your commit message"
$ git push origin hw1
```
