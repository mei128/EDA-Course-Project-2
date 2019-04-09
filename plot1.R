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

# Totalize emissions from all sources
pdata <- NEI %>% group_by(year) %>% summarize(tons = sum(Emissions))

# Barplot
png("plot1.png")
par(mar=c(3,5,2,1), las = 1)
with(pdata,barplot(tons,space = 0.8, names.arg = year, col = "blue", ylab = "Tons PM 2.5",cex.axis=0.7, main = "Total PM 2.5 Emissions"))
dev.off()