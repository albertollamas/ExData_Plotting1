getwd()
rm(list=ls())

if (!file.exists("data")){
  dir.create("data")
}
#I downladed the zipfile to a folder called zipdir under the working directory folder, and
#extracted it into a folder called data. Then read the full file and subset the observations indicated.

unzip("zipdir/exdata-data-household_power_consumption.zip",exdir="data")

readData<-read.table("data/household_power_consumption.txt",sep=";",na.strings = "?",header=TRUE,stringsAsFactors = FALSE)

DataDates<-readData[grep("^[1,2]/2/2007",readData$Date),]

#I convert dates and times to actual dates and times, first I need to change my locale settings so the dates abreviations
#on the axis will stay in English
#1-save your current locale
original_locale<-Sys.getlocale(category = "LC_TIME")

#2-change it to english
Sys.setlocale(category = "LC_TIME", locale = "English_United States.1252")

#strptime, when applied to the time column, creates a date info (default is te current date) therefore I create the today
#variable to substract it from the new time string before creating a new column that pastes date and time
today<-Sys.Date()

DataDates$Date<-strptime(DataDates$Date,format="%d/%m/%Y")
DataDates$Time<-sub(today,"", strptime(DataDates$Time,format="%H:%M:%S"))
DataDates$datetime<-strptime(paste(DataDates$Date,DataDates$Time,sep=" "), format="%Y-%m-%d %H:%M:%S")

# I open the png graphic device, create the plot (480x480 is the default for png device) and close the device

png(filename = "plot1.png")

with(DataDates,hist(Global_active_power,col="red",xlab="Global Active Power (kilowatts)",main="Global Active Power"))

dev.off()

#change the locale back to the original setting
Sys.setlocale(category = "LC_TIME", locale = original_locale)
