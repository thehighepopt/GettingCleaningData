##You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements 
##      on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second,  
##      independent tidy data set with the average of each variable for each activity and each subject.

run_analysis <- {
##This section downloads and unpacks the zip file to a directory and sets the working directory to the new directory
      ##Run if you don't have the data set already
##fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##download.file(fileUrl, "./data/getdatacp.zip")
##unzip("./getdatacp.zip", exdir= "./data")
##setwd("./data")


##This section reads in all necessary files, first supporting info, UCI HAR dataset folder must be in working directory
header <- read.table("./UCI HAR Dataset/features.txt")
activities_lkup <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Activity_Code","Activity"))

## then combining the test and train data sets (#1), while adding in variable names (#4)
test_train <- rbind(read.table("./UCI HAR Dataset/test/X_test.txt", col.names = header[,2]), read.table("./UCI HAR Dataset/train/X_train.txt", col.names = header[,2]))

## Then keep only the mean and std columns --fixed saved the day (#2)
keepers <- subset(header, grepl("mean()", header[,2], fixed = TRUE) | grepl("std()",header[,2], fixed = TRUE))
test_train_mean_std <- subset(test_train, select = keepers[,1])

##Now add in missing columns
subject <- rbind(read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject"),read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject"))
activity_code <- rbind(read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity_Code"),read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity_Code"))
ttms_sub_act <- cbind(subject, activity_code, test_train_mean_std)
#and merging data frames for #3
final_test_train <- merge(ttms_sub_act,activities_lkup,all=TRUE)

##And now for #5
library(dplyr)
tidy_data <-
      tbl_df(final_test_train) %>%
      group_by(Activity,Subject) %>%
      summarise_each(funs(mean)) %>%
      arrange(Activity, Subject)

write.table(tidy_data,file = "tidydata.txt", row.name=FALSE)
}