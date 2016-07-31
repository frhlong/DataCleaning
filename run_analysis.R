#Download file into the working directory
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile='data.zip')
#Extract file zip folder into current directory
unzip('data.zip')
# Get the name of all the files inside the extracted folder
fname = unzip('data.zip', list=TRUE)$Name

#Lable for activity
activity_name<-read.table(fname[1])
#Lable for feature
feature_name<-read.table(fname[2])
#Create a loop to import data to R environment

#train data
train <- read.table(fname[31])
activity_train <- read.table(fname[32])
subject_train <- read.table(fname[30])

#test data
test <- read.table(fname[17])
activity_test <- read.table(fname[18])
subject_test <- read.table(fname[16])


#Combine test and train set together
data<-rbind(train,test)
activity<-rbind(activity_train,activity_test)
subject<-rbind(subject_train,subject_test)
#Combine measure (column name) 
names(data)<-feature_name[,2]
#Extracts only the measurements on the mean and standard deviation for each measurement.
meanlist<-grep('mean',tolower(feature_name[,2]), value=FALSE)
stdlist<-grep('std',tolower(feature_name[,2]), value=FALSE)
data<-data[,c(meanlist,stdlist)]
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.

data<-cbind(activity,subject,data)
names(data)[2]<-'Subject'
data<-merge(data,activity_name,by='V1',all.x = T)
data<-data[,c(89,2:88)]
names(data)[1]<-'Activity'
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggregate()

#Export data as txt
library(plyr)
Meandata <-ddply(data, c('Activity', 'Subject'), function(x) colMeans(x[, 3:88]))
write.table(Meandata, "Mean_data.txt", row.name=FALSE)
