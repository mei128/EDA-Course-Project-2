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

# Totalize emissions from all sources... from fips == "24510"
pdata <- NEI %>% subset(fips == "24510") %>%
                 group_by(year,type) %>%
                 summarize(tons = sum(Emissions))

# ggplot with column geometry
png("plot3.png")
g <- ggplot(pdata,aes(x=as.character(year),y=tons))+
     geom_col(aes(col=type, fill=type),show.legend = FALSE)+
     labs(title="Total PM 2.5 Emissions by Type in Baltimore City")+
     ylab("Tons PM 2.5")+xlab("Year")+
     facet_wrap(.~type)+theme_light()
print(g)
dev.off()