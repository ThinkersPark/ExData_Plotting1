
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

powerset4 <- powerset[( !is.na(powerset$Voltage) && 
                        !is.na(powerset$Global_reactive_power) && 
                        !is.na(powerset$Sub_metering_1) && 
                        !is.na(powerset$Sub_metering_2) && 
                        !is.na(powerset$Sub_metering_3)),]
powerset4 <- transform(powerset4, Date=factor(weekdays(powerset4$Date,abbreviate=TRUE),levels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")))
powerset4 <- powerset4[powerset4$Date%in%c("Thu","Fri","Sat"),]

png("plot4.png",height=480,width=480)
par(mfrow=c(2,2),mar=c(4,4,1,2),oma=c(2,2,0,0))
with(powerset4,{
  
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
  
  plot(Voltage,
       type='l',
       lwd=1,
       main="", 
       ylab="Voltage",
       xlab="datetime",
       xaxt="n")
  axis(1,
       at=c(1,match("Fri",powerset2$Date),length(powerset2$Date)),
       ## at=c(match("Thu",powerset2$Date),match("Fri",powerset2$Date),match("Sat",powerset2$Date)),
       labels=c("Thu","Fri","Sat"))
  
  plot(Sub_metering_1,
       type='l',
       lwd=1,
       main="", 
       ylab="Energy sub metering",
       xlab="",
       xaxt="n")
     lines(Sub_metering_2,lwd=1,col="red")
     lines(Sub_metering_3,lwd=1,col="blue")
     axis(1,
       at=c(1,match("Fri",powerset3$Date),length(powerset3$Date)),
       ## at=c(match("Thu",powerset3$Date),match("Fri",powerset3$Date),match("Sat",powerset3$Date)),
       labels=c("Thu","Fri","Sat"))
     legend("topright",lty=c(1,1,1), col=c("black","red","blue"),
         legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
     
  plot(Global_reactive_power,
          type='l',
          lwd=1,
          main="", 
          ylab="Global ReActive Power",
          xlab="datetime",
          xaxt="n")
      axis(1,
        at=c(1,match("Fri",powerset2$Date),length(powerset2$Date)),
        ## at=c(match("Thu",powerset2$Date),match("Fri",powerset2$Date),match("Sat",powerset2$Date)),
        labels=c("Thu","Fri","Sat"))
      
}
)
dev.off()