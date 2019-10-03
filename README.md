---
output:
  pdf_document: default
  html_document: default
---
# FISH 6002 Major Assignment
#### Rylan J. Command
#### Updated: 24/09/2019

## Background
This is the project folder associated with the FISH 6002 Major Assignment.  

This folder contains all of the data, scripts, and resources required to complete this assignment.  
It also contains all of the figures and tables produced by the `.r` scripts.  
  
The dataset used for this project is the "Task II catch data raised to total landings (5x5 degree squares, quarter, gear)" dataset obtained from the International Committee for the Conservation of Atlantic Tunas (ICCAT) database website (https://www.iccat.int/en/accesingdb.html) under "Sample fishing statistics and fish sizes", and is public domain. This dataset provides an estimation of Task I nominal catch (TINC) for the 9 major tuna and tuna-like species managed by the ICCAT, and is regularly collected as part of ongoing management of tuna and tuna-like fish stocks in the Atlantic Ocean and Mediterranean Sea. It covers the time period from 1950 - 2016 and the geographical range is the Atlantic Ocean and the Mediterranean Sea. The dataset contains 556155 observations (rows) of 15 variables (columns).  
  
Metadata for this dataset can be found below, and additional material can be found in the `resources/` folder.  

## Project folder structure  
  
Rylan_Command_FISH_6002_major_assignment  
|  
| - `FISH_6002_major_assignment.Rproj`  - The R project file  
|  
| - `README.md`  - If you're veiwing this project on GitHub, you’re reading it! This file is a description of the  
|                  project and file structure, and contains all of the metadata for the FISH 6002 Major Assignment  
|                  (and was used to generate the `README.pdf` file)  
|  
| - `README.pdf`  - You're reading it! (the `.pdf` version) This file is a description of the project and file  
|                   structure, and contains all of the metadata for FISH 6002 Major Assignment  
|  
| - `data/`  - Folder where raw data files can be found; these are not edited once created  
|      + - `cdis5016-all9sp.csv`  - Dataset containing catch (t) retrieved from ICCAT website (see below)  
|  
| - `scr/`  - Folder where all scripts to load, clean, analyze, etc. data can be found  
|      + - `0.0 Load data and clean.R`  - Script to load data and clean it  
|  
| - `figs/` - Folder where figures generated from scripts will be saved  
|  
| - `tables/`  - Folder where tables generated from scripts will be saved  
|  
| - `resources/`  - Any resources related to interpretation of data will be saved here  
|      + - `ICCAT_codes.xlsx`  - Metadata pertaining to species codes, fleet codes, country codes, etc.  
|      + - `Readme_catdis.pdf`  - Metadata pertaining to variables in the dataset (some outlined below)  
  
  
## Metadata for `cdis5016-all9sp.csv` file
This file contains catch (in tons) for the nine major tuna and tuna-like species of ICCAT (International Commission for the Conservation of Atlantic Tunas, https://www.iccat.int/en/accesingdb.html#).  

The following table lists the variable/column names:  

Field | Type | Description | Auxillary table*  
------|------|-------------|----------------  
SpeciesCode | string |ICCAT species code |Species  
YearC | integer | Calendar Year |  
Decade | integer | Decade (natural; e.g. 2000 to 2009) |  
FlagName | string | ICCAT Flag Name | Flags |  
FleetCode | string | ICCAT | Fleet code | Fleets  
Stock | string | Species related stock or management unit |  
GearGrp | string | Gear group |  
SchoolType | string | Type of fishing operation (PS only) | School types  
Trimester | string | Time strata (trimester 1, 2, 3, 4) |  
QuadID | string | ICCAT quadrant ICCAT | Quadrants  
Lat5 | integer | Latitude of a 5x5 square |  
Lon5 | integer | Longitude of a 5x5 square |  
yLat5ctoid | float | Latitude (decimal degrees) centroid (Cartesian) of a 5x5 square |  
xLon5ctoid | float | Longitude (decimal degrees) centroid (Cartesian) of a 5x5 square |  
Catch_t | float | Nominal catches (tones) |  

*Auxillary table information can be found in `ICCAT_codes.xlsx` in the `resources/` subfolder  
  
  
### Species codes  
The species codes for each of the major tuna species included in the `cdis5016-all9sp.csv` file. Species codes can also be found in `ICCAT_codes.xlsx` in the `resources/` subfolder.

SpeciesID |	SpeciesCode	| ScieName | NameUK |	NameFR | NameSP|  
----------|-------------|----------|--------|--------|-------|  
1	| BFT	| Thunnus thynnus	| Northern bluefin tuna	| Thon rouge du Nord | Atún rojo del norte  
3	| YFT	| Thunnus albacares |	Yellowfin tuna | Albacore	| Rabil |  
4	| ALB	| Thunnus alalunga | Albacore	| Germon | Atún blanco |  
5	| BET	| Thunnus obesus | Bigeye tuna | Thon obèse(=Patudo) | Patudo |  
8	| SKJ	| Katsuwonus pelamis | Skipjack tuna | Listao |	Listado |  
15	| SAI	| Istiophorus albicans |	Atlantic sailfish	| Voilier de l'Atlantique	| Pez vela del Atlántico |  
17	| BUM	| Makaira nigricans	| Atlantic blue marlin | Makaire bleu de l'Atlantique	| Aguja azul del Atlántico |  
18	| WHM	| Tetrapturus albidus |	Atlantic white marlin	| Makaire blanc de l'Atlantique	| Aguja blanca del Atlántico |
19	| SWO	| Xiphias gladius	| Swordfish	| Espadon	| Pez espada |  

### Stocks  
The stocks or managment units for each species. An "X" indicates that a species is present in a given management unit.  

Stock |ALB|BET|BFT|BUM|SAI|SKJ|SWO|WHM|YFT|  
---|---|---|---|---|---|---|---|---|---|  
AT (all Atlantic) | | X | | X | | | | X | |  
ATE (Atlantic east) | | | X | | X | X | | | X |  
ATN (Atlantic north) | X | | | | | | X | | |  
ATS (Atlantic south) | X | | | | | | X | | |  
ATW (Atlantic west) | | | X | | X | X | | | X |  
MED (Mediterranean) | X | X | X | X | X | X | X | X | X |  
  
### Gear groups
The primary gear groups used to capture each species, defined based on its weight in overall catches by decade. An "X" indicates a species is regularly captured with a given gear group.

Gear group | ALB | BET | BFT | BUM | SAI | SKJ | SWO | WHM | YFT |  
-----------|-----|-----|-----|-----|-----|-----|-----|-----|-----|  
BB (bait boat) | X | X | X | X | X | X | X | X | X |  
GN (gillnet) | X | | | X | X | | X | X | |  
HL (handline) | | | X | | X | | | | |  
HP (harpoon) | | | | | | | X | | |  
LL (longline) | X | X | X | X | X | X | X | X | X |  
PS (purse seine) | X | X | X | X | X | X | X | X | X |  
RR (rod & reel) | | | X | X | X | | | X | |  
TP (trap) | | | X | | | | | | |  
TR (troll) | X | | X | | X | | | X | |  
TW (trawl) | X | | | | | | | | |  
oth (others) | X | X | X | X | X | X | X | X | X |  