## Download and unzip the data
filename <- "getdata_dataset.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## 1. Merges the training and the test sets to create one data set.
# Load the datasets
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./UCI HAR Dataset/features.txt')
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt')

# Give name to each column
colnames(xtrain) <- features[,2]
colnames(ytrain) <-"activityId"
colnames(train_subjects) <- "subjectId"

colnames(xtest) <- features[,2] 
colnames(ytest) <- "activityId"
colnames(test_subjects) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# Combine test and training sets into one set
train <- cbind(xtrain, ytrain, train_subjects)
test <- cbind(xtest, ytest, test_subjects)
combined_set <- rbind(train, test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# columns that will remain in the set
desired_columns <- grepl("subject|activity|mean|std", colnames(combined_set))

# extract the desired columns
combined_set <- combined_set[, desired_columns]

## 3. Uses descriptive activity names to name the activities in the data set.
set_activitynames <- merge(combined_set, activityLabels, by='activityId', all.x=TRUE)

## 4. Appropriately labels the data set with descriptive variable names.
# previously completed

## 5. From the data set in step 4, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.

tidydata <- aggregate(. ~subjectId + activityId, set_activitynames, mean)
tidydata <- tidydata[order(tidydata$subjectId, tidydata$activityId),]

# 
write.table(tidydata, "tidy.txt", row.names = FALSE, quote = FALSE)



