# STEP 1 - READ AND COMBINE DATA SETS ----

# Source data sets ====

# Source of original data sets:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# Save the following files in the working directory:
    # X_test.txt, Y_test.txt, subject_test.txt, 
    # X_train.txt,Y_train.txt,subject_train.txt
    # features.txt, activity_labels.txt
# the other files in the source above are not used in this project

# set the working director ====
setwd("C:/Documents and Settings/piko/Desktop/Coursera/03 Getting and cleaning data/ActivityRecognitionProject/CleaningDataProject---ActivityRecognition")

# read files, add column names, bind subject and activity to the data ====

## test data
test_data<-read.table("X_test.txt")
features<-read.table("features.txt")
## add variable names
names_data<-features[,2]
names(test_data)<-names_data
test_activity<-read.table("Y_test.txt")
names(test_activity)<-c("activityID")
test_subject<-read.table("subject_test.txt")
names(test_subject)<-c("subject")
## column bind (add activity and subject to each record)
test<-cbind(test_subject,test_activity,test_data)

## do the same with train data
train_data<-read.table("X_train.txt")
names(train_data)<-names_data
train_activity<-read.table("Y_train.txt")
names(train_activity)<-c("activityID")
train_subject<-read.table("subject_train.txt")
names(train_subject)<-c("subject")
## column bind 
train<-cbind(train_subject,train_activity,train_data)

## bind the test and train data frame i.e. keep columns, add rows
dataAll<-rbind(test,train)

# STEP 2 - EXTRACT RELEVANT MEASUREMENTS ----

# Description of the reasoning for selection of variables ====

# the original data set has 33 variables with the word "std" in it, and 
# 53 variables with the word "mean" in it
# I have decided to only select measurements that have a matching "mean" and "std"
# so that the user of the tidy data set can analyse 
# the average of the mean and the std for the various measurements

# extract measurements that have both mean and std value ====

# remove measurements with "meanFreq" (this removes 13 unwanted measurements)
dataExtr1<-dataAll[,grep("meanFreq",colnames(dataAll),ignore.case=FALSE, invert=TRUE,perl=TRUE)]
# create a data set of the remaining measurements with "mean"
# set the ignore.case to FALSE so that 7 measurements associated with angle
# are not counted (for these measurements mean has upper case i.e "Mean" )
dataExtr2<-dataExtr1[,grep("mean",colnames(dataExtr1),ignore.case=FALSE, perl=TRUE)]
# create a data set of measurements with "std"
dataExtr3<-dataExtr1[,grep("std",colnames(dataExtr1),ignore.case=TRUE, perl=TRUE)]
# merge the extracts into a new data set and add the activity subject columns
dataExtr<-cbind(dataAll[,1:2],dataExtr2,dataExtr3)

# STEP 3 - READ ACTIVITY LABELS DATA SET ----

# read the labels file, add col names, replace int vector with a factor
labels<-read.table("activity_labels.txt")
names(labels)<-c("activityID","activity")
labels$activityID<-factor(labels$activityID)

# the merging of the data sets (labels and data) to replace num with string 
# is done in step 5

# STEP 4 - CLEAN UP NAMES ----

# use make.names() to remove () and _
# then use sub() to remove excess dots 
colnames(dataExtr)<-sub("..","",make.names(colnames(dataExtr)),fixed=TRUE)
# Note: have not removed the single dots to improve readability

# STEP 5 - CREATE TIDY DATA SET ----

# calculate columns means ====

# split the by activity and subject i.e. create a list of 180 combinations
s<-split(dataExtr,list(dataExtr$activityID,dataExtr$subject))

# calculate column means for each of the levels in s; first 2 columns are excluded
y<-sapply(s,function(x) colMeans(x[,colnames(dataExtr)[3:length(colnames(dataExtr))]]))
# transpose the result so that the 180 combination are records (rows)
dataMean<-t(y)

# create seperate columns for activity and subject ====

# activity and subject are combined in one column so need to split them 
# split the values in row.names() and make 2 variables out of the result (1st and 2nd element)
splitNames = strsplit(rownames(dataMean),"\\.") 
firstElement<-function(x){x[1]}
activityID<-factor(sapply(splitNames, firstElement))
z1<-cbind(activityID,dataMean)
secondElement<-function(x){x[2]}
subject<-factor(sapply(splitNames,secondElement))
z2<-cbind(subject,z1)

# replace numbers in activity with names ====
# merge with the data set in STEP 3
dataLab = merge(labels, z2, by.x ="activityID", by.y="activityID", all=TRUE)
# remove the activity ID variable;
dataTidy<-dataLab[,2:length(colnames(dataLab))]

# create a text file, saved in the working directory ====
write.table(dataTidy,file = "Activity Measurements.txt",sep = "\t",row.names=FALSE)
# this is a tab delimited text file that can be opened in excel 


# EXTRA STEP - DOING SOME PLOTS ----

library(lattice)
xyplot(fBodyBodyGyroJerkMag.mean ~ fBodyBodyGyroJerkMag.std | activity, data = dataLab)

# INTERESTING CHARTS
xyplot(tGravityAcc.mean.X ~ tGravityAcc.std.X | activity, data = dataLab)
xyplot(tBodyAccMag.mean ~ tBodyAccMag.std | activity, data = dataLab)
xyplot(tGravityAccMag.mean ~ tBodyAccMag.mean | activity, data = dataLab)
xyplot(fBodyAccMag.mean ~ fBodyAccMag.std | activity, data = dataLab)


