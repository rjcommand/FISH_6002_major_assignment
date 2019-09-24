# FISH 6002 Major Assignment
#### Rylan J. Command
#### Updated: 24/09/2019

## Background
This is the project folder associated with the FISH 6002 Major Assignment. 



## Project folder structure  
  
FISH_6002_major_assignment  
|  
| - `FISH_6002_major_assignment.Rproj`  # The project file  
|  
| - `README.md`  # You’re reading it! Metadata for FISH 6002 Major Assignment  
|  
| - `data/`  # Folder where raw data files can be found; these are not edited once created  
|      + - `cdis5016-all9sp.csv`  # Dataset containing catch (t) retrieved from ICCAT website (see below)  
|  
| - `scr/`  # Folder where all scripts to load, clean, analyze, etc. data can be found  
|      + - `0.0 Load data and clean.R`  # Script to load data and clean it  
|  
| - `figs/` # Folder where figures generated from scripts will be saved  
|  
| - `tables/`  # Folder where tables generated from scripts will be saved  
|  
| - `resources/`  # Any resources related to interpretation of data will be saved here 
|      + - `ICCAT_codes.xlsx`  # Metadata pertaining to species codes, fleet codes, country codes, etc.

## Metadata for `cdis5016-all9sp.csv` file
This file contains catch (t) for the nine major tuna and tuna-like species of ICCAT (International Commission for the Conservation of Atlantic Tunas). 

Field | Type | Description | Auxillary table*  
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
xLon5ctoid | float | Longitude (decimal degrees) centroid (Cartesian) of a 5x5 square |  
Catch_t | float | Nominal catches (tones) |  

*Auxillary table information can be found in `ICCAT_codes.xlsx` in the `resources/` subfolder  
### Species codes  
The species codes for each of the major tuna species included in the `cdis5016-all9sp.csv` file  

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
The stocks or managment units for each species. 

Stock |ALB|BET|BFT|BUM|SAI|SKJ|SWO|WHM|YFT|  
---|---|---|---|---|---|---|---|---|---|  
AT (all Atlantic) | | X | | X | | | | X | |  
ATE (Atlantic east) | | | X | | X | X | | | X |  
ATN (Atlantic north) | X | | | | | | X | | |  
ATS (Atlantic south) | X | | | | | | X | | |  
ATW (Atlantic west) | | | X | | X | X | | | X |  
MED (Mediterranean) | X | X | X | X | X | X | X | X | X |  