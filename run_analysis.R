###############################################################################
# Coursera Data Science Specialization                                        #
# Course #3, Getting and Cleaning Data                                        #
# Instructor Jeff Leek                                                        #
# Peer Assessment/Class Project                                               #
#                                                                             #
# GitHub repository dlaird/CDSS3-ClassProject                                 #
#                                                                             #
# by David Laird                                                              #
# April 25, 2014                                                              #
#                                                                             #
#                                                                             #
# The following script implements code necessary to fulfill the requirements  #
# for the class project.  It assumes the data have been extracted and reside  #
# in their original subdirectories off the the working directory.  The        #
# original source data can be found here:                                     #
#                                                                             #
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#                                                                             #
# The project requirements are as follows:                                    #
# You should create one R script called run_analysis.R that does              #
#    the following.                                                           #
# 1. Merges the training and the test sets to create one data set.            #
# 2. Extracts only the measurements on the mean and standard deviation        #
#    for each measurement.                                                    #
# 3. Uses descriptive activity names to name the activities in the data set   #
# 4. Appropriately labels the data set with descriptive activity names.       #
# 5. Creates a second, independent tidy data set with the average of each     #
# variable for each activity and each subject.                                #
#                                                                             #
###############################################################################

#1. "Merges the training and the test sets to create one data set."
###############################################################################
# This step will include combining the training and test data with their 
# corresponding activity and subject columns, which were provided in separate 
# files, and then combining the full test and training datasets.
#1.1 Load main training and test datasets.
trainDataFile <- "UCI HAR Dataset/train/X_train.txt"
testDataFile <- "UCI HAR Dataset/test/X_test.txt"
trainDS <- read.table(trainDataFile)
testDS <- read.table(testDataFile)

#1.2 Add column names.  These are required later, but it is easier to do here.
featuresFile <- "UCI HAR Dataset/features.txt"
featuresDS <- read.table(featuresFile)
colnames(trainDS) <- featuresDS$V2
colnames(testDS) <- featuresDS$V2

#1.3 Add descriptive activities to the main datasets
#1.3.1 Load activity code data.
trainActivityFile <- "UCI HAR Dataset/train/Y_train.txt"
testActivityFile <- "UCI HAR Dataset/test/Y_test.txt"
trainActivity <- read.table(trainActivityFile)
testActivity <- read.table(testActivityFile)

#1.3.2 Define descriptive names for the activity codes
activityNames <- c(WALKING=1, 
                   WALKING_UPSTAIRS=2,
                   WALKING_DOWNSTAIRS=3,
                   SITTING=4,
                   STANDING=5,
                   LAYING=6)

#1.3.3 Add a column with descriptive names to the activity datasets
trainActivity$descriptive <- names(activityNames)[match(trainActivity[,1],activityNames)]
testActivity$descriptive <- names(activityNames)[match(testActivity[,1],activityNames)]

#1.3.4 Bind the activity description columns to the main datasets.
# Give them the same name so that rbind() does not complain in step 1.5
trainDS <- cbind(trainActivity$descriptive, trainDS)
testDS <- cbind(testActivity$descriptive, testDS)
colnames(trainDS)[1] <- "Activity"
colnames(testDS)[1] <- "Activity"

#1.4 Add the subject column to the main datasets.
#1.4.1 Load subject code data.
trainSubjectFile <- "UCI HAR Dataset/train/subject_train.txt"
testSubjectFile <- "UCI HAR Dataset/test/subject_test.txt"
trainSubject <- read.table(trainSubjectFile)
testSubject <- read.table(testSubjectFile)

#1.4.2 Bind the subject columns to the main datasets.
trainDS <- cbind(trainSubject,trainDS)
testDS <- cbind(testSubject,testDS)
colnames(trainDS)[1] <- "Subject"
colnames(testDS)[1] <- "Subject"

#1.5 Combine the training and test datasets into one
step1DS <- rbind(trainDS,testDS)

#2. "Extracts only the measurements on the mean and standard deviation
#    for each measurement."
###############################################################################
#2.1 Find out which columns are mean and standard deviations
means<-grep("mean",featuresDS[,2])
stds<-grep("std",featuresDS[,2])
meansAndStds<-sort(c(means,stds))
#2.1.2 Displace the counter by two since there are two new columns on the left
meansAndStds<-meansAndStds + 2 
#2.1.3 Adds counter to selection vector for new Subject and Activity columns
meansAndStds<-c(1,2,meansAndStds) 

#2.2 Extract just those columns into a new dataset.
step2DS <- step1DS[,meansAndStds]

#3 "Uses descriptive activity names to name the activities in the data set." 
# and 
#4 "Appropriately labels the data set with descriptive activity names."
###############################################################################
# These two requirements are somewhat vague but I think they have been handled  
# by providing descriptive labels to all columns in step 1.1, and by adding 
# descriptive activity names in step 1.2.

#5 "Creates a second, independent tidy data set with the average of each  
# variable for each activity and each subject."
###############################################################################
# This requirement is a little ambiguous and could be interpretted as requiring  
# means for each variable for each activity (one set of means for each of six 
# activities, or six rows) plus means for each variable for each subject (one 
# set of means for each of 30 subjects, or 30 rows).  This would result in a 
# data frame with 36 rows.  The other possible interpretation is that the means 
# should be calculated on each interaction of activity and subject, resulting  
# in a data frame with 180 rows (30 subjects, each with a mean for each 
# activity).  The solution is similar in either case, but the second 
# interpretation will be implemented here.  The main reason is that if the 
# first interpretation were followed it would result in a less tidy data set.   
# Only one data set is requested, so it would either have to implement one 
# column for Activity/Subject, which would be in violation of tidy dataset  
# principles by mixing data types in a column, or it would require two mutually
#  exclusive columns, and if the columns are mutually exclusive, then they
# should be in separate data frames, not the same one.
library(reshape2)
step2DSmelt <- melt(step2DS,id.vars = c("Subject", "Activity"))
step5DS <- dcast(step2DSmelt,Subject + Activity ~ variable,mean)
step5DSFile = "ProjectOutput.txt"
write.table(step5DS,step5DSFile)

# End of script
###############################################################################