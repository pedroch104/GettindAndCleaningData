# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 
# You will be required to submit: 
#   1) a tidy data set as described below, 
#   2) a link to a Github repository with your script for performing the analysis, and 
#   3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.  

## INSTRUCTIONS
# 1 - Merges the training and the test sets to create one data set.
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3 - Uses descriptive activity names to name the activities in the data set
# 4 - Appropriately labels the data set with descriptive variable names. 
# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## verifies packages
if (!require("dplyr")) {
  install.packages("dplyr") 
  require("dplyr")}
if (!require("reshape2")) {
  install.packages("reshape2")
  require("reshape2")
}

## Downloads the training and test data sets
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "trainingdata.zip", method = "curl")
unzip("trainingdata.zip")

## imports datasets
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
features<-read.table("./UCI HAR Dataset/features.txt")
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")

# 4 - Appropriately labels the data set with descriptive variable names.
xnames<-c(as.character(features[,2]))
colnames(x_train)<-xnames
colnames(x_test)<-xnames
colnames(y_train)<-"Activity"
colnames(y_test)<-"Activity"
colnames(subject_train)<-"Subject"
colnames(subject_test)<-"Subject"

# 1 - Merges the training and the test sets to create one data set.
## binding all training data
train_ds<-cbind(subject_train,y_train,x_train)
## binding all test data
test_ds<-cbind(subject_test,y_test,x_test)
## merging both to a complete training and test data set
complete_ds<-rbind(train_ds,test_ds)

# 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
## discarding all but mean and standard deviation columns type and keeping subject and activity columns
mean_std_ds <- complete_ds[, grep("mean|std|Subject|Activity", names(complete_ds))]

# 3 - Uses descriptive activity names to name the activities in the data set
actv <- as.character(activity_labels[,2])
## overwriting the Activity ID with descriptive labels
final_ds <- mutate(mean_std_ds, Activity = actv[Activity])

# 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
melted_ds = melt(final_ds, id.var = c("Subject", "Activity"))
## calculating mean by groups of subject and activity
tidy_ds = dcast(melted_ds , Subject + Activity ~ variable, mean)

## Saving the final tidy data set
write.table(tidy_ds,"final_tidy_data_set.txt", row.names = FALSE)
