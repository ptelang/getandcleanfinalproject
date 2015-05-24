# Getting and Cleaning Data - Course Project

## Details
The script does the following:

1. Merges the subjects, features and labels for both the training and test sets.
2. Filters out features to have only the measurements on the mean and standard deviation for each measurement.
3. Replaces activity identifiers with descriptive activity names.
4. Updates column names to provide representative names.
5. Computes the average of each variable for each activity and each subject.
6. Writes the tidy data set without row names tidy.out file.

The script assumes that the data is in UCI HAR Dataset subdirectory. 

