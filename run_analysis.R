library(plyr)
# load data
activity_labels<-read.table("activity_labels.txt")
features<-read.table("features.txt")
subject_test<-read.table("./test/subject_test.txt")
X_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
subject_train<-read.table("./train/subject_train.txt")
X_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")

# merge train and test set
X<-rbind(X_train,X_test)
subject<-rbind(subject_train,subject_test)
y<-rbind(y_train,y_test) # activities id 

# set column names
names(y)<-c("idActivity")
names(subject)<-c("idSubject")
colnames<-gsub("[^[:alnum:] ]", "", features$V2)
names(X)<-colnames
names(activity_labels)<-c("idActivity","activity")

# select columns name with means and std
#extractIndexCols_mean <- grep("-mean\\(\\)", features$V2) # return an integer vector
extractIndexCols <- grep("-mean\\(\\)|-std\\(\\)", features$V2)
colsName_meanstd<-features$V2[extractIndexCols] # get name of columns with means and std

# remove no-alphanumeric characters from colsName_meanstd

colsName_meanstd<-gsub("[^[:alnum:] ]", "", colsName_meanstd)

# extract columns from data set using colsName_meanstd

XSel<-X[,colsName_meanstd]

#merge activity
#activity<-merge(y,activity_labels,by.x="idActivity",by.y="id",all=TRUE,sort=FALSE)
activity<-join(y,activity_labels,by="idActivity")

#join data frames
dataset<-cbind(subject,activity=activity$activity,XSel)

# means
dsMean<-aggregate(.~activity+idSubject,dataset,FUN=mean)
dsMean<-dsMean[c(2,1,3:ncol(dsMean))]

write.table(dsMean, "dsMean.txt")
















