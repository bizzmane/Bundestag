# Bundestag
In this project voting data from the German Bundestag is analyzed.

Data for this project stems from https://www.bundestag.de/parlament/plenum/abstimmung/liste .

In the preparation.R all the plots for the Shiny app are prepared.

## Running the app

Open the project in RStudio and allow Packrat to restore the project library on
first startup. Then run `shiny::runApp()`. If the app reports that Shiny or
another locked package is missing, run `packrat::restore()` in the project
console and try again.