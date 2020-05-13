## Describe, Load and Merge Data ##

dataDescription <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(dataUrl, destfile = "data.zip")
unzip("data.zip")

activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

test <- cbind(subject_test, y_test, x_test)
train <- cbind(subject_train, y_train, x_train)

data_main <- rbind(test, train)

## Mean and St.Dev ##

allNames <- c("subject", "activity", as.character(features$V2))
mean_stdColumns <- grep("subject|activity|[Mm]ean|std", allNames, value = FALSE)
smallset <- data_main[ ,mean_stdColumns]

## Description for Activity ##

names(activity) <- c("ActivityNumber", "ActivityName")
smallset$V1.1 <- activity$ActivityName[smallset$V1.1]

## Dataset Labeling ##

SmallNames <- allNames[mean_stdColumns]
SmallNames <- gsub("mean", "Mean", SmallNames)
SmallNames <- gsub("std", "Std", SmallNames)
SmallNames <- gsub("gravity", "Gravity", SmallNames)
SmallNames <- gsub("[[:punct:]]", "", SmallNames)
SmallNames <- gsub("^t", "time", SmallNames)
SmallNames <- gsub("^f", "frequency", SmallNames)
SmallNames <- gsub("^anglet", "AngleTime", SmallNames)
names(smallset) <- SmallNames

## Tidy Data ##

library("dplyr")
tidydata <- smallset %>% group_by(activity, subject) %>% summarise_all(funs(mean))

write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
validate <- read.table("tidydata.txt")
View(validate)

sessionInfo()
