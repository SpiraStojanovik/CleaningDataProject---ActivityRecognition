CleaningDataProject---ActivityRecognition
=========================================

## Introduction 

This project uses data sets from the Human Activity Recognition database to create a one tidy summarised data set called "Activity Measurements.txt". 

Information on the Human Activity Recognition database is available on this <a href= "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"> webpage</a>.
 

This is an extract from the above webpage which discribes the data: *The experiments have been carried out with a group of 30 volunteers. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz.......From each window, a vector of features was obtained by calculating variables from the time and frequency domain.* 

The project objective is to create a tidy data set that contains the average values of selected measurements for each volunteer (study subject) and each activity; as a result the tidy data set has 180 rows. The original data set contains 561 variables. Only 66 variables (related to measurements) are presented in the tidy data set as these are the variables associated with measurements that have a pair of mean and standard deviation. For example,the measurement of acceleration of the body in the X direction has these two variables:"tBodyAcc-mean()-X" & "tBodyAcc-std()-X"; one for mean and one for standard deviation. 


## Files in this repo

This repository contains the following files:
* README.md - this file 
* ActivityProjectCode.R - script to create the tidy data set
* Activity Measurements.txt - tidy data set, a tab delimited text file
* CodeFile.pdf - description of the variables in "Activity Measurements.txt"


## Data inclusion/ exclusion 

The Human Activity Recognition database could be downloaded from this webpage: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The database contains many datasets. For the project, only the following files are used:   

* X_test.txt 
* Y_test.txt
* subject_test.txt 
* X_train.txt
* Y_train.txt
* subject_train.txt
* features.txt
* activity_labels.txt

The other files in the database are not used in this project, as they have no relevance to the project objective. In particular the files in the "Inertial Signals" folder seem to be unprocessed measurements, and I am guessing that these were used to caclulate the variables presented in the X_test and X_train data sets. 


## Requirements clarification and interpretation

**Further detail on the reasoning for selection of variables**
(see Introduction for overview)

The original data set has 33 variables with the word "std" in it, and 53 variables with the word "mean" in it. I have decided to only select measurements that have a matching "mean" and "std" so that the user of the tidy data set can analyse 
the average of the mean and the std for the various measurements. 

The following variables have the word "mean" in them but are excluded as they dont have a "std" pair: 

* 13 variables that contain "meanFreq", and 
* 7 variables associated with angle measurements


## Naming convention 

Variable names kept for the tidy data set are generally using the naming convention in the original set for the following reason: 
* the names are descriptive and short in the same time
* users of the original data sets are familiar with the names and would not have a difficilty using the names in the tidy data set

However, the names are cleaned up to remove the following symbols: "_","(",")" and excessive dots. Some dots remain to improve readibility. Example: "tBodyAcc.mean.Y"


## Some plots showing interesting patterns in the tidy data set

Listed below are some plots showing interesting relationships. The plots are generated with the lattice plotting package. 

### Plot 1

![plot of chunk plot1](figure/plot1.png) 



The script for the plots is provided below. 

library(lattice)
png(file = "plot1.png",width = 600, height = 480,)
xyplot(tGravityAcc.mean.X ~ tGravityAcc.std.X | activity, data = dataTidy,col=subject)
dev.off()
png(file = "plot2.png",width = 600, height = 480,)
xyplot(tBodyAccMag.mean ~ tBodyAccMag.std | activity, data = dataTidy,col=subject)
dev.off()
png(file = "plot3.png",width = 600, height = 480,)
xyplot(tGravityAccMag.mean ~ tBodyAccMag.mean | activity, data = dataTidy,col=subject)
dev.off()
png(file = "plot4.png",width = 600, height = 480,)
xyplot(fBodyAccMag.mean ~ fBodyAccMag.std | activity, data = dataTidy,col=subject)
dev.off()

