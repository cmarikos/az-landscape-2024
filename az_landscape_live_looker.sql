CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.viewers_dataset.az_landscape_live` AS(
WITH
crosswalk AS (
  SELECT
    vb_vf_precinct_name,
    pctnum
  FROM `prod-organize-arizon-4e1c0a83.rich_christina_proj.targetsmart_pctnum_crosswalk`
),

g AS (
  SELECT
    pg.PCTNUM,
    pg.COUNTY,
    pg.PRECINCTNA,
    pg.LEGISLATIV,
    pg.CONGRESSIO,
     CASE
      WHEN ST_IsEmpty(ST_Simplify(ST_SnapToGrid(pg.GEOMETRY, 0.0005), 100))
        THEN ST_Simplify(pg.GEOMETRY, 30)                          -- fallback
      ELSE ST_Simplify(ST_SnapToGrid(pg.GEOMETRY, 0.0005), 100)      -- primary
    END AS geometry_simple
  FROM `prod-organize-arizon-4e1c0a83.geofiles.az_precincts_geo` AS pg
  WHERE NOT ST_IsEmpty(pg.GEOMETRY)
),

a AS (
  SELECT
    cw.pctnum,
    vb.vb_vf_party AS party,
    vb.vb_voterbase_race AS modeled_race,
    CASE
      WHEN vb.vb_vf_g2024 IN ('A','B','E','F','M','P','Q','R','S','Y','Z') THEN 'Voter'
      ELSE 'Did not vote'
    END AS voter_2024,
    CASE
      WHEN vb.vb_vf_g2020 IN ('A','B','E','F','M','P','Q','R','S','Y','Z') THEN 'Voter'
      ELSE 'Did not vote'
    END AS voter_2020,
    CASE
      WHEN vb.vb_vf_g2016 IN ('A','B','E','F','M','P','Q','R','S','Y','Z') THEN 'Voter'
      ELSE 'Did not vote'
    END AS voter_2016,
    CASE
      WHEN vb.vb_voterbase_age BETWEEN 18 AND 24 THEN '18-24'
      WHEN vb.vb_voterbase_age BETWEEN 25 AND 34 THEN '25-34'
      WHEN vb.vb_voterbase_age BETWEEN 35 AND 44 THEN '35-44'
      WHEN vb.vb_voterbase_age BETWEEN 45 AND 54 THEN '45-54'
      WHEN vb.vb_voterbase_age BETWEEN 55 AND 64 THEN '55-64'
      WHEN vb.vb_voterbase_age >= 65 THEN '65+'
      ELSE 'age not specified'
    END AS age_bucket,
    COALESCE(vb.vb_voterbase_gender, 'unspecified') AS gender,
    COUNT(vb.voterbase_id) AS registered_voters
  FROM `prod-organize-arizon-4e1c0a83.targetsmart_AZ.voter_base_latest` AS vb
  LEFT JOIN crosswalk AS cw
    ON vb.vb_vf_precinct_name = cw.vb_vf_precinct_name
  WHERE vb.vb_tsmart_state = 'AZ'
    AND cw.pctnum IS NOT NULL                
  GROUP BY
    cw.pctnum, party, modeled_race, voter_2024, voter_2020, voter_2016,
    age_bucket, gender
)

SELECT
  g.geometry_simple AS GEOMETRY,          
  g.COUNTY,
  g.PRECINCTNA,
  g.LEGISLATIV,
  g.CONGRESSIO,
  a.party,
  a.modeled_race,
  a.registered_voters,
  a.age_bucket,
  a.gender,
  a.voter_2024,
  a.voter_2020,
  a.voter_2016
FROM g
LEFT JOIN a
  ON g.PCTNUM = a.pctnum
)