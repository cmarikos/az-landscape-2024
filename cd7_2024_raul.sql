CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.viewers_dataset.cd7_2024_raul` AS(

SELECT 
p.PCTNUM
, p.PRECINCTNA
, p.GEOMETRY
,r.USCong_Dem AS dem_votes
, r.USCong_Rep AS rep_votes
, (r.USCong_Total - (r.USCong_Dem  + r.USCong_Rep)) AS third_votes
, r.USCong_Total AS total_votes

FROM `prod-organize-arizon-4e1c0a83.rich_christina_proj.results_2024` AS r

LEFT JOIN `prod-organize-arizon-4e1c0a83.geofiles.az_precincts_geo` AS p
  ON r.pctnum =p.PCTNUM

WHERE CONGRESSIO = 7
)