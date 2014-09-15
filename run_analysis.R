###Getting and Cleaning Data: course project
##change my working directory to course project
setwd("C://IUB_STUDY/DataScienceSpecializatin/cleanData/project")
#read in features.txt to get the feature names
feature_names_table<-read.table("features.txt", sep=" ")
feature_names<-as.character(feature_names_table[,2])
#read in activity_labels to get the activity name
activity_label<-read.table("activity_labels.txt", sep=" ")

#read in test data
#########################
#go into folder test
setwd(".//test")

#read persons, activity_labels, features for test data
test_person<-read.table("subject_test.txt")
#compute num of instances in test 
test_n=dim(test_person)[1]
test_activity_num<-read.table("y_test.txt")
#create a column for activity_labels (descriptive names)
test_activity<-rep(NA,test_n)

test_features<-read.table("X_test.txt")

#go to folder Inertial Signals to read triaxial data
setwd(".//Inertial Signals")
test_total_acc_x<-read.table("total_acc_x_test.txt")
test_total_acc_y<-read.table("total_acc_y_test.txt")
test_total_acc_z<-read.table("total_acc_z_test.txt")

test_body_acc_x<-read.table("body_acc_x_test.txt")
test_body_acc_y<-read.table("body_acc_y_test.txt")
test_body_acc_z<-read.table("body_acc_z_test.txt")

test_body_gyro_x<-read.table("body_gyro_x_test.txt")
test_body_gyro_y<-read.table("body_gyro_y_test.txt")
test_body_gyro_z<-read.table("body_gyro_z_test.txt")
#column combine triaxial data into one dataset
test_triaxial<-cbind(test_total_acc_x, test_total_acc_y,test_total_acc_z,
                     test_body_acc_x,test_body_acc_y,test_body_acc_z,
                     test_body_gyro_x,test_body_gyro_y,test_body_gyro_z)

#create names for triaxial data
n<-1:128
names1<-paste("total_acc_x",n,sep="")
names2<-paste("total_acc_y",n,sep="")
names3<-paste("total_acc_z",n,sep="")
names4<-paste("body_acc_x",n,sep="")
names5<-paste("body_acc_y",n,sep="")
names6<-paste("body_acc_z",n,sep="")
names7<-paste("body_gyro_x",n,sep="")
names8<-paste("body_gyro_y",n,sep="")
names9<-paste("body_gyro_z",n,sep="")
triaxial_names<-c(names1,names2,names3,names4,names5,names6,names7,
                  names8,names9)

#combine test dataset
type<-rep("test",test_n) #show the source of each observation is test data or train data
testDT<-cbind(type, test_person,test_activity_num,test_activity,test_features,
              test_triaxial)
testNames<-c("type", "person","activity_num","activity",feature_names,triaxial_names)
names(testDT)<-testNames


#####################################################################################
#read in train data
#go to the folder train
setwd("C://IUB_STUDY/DataScienceSpecializatin/cleanData/project/train")

#The whole process to read train data is quite similar to reading test data
#read persons, activity_labels, features for test data
train_person<-read.table("subject_train.txt")
#compute num of instances in test 
train_n=dim(train_person)[1]
train_activity_num<-read.table("y_train.txt")
#create a column for activity_labels (descriptive names)
train_activity<-rep(NA,train_n)

train_features<-read.table("X_train.txt")

#go to folder Inertial Signals to read triaxial data
setwd(".//Inertial Signals")
train_total_acc_x<-read.table("total_acc_x_train.txt")
train_total_acc_y<-read.table("total_acc_y_train.txt")
train_total_acc_z<-read.table("total_acc_z_train.txt")

train_body_acc_x<-read.table("body_acc_x_train.txt")
train_body_acc_y<-read.table("body_acc_y_train.txt")
train_body_acc_z<-read.table("body_acc_z_train.txt")

train_body_gyro_x<-read.table("body_gyro_x_train.txt")
train_body_gyro_y<-read.table("body_gyro_y_train.txt")
train_body_gyro_z<-read.table("body_gyro_z_train.txt")
#column combine triaxial data into one dataset
train_triaxial<-cbind(train_total_acc_x, train_total_acc_y,train_total_acc_z,
                     train_body_acc_x,train_body_acc_y,train_body_acc_z,
                     train_body_gyro_x,train_body_gyro_y,train_body_gyro_z)

#names for train data are the same as the test data
#combine test dataset
type<-rep("train",train_n) #show the source of each observation is test data or train data
trainDT<-cbind(type, train_person,train_activity_num,train_activity,train_features,
              train_triaxial)
names(trainDT)<-testNames

##############################################################
#combine train and test data
totDT<-rbind(testDT,trainDT)

#use descriptive names to name activity
activity_label[,2]<-as.character(activity_label[,2])
for (i in 1:dim(activity_label)[1]){
    totDT[totDT$activity_num==activity_label[i,1],4]=activity_label[i,2]
}

#Extracts only the measurements on the mean and standard deviation for each measurement.
#find all feature names containing "mean"
mean<-grepl("mean",feature_names)
#find all feature names containing "std"
std<-grepl("std",feature_names)

#combine, and get logical list of feature names containing either "mean" or "std"
mean_std<-as.logical(mean+std)

#get the index list of feature names containing either "mean" or "std". 
#since in totDT there are four columns before features, I add 4 to each element of this index list.
index<-feature_names_table[mean_std,1]+4

#get the dataset only containing the measurements on the mean and standard deviation for each
#measurements
mean_std_DT<-totDT[,c(1:4,index)]

#create the final dataset for submission
x<-aggregate(mean_std_DT, by=list(mean_std_DT$person, mean_std_DT$activity),FUN="mean")
x$activity<-x$Group.2
finalDT<-x[,4:85]
write.table(finalDT, file="FinalProjectDataset.txt", row.names=F)

