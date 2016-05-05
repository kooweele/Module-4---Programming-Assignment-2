## Plot 2 
## Question:    Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to 
##              make a plot answering this question.
## Precondition:  Setup the setWorking_ExploratoryData_Assgn2() to the directory where the data file "Data for Peer Assessment" is stored.

plot2 <- function() {
        library(lubridate)
        library(data.table)
        library(dplyr)
        library(plyr)
        library("stringr")
        library(sqldf)
        library(datasets)## plotting package
        rm(list = ls()) ## remove all R-objects in memory
        setWorking_ExploratoryData_Assgn2() ## set the path where the ZIP data file is stored
        plot_file_name="plot2.png"
        unlink(plot_file_name)
        pngfile = png(filename=plot_file_name)
        device_num <- dev.cur() 
        df <- extract_data() ## extract the raw data
        baltimore_df <- filter(df,fips=="24510") ## subset Baltimore data
        sum_emissions_by_yr <- ddply (baltimore_df, .(year), summarize, total.pm25 = sum(Emissions))
        ## get dataframes of total emissions by year
        plot(sum_emissions_by_yr$year , sum_emissions_by_yr$total.pm25, type = "l", xlab ="Year", ylab = "Total PM25/Tonnes", pch = 23, main="Baltimore Total PM2.5 (1999-2008)")
        ## label the 4 years of data points
        text(sum_emissions_by_yr[1,1],sum_emissions_by_yr[1,2],label=sum_emissions_by_yr[1,1])
        text(sum_emissions_by_yr[2,1],sum_emissions_by_yr[2,2],label=sum_emissions_by_yr[2,1])
        text(sum_emissions_by_yr[3,1],sum_emissions_by_yr[3,2],label=sum_emissions_by_yr[3,1])
        text(sum_emissions_by_yr[4,1],sum_emissions_by_yr[4,2],label=sum_emissions_by_yr[4,1])
        
        ## get dataframes of total emissions by year
        
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
