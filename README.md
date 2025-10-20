# az-landscape-2024

A data exploration & analysis project investigating the 2024 voting and demographic landscape for Arizona.

## Table of Contents
- [Project Overview](#project-overview)  
- [Key Questions & Goals](#key-questions-and-goals)  
- [Data & Files](#data-and-files)  
- [Usage](#usage)  
- [Results & Visuals](#results-and-visuals)  
- [Contact](#contact)  

## Project Overview  
This repository collects SQL queries, Jupyter notebooks, and visualizations to examine how demographic changes, voter registration, and election outcomes in Arizona are shaping the 2024 political landscape.  
It covers census data, precinct-level and voting-district level metrics, and election results for comparison. It's a bit of a dumping ground for scripts and queries answering broad questions about AZ's political landscape.

## Key Questions & Goals  
- How have voting‐eligible population (CVAP 2020) and turnout changed across Arizona’s precincts and districts?  
- What demographic shifts (age, ethnicity, geography) might impact 2024 results?  
- How do past election outcomes  compare with current registration and population trends?  
- Provide visualizations and insights to support decision-makers, analysts, or anyone tracking Arizona’s political landscape.

## Data & Files  
### SQL / Data Extraction  
- `2024_full_program_pct.sql` — Tracks full program results aggregating precinct-level data for 2024.  
- `az_census_voters.sql` — Counts population against party registration.
- `az_landscape_live_looker.sql` — SQL prepared for live embedding / dashboarding with Looker. Uses WKT geometry created in [my Geo Precincts repo](https://github.com/cmarikos/geo-precincts) for looker friendly mapping, alongside [my pctnum coding system in my AZ Precincts repo](https://github.com/cmarikos/az_precincts). 
- `az_pct_voters.sql`- Calculates a Democrat-to-Republican vote ratio compared with population, and attaches each precinct’s geographic shape for mapping in Folium scripts below.
- `2024_raul.sql` - Raul Grijalva 2024

### Notebooks & Analysis 
These notebooks build maps using [Folium](https://python-visualization.github.io/folium/latest/) in combination with some of the base SQL queries above. For mapping geometry, I mostly used the WKT geometries I already have in looker converted with [GeoPandas](https://geopandas.org/en/stable/) to GeoJSON. 
- `censustract_pop_voters.ipynb` — Analysis of census tract population and voters.  
- `cd7_2024_pctnum.ipynb` & `ld23_pctnum.ipynb` — Focused notebooks on specific congressional/district areas.  
- `full_program_2024.ipynb` — Comprehensive notebook that walks through the full program, combining data extraction, cleaning, and visualization.
- `pctnum_pop_voters.ipynb` - Analysis of precinct population and voters. Uses my pctnum coding [found in my AZ Precincts repo](https://github.com/cmarikos/az_precincts).

## Results & Visuals
### Folium Map Visuals
Folium is good for pretty, stable maps. Currently with our GCS set up I can't embed them in a way that they update with a scheduled run. The utility of these scripts is to generate many similar looking maps quickly using different base queries to form various geomteries. You can also view the results for specific scripts within each notebook on this repo.

#### Example: Raul Grijalva 2024 results
<img width="1082" height="640" alt="Screenshot 2025-09-29 at 3 29 24 PM" src="https://github.com/user-attachments/assets/c4670d37-0a4d-4089-a559-642cb8ae3211" />

#### Example: AZ 2024 Voter Landscape with and without population spikes
<img width="1942" height="692" alt="Screenshot 2025-09-03 at 12 01 31 PM" src="https://github.com/user-attachments/assets/4bdca1a5-76d4-42ca-9ef6-4976d11fd7fd" />
<img width="1934" height="684" alt="Screenshot 2025-09-03 at 12 01 23 PM" src="https://github.com/user-attachments/assets/9567a33e-77db-4aa6-a90e-255f5e325fda" />

## Contact
Please reach out to me at cgmarikos@gmail.com with any questions!
