# Code Book

This document will describe the data used in this final project, and the process to create desired tidy data set.

### Subject and Activity

The varialbes that would identify unique subject and activity:
 
- SubjectID: the integer subject ID
- ActivityName: the string with different activity names:
    + WALKING
    + WALKING_UPSTAIRS
    + WALKING_DOWNSTAIRS
    + SITTING
    + STANDING
    + LAYING
    
### Processes

1. Download the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Unzip the data and create folders (if not created before)
3. Read data into data frames
4. Combine corresponding data and rename columns
5. Extract only mean and std for each measurement and keep subjectID and activityNum columns
6. Merge two tables by activityNum and put activity name into data_feature
7. Label the data set with descriptive variable names appropriately
8. Create an independent data text file with the average of each variable for each measurement

### Files Used
* `features.txt`
* `activity_labels.txt`
* `x_train.txt`
* `y_train.txt`
* `subject_train.txt`
* `x_test.txt`
* `y_test.txt`
* `subject_test.txt`
