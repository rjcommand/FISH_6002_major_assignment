---
title: "FISH 6002 Major Assignment"
author: "Rylan J Command"
date: "24/09/2019"
output: html_document
---
## Major project folder structure  
  
FISH_6002_major_assignment  
|  
| - `FISH_6002_major_assignment.Rproj`  # The project file  
|  
| - `README.md`  # You’re reading it  
|  
| - `data/`  # Folder where .csv files containing data can be found  
|      +- `cdis5016-all9sp.csv`  # Dataset retrieved from ICCAT website  
|  
| - `scr/`  # Folder where all scripts to load, clean, analyze, etc. data can be found  
|      +- `0.0 Load data and clean.R`  # Script to load data and clean it  
|  
| - `figs/` # Folder where figures generated from scripts will be saved  
|  
| - `tables/`  # Folder where tables generated from scripts will be saved  
|  
| - `resources/`  # Any resources related to interpretation of data will be saved here (e.g. the DFO report containing the data)  
|      +- `ICCAT_codes.xlsx`  # Metadata pertaining to species codes, fleet codes, country codes, etc.

## Field Type Description Auxiliary Table*
Field | Type | Description | Auxillary table
------|------|-------------|----------------
SpeciesCode | string |ICCAT species code |Species
YearC | integer | Calendar Year |
Decade | integer | Decade (natural; e.g. 2000 to 2009) |
FlagName | string | ICCAT Flag Name Flags |
FleetCode | string | ICCAT | Fleet code | Fleets
Stock | string | Species related stock or management unit |
GearGrp | string | Gear group |
SchoolType | string | Type of fishing operation (PS only) | School types
Trimester | string | Time strata (trimester 1, 2, 3, 4) |
QuadID | string | ICCAT quadrant ICCAT | Quadrants
Lat5 | integer | Latitude of a 5x5 square | 
Lon5 | integer | Longitude of a 5x5 square |
yLat5ctoid | float | Latitude (decimal degrees) centroid (Cartesian) of a 5x5 square |
xLon5ctoid | float | Longitude (decimal degrees) centroid (Cartesian) of a 5x5 square
Catch_t | float | Nominal catches (tones) |