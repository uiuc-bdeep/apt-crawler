aprtments$Rent <- as.numeric(levels(aprtments$rent))[aprtments$rent]
aprtments$Beds <- as.numeric(levels(aprtments$beds))[aprtments$beds]
aprtments$Baths <- as.numeric(levels(aprtments$baths))[aprtments$baths]
aprtments$Sqft <- as.numeric(levels(aprtments$sqft))[aprtments$sqft]
aprtments$Score <- as.numeric(as.character(aprtments$score))
aprtments$rent1 <- sub("$",'',as.character(aprtments$rent),fixed=TRUE)
aprtments$Rent <- as.numeric(sub(",",'',as.character(aprtments$rent1),fixed=TRUE))
aprtments$Zip <- as.factor(aprtments$zipcode)
aprtments$Beds_ <- as.factor(aprtments$Beds)
aprtments$Baths_ <- as.factor(aprtments$Baths)

aprtments <- subset(aprtments, Rent!="NA")	

NYC <- subset(aprtments, city=="New York")
Philadelphia <- subset(aprtments, city=="Philadelphia")
DC <- subset(aprtments, city=="Washington")

m1_NYC <- lm(Rent ~
              Beds_ + Baths_ + Sqft + Score + Zip,
              data = NYC, na.action=na.exclude)

NYC$res1 <- resid(m1_NYC)

NYCresid <- subset(NYC, Rent <= 5035)

ggplot() + ggtitle('Residuals') +
  labs(x="Rent", y="Residuals") +
  geom_smooth(aes(NYCresid$Rent, NYCresid$res1), se=TRUE, fullrange=FALSE,
              colour='firebrick1', fill = "firebrick1")

# m1_NYC <- felm(Rent ~
#               Beds + Baths + Sqft + Score | zipcode,
#             data = NYC, na.action=na.pass)

# m1_Philadelphia <- felm(Rent ~
#                 Beds + Baths + Sqft + Score | zipcode,
#               data = Philadelphia, na.action=na.pass)

# m1_DC <- felm(Rent ~
#                 Beds + Baths + Sqft + Score | zipcode,
#               data = DC, na.action=na.pass)

# Collect Residuals

NYC$res1 <- resid(m1_NYC)[,1]
Philadelphia$res1 <- resid(m1_Philadelphia)[,1]
DC$res1 <- resid(m1_DC)[,1]


ggplot() + ggtitle('Residuals') +
  labs(x="Rent", y="Residuals") +
  geom_smooth(aes(NYC$Rent, NYC$res1), se=TRUE, fullrange=FALSE,
              colour='firebrick1', fill = "firebrick1") + 
  geom_smooth(aes(Philadelphia$Rent, Philadelphia$res1), se=TRUE, fullrange=FALSE,
              colour='firebrick4', fill = "firebrick4") + 
  geom_smooth(aes(DC$Rent, DC$res1), se=TRUE, fullrange=FALSE,
              colour='yellow', fill = "yellow") 