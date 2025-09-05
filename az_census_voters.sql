CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.viewers_dataset.az_censustract_voters_2024` AS(

WITH population AS(
SELECT
p.mailaddrcensustract10
, COUNT(p.DWID) AS population_count
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person` AS p

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__vote_history` AS vh
  ON p.DWID = vh.dwid

WHERE p.state = 'AZ'
AND p.mailaddrcensustract10 IS NOT NULL

GROUP BY 1
)

, dem_votes AS(
SELECT
p.mailaddrcensustract10
, COUNT(p.DWID) AS dem_votes
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person` AS p

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__vote_history` AS vh
  ON p.DWID = vh.dwid

WHERE p.state = 'AZ'
AND p.mailaddrcensustract10 IS NOT NULL
AND p.partyaffiliation = 'DEM'
AND vh.e2024gst IS NOT NULL

GROUP BY 1
)

, rep_votes AS(
SELECT
p.mailaddrcensustract10
, COUNT(p.DWID) AS rep_votes
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person` AS p

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__vote_history` AS vh
  ON p.DWID = vh.dwid

WHERE p.state = 'AZ'
AND p.mailaddrcensustract10 IS NOT NULL
AND p.partyaffiliation = 'REP'
AND vh.e2024gst IS NOT NULL

GROUP BY 1
)

, third_votes AS(
SELECT
p.mailaddrcensustract10
, COUNT(p.DWID) AS third_votes
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person` AS p

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__vote_history` AS vh
  ON p.DWID = vh.dwid

WHERE p.state = 'AZ'
AND p.mailaddrcensustract10 IS NOT NULL
AND p.partyaffiliation NOT IN ('DEM','REP')
AND vh.e2024gst IS NOT NULL

GROUP BY 1
)

, tract_dim AS (
  SELECT
    mailaddrcensustract10,
    mailaddrcensustract20,         
    ANY_VALUE(mailaddrgeoid20) AS geoid
  FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person`
  WHERE state = 'AZ' AND mailaddrcensustract10 IS NOT NULL AND mailaddrgeoid10 IS NOT NULL
  GROUP BY 1,2
)

SELECT DISTINCT

td.mailaddrcensustract20
, td.geoid
, p.population_count
, d.dem_votes
, r.rep_votes
, d.dem_votes/r.rep_votes AS dem_margin
, t.third_votes

FROM population AS p

LEFT JOIN dem_votes AS d
  ON p.mailaddrcensustract10 = d.mailaddrcensustract10

LEFT JOIN rep_votes AS r
  ON p.mailaddrcensustract10 = r.mailaddrcensustract10

LEFT JOIN third_votes AS t
  ON p.mailaddrcensustract10 = t.mailaddrcensustract10

LEFT JOIN tract_dim AS td
  ON p.mailaddrcensustract10 = td.mailaddrcensustract10
)




