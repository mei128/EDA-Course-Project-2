library(ggplot2)

# Download data if there is no local copy

dataPath1 <- "summarySCC_PM25.rds"
dataPath2 <- "Source_Classification_Code.rds"

if (!file.exists(dataPath1)) {
    dataURL   <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    dataZIP   <- "data.ZIP"
    download.file(dataURL,destfile = dataZIP, method = "curl")
    unzip(dataZIP,exdir = ".")
    file.remove(dataZIP)
}

# Read data
if (!exists("NEI")) NEI <- readRDS(dataPath1)
if (!exists("SCC")) SCC <- readRDS(dataPath2)

# Select vehicle SCC codes

motor <- SCC[grep("Vehicle",SCC$SCC.Level.Two),]

# Select Baltimore data and totalize emissions data from selected SCCs

pdata <- subset(NEI,fips == "24510")
pdata <- pdata[pdata$SCC %in% motor$SCC,] %>%
            group_by(year) %>%
            summarize(tons = sum(Emissions))

# Barplot
png("plot5.png")
par(mar=c(3,5,5,2), las = 1)
with(pdata,barplot(tons,space = 0.8,
                   names.arg = year,
                   col = "powderblue",
                   ylab = "Tons PM 2.5",
                   cex.axis=0.7))
title("Total PM 2.5 Emissions from Motor Vehicles in Baltimore City", adj=1)
dev.off()
