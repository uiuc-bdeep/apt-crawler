
#     ------------------------------------------------------------------------
#   |                                                                         |
#   |  Creates Hedonics Dataset                   |
#   |                                                                         |
#   |  By:                                                                    |
#   |  Peter Christensen                                             |    
#   |  Big Data for Environmental Economics and Policy                        |
#   |  University of Illinois at Urbana Chamapaign                            |
#   |                                                                         |
#     ------------------------------------------------------------------------


# Source of data  -------------------------------------------------------------

# converted files are stored at:
#    "~/share/projects/data/Apartments/"

#install packages

## Preliminaries
rm(list=ls())

## This function will check if a package is installed, and if not, install it
pkgTest <- function(x) {
  if (!require(x, character.only = TRUE))
  {
    install.packages(x, dep = TRUE)
    if(!require(x, character.only = TRUE)) stop("Package not found")
  }
}

## These lines load the required packages
packages <- c("plyr", "dplyr", "lfe", "rdrobust", "stargazer", "ggplot2", "outliers")
lapply(packages, pkgTest)

require(ggplot2)
library(doBy)
library(zoo)



# Read Apartment Transaction Data -------------------------------------------------------------------

TD <- read.csv("~/share/projects/Apartments/stores/backup sept 27/rents.csv")

#change date format
TD$date <- as.Date(TD$Date.Added, format="%m-%d-%Y")                           # transform into "R date"
TD$datepos <- as.POSIXlt(TD$date)
TD$month <- as.factor(TD$datepos$mon+1)
TD$year <- as.factor(TD$datepos$year+1900)

## data prep

TD$Rent <- as.numeric(levels(TD$rent))[TD$rent]
TD$logRent <- as.numeric(log(TD$Rent))
TD$Beds <- as.numeric(levels(TD$beds))[TD$beds]
TD$Baths <- as.numeric(levels(TD$baths))[TD$baths]
TD$Sqft <- as.numeric(levels(TD$sqft))[TD$sqft]
TD$Score <- as.numeric(as.character(TD$score))
TD$rent1 <- sub("$",'',as.character(TD$rent),fixed=TRUE)
TD$Rent <- as.numeric(sub(",",'',as.character(TD$rent1),fixed=TRUE))
TD$Zip <- as.factor(TD$zipcode)
TD$Beds_ <- as.factor(TD$Beds)
TD$Baths_ <- as.factor(TD$Baths)

  
## outliers
TD <- subset(TD, Rent!="NA")	
TD <- subset(TD, Rent<15000)	

# Subset data by market
NYC <- subset(TD, city=="New York")
Philadelphia <- subset(TD, city=="Philadelphia")
DC <- subset(TD, city=="Washington")


# Graph prices for each market                   ############# what is the date variable in this dataset?
ggplot() + ggtitle('Raw Transaction Prices') +
  labs(x="Date", y="Rent") +
  geom_smooth(aes(NYC$date, NYC$Rent), se=TRUE, fullrange=FALSE,
              colour='firebrick1', fill = "firebrick1") + 
  geom_smooth(aes(Philadelphia$date, Philadelphia$Rent), se=TRUE, fullrange=FALSE,
              colour='black', fill = "black") +
  geom_smooth(aes(DC$date, DC$Rent), se=TRUE, fullrange=FALSE,
              colour='blue', fill = "blue")


# Run Regression Models for NYC, Philadelphia, and DC
m1_NYC <- felm(Rent ~
              Beds_ + Baths_ + Sqft + Score | zipcode,
            data = NYC, na.action=na.pass)


m1_Philadelphia <- felm(logRent ~
                Beds_ + Baths_ + Sqft + Score | zipcode,
                data = Philadelphia, na.action=na.pass)

m1_DC <- felm(logRent ~
                Beds_ + Baths_ + Sqft + Score | zipcode,
                data = DC, na.action=na.pass)

# Collect Residuals
NYC$res1 <- resid(m1_NYC)[,1]
Philadelphia$res1 <- resid(m1_Philadelphia)[,1]
DC$res1 <- resid(m1_DC)[,1]

# Plot Residuals
ggplot() + ggtitle('Residuals') +
  labs(x="Rent", y="Residuals") +
  geom_smooth(aes(NYC$Rent, NYC$res1), se=TRUE, fullrange=FALSE,
              colour='firebrick1', fill = "firebrick1") + 
  geom_smooth(aes(Philadelphia$Rent, Philadelphia$res1), se=TRUE, fullrange=FALSE,
              colour='firebrick4', fill = "firebrick4") + 
  geom_smooth(aes(DC$Rent, DC$res1), se=TRUE, fullrange=FALSE,
              colour='yellow', fill = "yellow") 