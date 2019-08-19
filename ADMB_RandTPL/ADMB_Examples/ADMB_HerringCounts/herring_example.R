# ADMB Herring Example

setwd("/Users/ahart2/Research/Coding_Templates/ADMB_RandTPL/ADMB_Examples/ADMB_HerringCounts")

herring_example <- read.csv("herring_counts.txt", sep="")

# Create .DAT file
herringfile <- "herring_example.dat"
write("#Nobs", herringfile)
write(nrow(herring_example), herringfile, append=TRUE)
write("#fishCounts", herringfile, append=TRUE)
write(herring_example$count, herringfile, append=TRUE)

# Create .pin file
herringpin <- "herring_example.pin"
write("loglambda_init_val", herringpin)
write(log(36.78), herringpin) # Initial value = mean of observed counts

# Use the above to fit model without temperature or month effect

# Look at residuals from REPORT file
residuals <- scan("herring_example.rep", skip=2, n=100)
# month effect important
plot(residuals, col=herring_example$month)
plot(x=herring_example$month, y=residuals)
plot(residuals~factor(herring_example$month))
# temperature effect less important
plot(residuals~herring_example$temp)

##### To add month effect, make the following changes to .DAT and .pin files #####
# Update .DAT file
write("#fishMonth", herringfile, append=TRUE)
write(herring_example$month, herringfile, append = TRUE)
# Replace .pin file
write(rep(log(36.78), 3),herringpin)

# Look at residuals from REPORT file
residuals <- scan("herring_example.rep", skip=2, n=100)
# month effect important
plot(residuals, col=herring_example$month)
plot(x=herring_example$month, y=residuals)
plot(residuals~factor(herring_example$month))

# Look at estimated fish arrivals as estimated with month effect
exp(3.38847) # April 
exp(3.73264) # May
exp(3.61907) # June





# Notes to self:
  # When creating data files, labels for data in .dat or for initial parameters in .pin should be proceeded by # or data won't be read in!!!

