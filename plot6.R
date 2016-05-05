## Plot 6 
## Question:    Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, 
##              California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
##              
## Precondition:  Setup the setWorking_ExploratoryData_Assgn2() to the directory where the data file "Data for Peer Assessment" is stored.

plot6 <- function() {
        library(lubridate)
        library(data.table)
        library(dplyr)
        library(plyr)
        library("stringr")
        library(sqldf)
        library(ggplot2)## plotting package
        rm(list = ls()) ## remove all R-objects in memory
        setWorking_ExploratoryData_Assgn2() ## set the path where the ZIP data file is stored
        plot_file_name="plot6.png"
        unlink(plot_file_name)
        pngfile = png(filename=plot_file_name)
        device_num <- dev.cur() 
        df <- extract_data() ## extract the raw data
        ### subsetting sources of pollution from Vehicles and extract separate dafaframes for fips = Baltimore City and fips = California
        df <- subset(df, grepl("Veh", Short.Name, ignore.case = TRUE))
        
        baltimore_df <- filter(df,fips=="24510") ## subset Baltimore data
        california_df <- filter(df,fips=="06037") ## subset California data
        
        sum_emissions_by_yr_baltimore <- ddply (baltimore_df, .(year), summarize, total.pm25 = sum(Emissions))
        sum_emissions_by_yr_baltimore$County <- c("Baltimore City")  ## Add a new field called County
        
        sum_emissions_by_yr_california <- ddply (california_df, .(year), summarize, total.pm25 = sum(Emissions))
        sum_emissions_by_yr_california$County <- c("California")
        
        final_data <- rbind(sum_emissions_by_yr_baltimore,sum_emissions_by_yr_california)
        
        g <- ggplot (final_data, aes(year,total.pm25, color = County)) + geom_line(size=1.5) + labs(y="Total PM25/Tonnes", x="Year") + ggtitle("Emissions of Motor Vehicle Sources - \nBaltimore City vs California (1999-2008)")
        print(g)
        dev.off(device_num)
       
}

##
## The function that read the EPA files of emissions of PM2.5 into 2 raw dataframes NEI and SCC and merge the 2 based on common column "SCC" and return the 
## merged result.
## Assumption: The raw ZIP file is already downloaded in the R working directory specifed in setWorking_ExploratoryData_Assgn2 function.
## 
## NEI dataframe        : a data frame read from "summarySCC_PM25.rds" with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. 
##                      For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year.
## 
## SCC dataframe        : contains data from "Source_Classification_Code.rds" that provides a mapping from the SCC digit strings in the Emissions table to      ##                      the actual name of the PM2.5 source. 

extract_data <- function() {
        library(sqldf)
        ## download and unzip data from assignment
        downloaded_zip_filename = "exdata-data-NEI_data.zip" ## name of downloaded file
        unzip(downloaded_zip_filename)
        
        ## This first line will likely take a few seconds. Be patient!
        NEI_df <- readRDS("summarySCC_PM25.rds")
        SCC_df <- readRDS("Source_Classification_Code.rds")
        merged_df <- merge(SCC_df, NEI_df, by = "SCC")
        merged_df
}

## set the working path where the ZIP data file is stored
setWorking_ExploratoryData_Assgn2 <- function() {
        homedir <- "D:/Users/Koo Wee Leong/My Documents/My Education/Coursera/Data Science - John Hopkins/R-Workspace/Exploratory Data Analysis - Programming Assignment 2/"
        setwd(homedir)       
}
