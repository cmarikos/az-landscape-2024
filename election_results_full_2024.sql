
, pres_votes AS(
SELECT
r.pctnum
, SUM(r.PresidentDem_Harris) AS pres_dem
, SUM(r.PresidentRep_Trump) AS pres_rep

FROM `prod-organize-arizon-4e1c0a83.rich_christina_proj.results_2024` AS r

GROUP BY 1  
)

, ussen_votes AS(
SELECT
r.pctnum
, SUM(r.USSenateDem_Gallego) AS ussen_dem
, SUM(r.USSenateRep_Lake) AS ussen_rep

FROM `prod-organize-arizon-4e1c0a83.rich_christina_proj.results_2024` AS r

GROUP BY 1  
)

, uscong_votes(
SELECT
r.pctnum
, SUM(r.USCong_Dem) AS uscong_dem
, SUM(r.USCong_Rep) AS uscong_rep

FROM `prod-organize-arizon-4e1c0a83.rich_christina_proj.results_2024` AS r

GROUP BY 1  
)

, stsen_votes AZ(
SELECT
r.pctnum
, SUM(r.StSenDem) AS stsen_dem
, SUM(r.StSenRep) AS stsen_rep

FROM `prod-organize-arizon-4e1c0a83.rich_christina_proj.results_2024` AS r

GROUP BY 1  
)