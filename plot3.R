## Plot 3 
## Question:    Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 
##              1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

## Precondition:  Setup the setWorking_ExploratoryData_Assgn2() to the directory where the data file "Data for Peer Assessment" is stored.

plot3 <- function() {
        library(lubridate)
        library(data.table)
        library(dplyr)
        library(plyr)
        library("stringr")
        library(sqldf)
        library(ggplot2)## plotting package
        rm(list = ls()) ## remove all R-objects in memory
        setWorking_ExploratoryData_Assgn2() ## set the path where the ZIP data file is stored
        plot_file_name="plot3.png"
        unlink(plot_file_name)
        pngfile = png(filename=plot_file_name)
        device_num <- dev.cur() 
        df <- extract_data() ## extract the raw data
        baltimore_df <- filter(df,fips=="24510") ## subset Baltimore data
        grp_baltimore_df_type <- ddply (baltimore_df, .(type,year), summarize, total.pm25 = sum(Emissions))
        g <- ggplot (grp_baltimore_df_type, aes(year,total.pm25, color = type)) + geom_line(size=1.5) + labs(y="Total PM25/Tonnes", x="Year") + ggtitle("Baltimore City PM2.5 by Type (1999-2008)")
         
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
