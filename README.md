---
title: "Generating DWF grades"
author: "Chris Vanlangenberg"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Instructions

Following instructions are to analyze DWF grades for following courses,

* MAT 112
* MAT 115 
* MAT 120
* MAT 150
* MAT 151
* MAT 190
* MAT 191
* STA 108

offered by UNCG Mathematics and Statistics for the past 9 months starting form previous semester (or same semster if the analysis was carried out at the end of current semester). All required codes are available on [github](https://github.com/cdvanlangenberg/Grades).

Follow the following steps to generate DWF grades for above courses: 

*  step1: Download the following **R** codes to a local folder in your desktop/laptop,

1. GetResults.R
2. GradesByCourse.R
3. GradesOverall.R

* step 2: get the new data file (it will be a ".accdb" access file) and 
    + save it as **GradesDistributions.accdb** in the same folder with R codes

* step 3: go to R/RStudio 
    + open GetResults.R 
    + excute the obove code, (it will ask for a file location, then select the data file)    

If everything works fine (hopefully) following outputs will be created,

* AdjGrades.csv
    + excel file with row data summerized at A, B, C, D, F, WF, W
    
* overall.pdf
    + overall grade distribution for all courses by semester
    + overall grade percentage
    + overall DWF percentage
    + overall DWF percentage by delivery method

* one pdf for each course (9)
    + DWF trend over the past 9 semesters
    + grade distribution
    + DWF percentage by delivery method


### Common issue and fixes

1. The data will be in **".accdb"** format, only 32 bit version of **R** (in RStudio this can be changed from Global setting and will have to restart **R**) will work for the above codes.
2. If the data format was changes then code **GradesByCourse.R** line 15 may have to be changed accordingly (also the new packages if any). 
3. If you are using a Microsoft Office version of 2010 or later, please install [2007 Office System Driver](https://www.microsoft.com/en-us/download/details.aspx?id=23734).
4. It was assumed that column names will not be changed over time if so you may have to rename it as per the codes (it might be a major modification to the codes). 



# Grades

Follow the following steps to generate DWF grades 
- step 1
- step 2 