### making F1 Data Package

# https://r-pkgs.org/ - online book with great information from Hadley Wickham

# usethis::create_package("mypackagename")

usethis::create_package("Data_Packaging/f1championships")

# Step 2 Inspect the new project ----

# - R Folder
# - DESCRIPTION File
# - NAMESPACE File

# Step 3 Update Description File ----

# - Add Title
# - Add AUthors 
# - Add description
# - Add license (usethis::use_mit_license(), usethis::use_apl2_license(), etc)

# Step 4 Add in the scraping code in the data-raw folder ----

##Run this in package R session
usethis::use_data_raw("f1_championship_data")

## This will create data-raw folder that contains f1_championship_data.R 
## Next step is to update this R script as per required 
## Run the R script and use_data
## This will create data folder with "dataset_name.rda"

## Next time when we want to load the package
## devtools::loadall(".")
## packagename::datasetname

## Now how to use in new session
## Go to the directory that contains desctiption file
## Set that as working directory
## ## devtools::loadall(".")
## packagename::datasetname



## To create man folder ( that contains description of the dataset in the package)
#### Create a new R script in the auto created R folder ( data.R) ( Write roxygenated script ) ( No need to run this code)
#### To create man folder, run the foll command --: devtools::document

## To create vignetter
#### usethis::use_vignette

