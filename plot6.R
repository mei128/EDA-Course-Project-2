library(dplyr)
library(ggplot2)
library(ggpubr)

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

# Select Baltimore and LA data, tidy, and totalize emissions data from selected SCCs

pdata <- subset(NEI,fips == "24510" | fips == "06037")
pdata$fips <- gsub("24510","Baltimore",pdata$fips)
pdata$fips <- gsub("06037","Los Angeles",pdata$fips)
pdata <- pdata[pdata$SCC %in% motor$SCC,] %>%
            group_by(fips,year) %>%
            summarize(tons = sum(Emissions))

# ggplot with column geometry
# png("plot6.png")
g <- ggplot(pdata,aes(x=as.character(year),y=tons))+
        geom_col(aes(col=fips, fill=fips),show.legend = FALSE)+
        labs(title="Total PM 2.5 Emissions from Motor Vehicles")+
        ylab("Tons PM 2.5")+xlab("Year")+
        geom_smooth(method='lm')+
        facet_wrap(.~fips)+theme_light()
print(g)
#dev.off()