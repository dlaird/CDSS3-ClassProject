
#Coursera Data Science Specialization Course #3 - Class Project
#==============================================================

##Run script:  run_analysis.R
##Script output:  ProjectOutput.txt

##How the run_analysis.R Script Works

The attached run_analysis.R script takes as input Samsung data files contained in a zip file located at this URL:

*https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip*

The zip file should be uncompressed and the contents placed the working directory.

run_analysis.R then processes the datafiles to complete the following steps:

1 Merges the training and the test sets to create one data set.
2 Extracts only the measurements on the mean and standard deviation for each measurement.
3 Uses descriptive activity names to name the activities in the data set.
4 Appropriately labels the data set with descriptive activity names.
5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Step 1: Merges the training and the test sets to create one data set.
-------------------------------------------------------------------------
Two files containing the numerical data from training and test subjects are read into datasets.  These files are:

**UCI HAR Dataset/train/X_train.txt**
**UCI HAR Dataset/test/X_test.txt**

Column names are read from a separate file and column names added to the two datasets created above.  Column names are read from:

**UCI HAR Dataset/features.txt**

Activities during which the numerical data was collected are provided in separate files, one each for the training and test datasets.  They are provided as codes between 1 and 6.  run_analysis.R first reads the activity codes from the following files:

**UCI HAR Dataset/train/Y_train.txt**
**UCI HAR Dataset/test/Y_test.txt**

Then descriptive names are assigned to each activity code, as follows:

*WALKING=1*
*WALKING_UPSTAIRS=2*
*WALKING_DOWNSTAIRS=3*
*SITTING=4*
*STANDING=5*
*LAYING=6*

Next, these descriptive names are added as a new column to the two datasets containing the activity codes, and in a separate step the new column is added to each of the datasets containing the numerical data.

run_analysis then performs a similar operation to add columns to the numerical datasets for each of the test subject codes.  However, the test subject codes are left as they are so it is a shorter process.  Subject codes are read from the following files:

**UCI HAR Dataset/train/subject_train.txt**
**UCI HAR Dataset/test/subject_test.txt**

At this point there are two data sets, one for training data and one for test data, and each containing the subject, the activity description, and the full complement of data columns as provided in the original.  The final part of Step 1 is to combine these two datasets into one.

### Step 2: Extracts only the measurements on the mean and standard deviation.
------------------------------------------------------------------------------
Requirements call for a new dataset to be created that contains only the columns with mean and standard deviation data.  Whether or not a column contains these data can be determined by the column name.  run_analysis.R reads the column name data set and tests each column name for the presence of the string "mean" and the string "std", recording the column number of the desired columns.  Since columns have been added to the left of the numerical columns for subject and activity code, column numbers are incremented by two to reflect their new position.  These columns and the two new columns are then extracted into a new dataset.

### Step 3: Uses descriptive activity names to name the activities in the data set.
### and 
### Step 4: Appropriately labels the data set with descriptive activity names.
-----------------------------------------------------------------------------------
These two requirements call for giving the activities and numerical columns meaningful descriptions.  These have been taken care of in Step 1 as part of the process of combining the training and test datasets.


### Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
-----------------------------------------------------------------------------------------------------------------------------
This requirements calls for mean values to be calculated on the interaction data between activity code and subject.  That is, for each subject, mean values should be calculated for each activity.  With 30 subjects and six activities, this results in 30*6=180 rows of mean data, one for each of the mean and standard deviation column preserved in step 2.

To accomplish this, run_analysis.R melts the dataset using the subject and activity columns as id variables.  Then it decasts the molten dataset on the id variables against the numerical variable, calculating the mean for each.  This produces the final database requested.  The final step of the script is to write the final dataset to a file.
