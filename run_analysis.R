library(plyr)

# Check for existing file, then download the data
if(!file.exists("./GettingandCleaningDataCourseProject")){dir.create("./GettingandCleaningDataCourseProject")}
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url, destfile = "./GettingandCleaningDataCourseProject/projectdataset.zip")

# Unzip file
unzip(zipfile = "./GettingandCleaningDataCourseProject/projectdataset.zip", exdir = "./GettingandCleaningDataCourseProject")

#Read training data
x_train <- read.table("./GettingandCleaningDataCourseProject/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./GettingandCleaningDataCourseProject/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./GettingandCleaningDataCourseProject/UCI HAR Dataset/train/subject_train.txt")

#Read test data
x_test <- read.table("./GettingandCleaningDataCourseProject/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./GettingandCleaningDataCourseProject/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./GettingandCleaningDataCourseProject/UCI HAR Dataset/test/subject_test.txt")

#Read features
features <- read.table("./GettingandCleaningDataCourseProject/UCI HAR Dataset/features.txt")

#Read activity labels
activityLabels = read.table("./GettingandCleaningDataCourseProject/UCI HAR Dataset/activity_labels.txt")

#Assign variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityid"
colnames(subject_train) <- "subjectid"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityid"
colnames(subject_test) <- "subjectid"
colnames(activityLabels) <- c("activityid", "activityType")

#Merge datasets into one
alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(alltrain, alltest)

#Extract mean and sd

#Read column names
colNames <- colnames(finaldataset)

#Create vector for defining ID, mean, and sd
mean_and_std <- (grepl("activityid", colNames) |
                   grepl("subjectid", colNames) |
                   grepl("mean..", colNames) |
                   grepl("std...", colNames)
)

#Make subset
setforMeanandStd <- finaldataset[ , mean_and_std == TRUE]

#Use descriptive activity names
setWithActivityNames <- merge(setforMeanandStd, activityLabels,
                              by = "activityid",
                              all.x = TRUE)

#Make second tidy data set
tidySet <- aggregate(. ~ subjectid + activityid, setforMeanandStd, mean)
tidySet <- tidySet[order(tidySet$subjectid, tidySet$activityid), ]

#Write second tidy data set into a txt file
write.table(tidySet, "tidySet.txt", row.names = FALSE)

