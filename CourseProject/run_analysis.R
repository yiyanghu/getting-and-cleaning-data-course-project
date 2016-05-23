# This file is intended to:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation 
# for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.


#download data
library(httr)
library(dplyr)
library(data.table)
library(tidyr)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <-"dataset.zip"

if(!file.exists(file)) {
        download.file(fileURL,file,method="curl")
}

#unzip the data and create folders
dataDir <-"UCI HAR Dataset"
if(!file.exists(dataDir)) {
        unzip(file,exdir=".",list=FALSE,overwrite = TRUE)
}

#read data into data frames
subject_train <-read.table(file.path(path_rf,"train","subject_train.txt"),header= FALSE)
subject_test <-read.table(file.path(path_rf,"test","subject_test.txt"),header= FALSE)

activity_train <-read.table(file.path(path_rf,"train","y_train.txt"),header= FALSE)
activity_test <-read.table(file.path(path_rf,"test","y_test.txt"),header= FALSE)

feature_train <-read.table(file.path(path_rf,"train","x_train.txt"),header= FALSE)
feature_test <-read.table(file.path(path_rf,"test","x_test.txt"),header= FALSE)

#combine corresponding data and rename columns
data_subject <- rbind(subject_train,subject_test)
setnames(data_subject,"V1","subjectID")

data_activity <- rbind(activity_train,activity_test)
setnames(data_activity,"V1","activityNum")

data_feature <-rbind(feature_train,feature_test)

features <-read.table(file.path(path_rf,"features.txt"))
setnames(features,names(features),c("featureNum","featureName"))
colnames(data_feature) <-features$featureName

activity_labels <-read.table(file.path(path_rf,"activity_labels.txt"))
setnames(activity_labels,names(activity_labels),c("activityNum","activityName"))

data_subj_act <-cbind(data_subject,data_activity)
data_feature <- cbind(data_subj_act,data_feature)

#extract only mean and std for each measurement and keep subjectID and activityNum columns
meanstdcols <- grepl("mean\\(\\)|std\\(\\)",names(data_feature))
meanstdcols[1:2] <- TRUE
data_feature <-data_feature[,meanstdcols]

#merge two tables by activityNum and put activity name into data_feature
data_feature<-merge(activity_labels,data_feature,by="activityNum",all.x=TRUE)
data_feature$activityName <- as.character(data_feature$activityName)

#appropriately label the data set with descriptive variable names
names(data_feature) <-gsub("mean\\(\\)","Mean",names(data_feature))
names(data_feature) <-gsub("std\\(\\)","Standard Deviation",names(data_feature))
names(data_feature) <-gsub("^t","time",names(data_feature))
names(data_feature) <-gsub("^f","frequency",names(data_feature))
names(data_feature) <-gsub("BodyBody","Body",names(data_feature))
names(data_feature) <-gsub("Acc","Accelerometer",names(data_feature))
names(data_feature) <-gsub("Gyro","AGyroscope",names(data_feature))
names(data_feature) <-gsub("Mag","Magnitude",names(data_feature))

#create an independent data set with the average of each variable for each measurement
sub_data_feature <-aggregate(. ~ subjectID + activityName,data_feature,mean)
sub_data_feature <- sub_data_feature[order(sub_data_feature$subjectID,sub_data_feature$activityName),]
write.table(sub_data_feature,file="tidydata.txt",row.names = FALSE)


