
## downloading data and unzipping to a dedicated folder in "./data"

fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(fileUrl,temp)
unzip(zipfile=temp,exdir="./data")
unlink(temp) 

## reading data, subsetting and applying formats

powercons <- read.table("./data/household_power_consumption.txt", header=TRUE, sep=";", na.strings="?",
                        comment.char="")

powerset <- powercons[grep("(1/2/2007)|(2/2/2007)",powercons[,1]),]
powerset[,1] <- as.Date(powerset[,1],format="%d/%m/%Y")
powerset[,2] <- format(strptime(powerset[,2], format="%H:%M:%S"),format="%H:%M:%S")
for (j in 3:length(powerset[1,])) powerset[,j] <- as.numeric(powerset[,j])

## creating plot

powerset2 <- powerset[!is.na(powerset$Global_active_power),]
powerset2 <- transform(powerset2, Date=factor(weekdays(powerset2$Date,abbreviate=TRUE),levels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")))
powerset2 <- powerset2[powerset2$Date%in%c("Thu","Fri","Sat"),]

png("plot2.png",height=480,width=480)
with(powerset2,{
     plot(Global_active_power,
          type='l',
          lwd=1,
          main="", 
          ylab="Global Active Power (kilowatts)",
          xlab="",
          xaxt="n")
          
     axis(1,
        at=c(1,match("Fri",powerset2$Date),length(powerset2$Date)),
        ## at=c(match("Thu",powerset2$Date),match("Fri",powerset2$Date),match("Sat",powerset2$Date)),
        labels=c("Thu","Fri","Sat"))
  }
  )

dev.off() 