# Procedures performed in run_analysis.R

## A few steps before read-in test and train data
* Change the working directory in R to the course project folder, which has data in there
* read in features.txt to get feature_names as a vector
* read in activity_labels.txt to get the table representing activity num:name pair
 
## Read test data
* go into the folder with test data
* read in subject_test.txt to get the person vector in test data
* read in y_test.txt to get the activity_num vector(1~6) in test data
* create a NA list test_activity to store the descriptive names of activities later in combined dataset
* 
* read in features.txt to get all features data in one matrix for test dataset
* 
* go to folder Inertial Signals to read triaxial data for test dataset, and combine triaxial data into one matrix
* create name list for triaxial data
* 
* create variable "type" to store the instance source(test or train)
* column combine person vector, activity_num vector, activity NA vector, features data matrix, triaxial data matrix to get the final data set for test data
* create the name vector for test data
* attach name vector to the test data set
 
## Similar procedurs are performed with train data

## Merge test data and train data
* row bind test data and train data to get full dataset
* put the corresponding descriptive names of activities in variable "activity" according to their values in "activity_num"

## Extracts only the measurements on the mean and standard deviation for each measurement.
* use function grepl to find feature names containing either "mean" or "std"
* find the indexes of the feature names containing either "mean" or "std"
* subset full dataset to get mean_std_DT dataset

## From mean_std_DT dataset, creates an independent tidy data set with the average of each variable for each activity and each subject.
* use function aggregate to generate the dataset with average of each variable for each activity and each subject.
* format and subset the dataset to get finalDT, the final dataset
* write final dataset finalDT to a .txt file for submission



