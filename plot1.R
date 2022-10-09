
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

powerset1 <- powerset[!is.na(powerset$Global_active_power),]

png("plot1.png",height=480,width=480)
with(powerset1,
     hist(Global_active_power,
          freq=TRUE,
          col='red',
          main="Global Active Power", 
          xlab="Global Active Power (kilowatts)"
          )
    )
     
dev.off()