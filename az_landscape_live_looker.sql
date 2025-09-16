CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.viewers_dataset.az_landscape_live` AS(

WITH a AS(
SELECT DISTINCT
  cw.pctnum
  , vb.vb_vf_party as party
  , vb.vb_voterbase_race as modeled_race
  , CASE 
      WHEN vb.vb_vf_g2024 IN ('A','B','E','F','M','P','Q','R','S','Y','Z') THEN 'Voter'
      ELSE 'Did not vote'
    END AS voter_2024
  , CASE 
      WHEN vb.vb_vf_g2020 IN ('A','B','E','F','M','P','Q','R','S','Y','Z') THEN 'Voter'
      ELSE 'Did not vote'
    END AS voter_2020
  , CASE 
      WHEN vb.vb_vf_g2016 IN ('A','B','E','F','M','P','Q','R','S','Y','Z') THEN 'Voter'
      ELSE 'Did not vote'
    END AS voter_2016
  , CASE
    WHEN vb.vb_voterbase_age BETWEEN 18 AND 24 THEN '18-24'
    WHEN vb.vb_voterbase_age BETWEEN 25 AND 34 THEN '25-34'
    WHEN vb.vb_voterbase_age BETWEEN 25 AND 34 THEN '25-34'
    WHEN vb.vb_voterbase_age BETWEEN 35 AND 44 THEN '35-44'
    WHEN vb.vb_voterbase_age BETWEEN 45 AND 54 THEN '45-54'
    WHEN vb.vb_voterbase_age BETWEEN 55 AND 64 THEN '55-64'
    WHEN vb.vb_voterbase_age > 65 THEN '65+'
    ELSE 'age not specified'
  END AS age_bucket
  ,vb.vb_voterbase_gender as gender
  , COUNT(vb.voterbase_id) registered_voters
FROM `prod-organize-arizon-4e1c0a83.targetsmart_AZ.voter_base_latest` AS vb

LEFT JOIN `prod-organize-arizon-4e1c0a83.rich_christina_proj.targetsmart_pctnum_crosswalk` as cw
  ON vb.vb_vf_precinct_name = cw.vb_vf_precinct_name

WHERE vb.vb_tsmart_state = 'AZ'

GROUP BY 1,2,3,4,5,6,7,8
ORDER BY 1
  )


  SELECT 
    pg.GEOMETRY
    , pg.COUNTY
    , pg.PRECINCTNA
    , pg.LEGISLATIV
    , pg.CONGRESSIO
    , a.party
    , a.modeled_race
    , a.registered_voters
    , a.age_bucket
    , a.gender
  FROM `prod-organize-arizon-4e1c0a83.geofiles.az_precincts_geo` AS pg

  LEFT JOIN a
    ON pg.PCTNUM = a.pctnum

)