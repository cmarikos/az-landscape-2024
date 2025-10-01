CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.viewers_dataset.full_program_2024` AS(
WITH base AS(
SELECT 
d.uniqueprecinctcode
, COUNT(d.dwid) AS voters
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__district` AS d

GROUP BY 1
)

, vote_prop AS(
SELECT
d.uniqueprecinctcode
, COUNT(m.catalistmodel_voteprop2024) AS low_prop
FROM `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__district` AS d
  
LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__models` AS m
  ON d.dwid = m.dwid

WHERE m.catalistmodel_voteprop2024 < 60

GROUP BY 1
)

, bipoc AS(
SELECT
d.uniqueprecinctcode
, COUNT(m.dwid) AS bipoc
FROM`proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__district` AS d
  
LEFT JOIN `proj-tmc-mem-mvp.catalist_cleaned.cln_catalist__models` AS m
  ON d.dwid = m.dwid

WHERE m.race <> 'caucasian'
  AND m.race <> 'unknown'
  AND m.race IS NOT NULL

GROUP BY 1
)


SELECT  

p.GEOMETRY
, p.PCTNUM
, p.COUNTY AS county
,r.Canvassed/a.voters AS canvass_perc
, v.low_prop/a.voters AS low_prop_perc
, b.bipoc/a.voters AS bipoc_perc

FROM `prod-organize-arizon-4e1c0a83.rich_christina_proj.canvassresults2024` AS r


LEFT JOIN `prod-organize-arizon-4e1c0a83.geofiles.az_precincts_geo` AS p
  ON r.pctnum = p.PCTNUM

LEFT JOIN `prod-organize-arizon-4e1c0a83.rich_christina_proj.catalist_pctnum_crosswalk_native` AS cw
  ON p.PCTNUM = cw.pctnum

LEFT JOIN base AS a
  ON cw.uniqueprecinctcode = a.uniqueprecinctcode
  
LEFT JOIN vote_prop AS v
  ON cw.uniqueprecinctcode = v.uniqueprecinctcode

LEFT JOIN bipoc AS b
  ON cw.uniqueprecinctcode = b.uniqueprecinctcode

WHERE p.PCTNUM IS NOT NULL
AND p.COUNTY IN ('Pinal','Cochise','Coconino','Yavapai','Yuma','Mohave','Pima','Santa Cruz')
)