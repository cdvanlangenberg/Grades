cwd <- getwd()
path <- file.choose()
setwd(dirname(path))

source("Grades_by_course.R")
source("GradesOverall.R")

setwd(cwd)

rm(list = ls())
gc()