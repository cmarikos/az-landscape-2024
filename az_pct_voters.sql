CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.viewers_dataset.az_pct_voters_2024` AS(

WITH population AS(
SELECT
c.pctnum
, COUNT(p.DWID) AS population_count
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person` AS p

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__vote_history` AS vh
  ON p.DWID = vh.dwid

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__district` AS b
  ON p.dwid = b.dwid

INNER JOIN `prod-organize-arizon-4e1c0a83.rich_christina_proj.catalist_pctnum_crosswalk_native` AS c
  ON b.uniqueprecinctcode = c.uniqueprecinctcode

WHERE p.state = 'AZ'
AND p.mailaddrcensustract10 IS NOT NULL

GROUP BY 1
)

, dem_votes AS(
SELECT
c.pctnum
, COUNT(p.DWID) AS dem_votes
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person` AS p

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__vote_history` AS vh
  ON p.DWID = vh.dwid


LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__district` AS b
  ON p.dwid = b.dwid

INNER JOIN `prod-organize-arizon-4e1c0a83.rich_christina_proj.catalist_pctnum_crosswalk_native` AS c
  ON b.uniqueprecinctcode = c.uniqueprecinctcode

WHERE p.state = 'AZ'
AND p.mailaddrcensustract10 IS NOT NULL
AND p.partyaffiliation = 'DEM'
AND vh.e2024gst IS NOT NULL

GROUP BY 1
)

, rep_votes AS(
SELECT
c.pctnum
, COUNT(p.DWID) AS rep_votes
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person` AS p

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__vote_history` AS vh
  ON p.DWID = vh.dwid

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__district` AS b
  ON p.dwid = b.dwid

INNER JOIN `prod-organize-arizon-4e1c0a83.rich_christina_proj.catalist_pctnum_crosswalk_native` AS c
  ON b.uniqueprecinctcode = c.uniqueprecinctcode

WHERE p.state = 'AZ'
AND p.mailaddrcensustract10 IS NOT NULL
AND p.partyaffiliation = 'REP'
AND vh.e2024gst IS NOT NULL

GROUP BY 1
)

, third_votes AS(
SELECT
c.pctnum
, COUNT(p.DWID) AS third_votes
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__person` AS p

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__vote_history` AS vh
  ON p.DWID = vh.dwid

LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__district` AS b
  ON p.dwid = b.dwid

INNER JOIN `prod-organize-arizon-4e1c0a83.rich_christina_proj.catalist_pctnum_crosswalk_native` AS c
  ON b.uniqueprecinctcode = c.uniqueprecinctcode

WHERE p.state = 'AZ'
AND p.mailaddrcensustract10 IS NOT NULL
AND p.partyaffiliation NOT IN ('DEM','REP')
AND vh.e2024gst IS NOT NULL

GROUP BY 1
)

SELECT
p.pctnum
, p.population_count
, d.dem_votes
, r.rep_votes
, d.dem_votes/r.rep_votes AS dem_margin
, t.third_votes
, g.GEOMETRY

FROM population AS p

LEFT JOIN dem_votes AS d
  ON p.pctnum = d.pctnum

LEFT JOIN rep_votes AS r
  ON p.pctnum = r.pctnum

LEFT JOIN third_votes AS t
  ON p.pctnum = t.pctnum

LEFT JOIN `prod-organize-arizon-4e1c0a83.geofiles.az_precincts_geo` AS g
  ON p.pctnum = g.PCTNUM

)

