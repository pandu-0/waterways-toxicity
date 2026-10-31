# Association Between Urban Land Use and Pyrethroid Toxicity in California Waterways

Author: Pandu Rupanagudi

Submission Date: October 30

## Project description:
This project is a study that makes use of the Sum Pyrethroid Toxic Units 
dataset provided by the California State Water Resources Control Board to test whether there is linear 
association between the percent of land classified as urban around a SPoT monitoring 
station and pyrethroid pesticide toxicity in the waterway.

## Project Structure:
```text
- R/references.bib
- R/report.pdf
- R/report.qmd
- .gitignore
- README.md
- waterways-toxicity.Rproj
```

## Necessary packages

Required R packages can be installed using the following command:  
```r
install.packages(c(
  "sf",
  "ggplot2",
  "httr2"
))
```

## Dataset license

The dataset was obtained from California Open Data. The dataset is publicly usable 
as mentioned in the California Open Data policy page.


## External Resources Statement
As a graduate student that is still learning to code in R, I had to rely on LLMs for help to 
plot the Figure 1, as it requires sending get requests to the official California Water Board station 
lookup service, which I am unfamiliar with. Other than this, no external resources were used for this project. 



