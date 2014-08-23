##############
##############
##############

#Read in the necessary Samsung data


#Set the working directory to a folder containing only the following 8 Samsung datasets:
# 1.activity_labels
# 2.features
# 3.subject_train
# 4.subject_test
# 5.X_train
# 6.y_train
# 7.X_test
# 8.y_test
##############
##############
##############


setwd("your_directory_with_the_data")

input_dats <- dir()
 
for(i in 1:length(input_dats)){
  assign(input_dats[i],read.table(dir()[i], sep=""))
} 






##############
##############
##############
#Step 1
##############
##############
##############

#meaningful label for y_train/test.txt
names(y_train.txt) <- "activity_type"
names(y_test.txt) <- "activity_type"


#get training and test datasets ready to merge
#add data_ind variable to keep track of what dataset a record comes from
train <- data.frame(X_train.txt, y_train.txt,subject_train.txt[,1], data_ind="train")
test <- data.frame(X_test.txt, y_test.txt, subject_test.txt[,1], data_ind="test")
names(train)[563] <- "subject"
names(test)[563] <- "subject"

#dataset requested
train_test_data <- rbind(train, test)





##############
##############
##############
#Step 2
##############
##############
##############


#find features with "mean" or "std" in part of the name
#these variable are defined to be mean and std variables for a given measurement
mean_related_var_names <- features.txt[,2][grep("mean",tolower(features.txt[,2]))]
mean_related_var_indices <- grep("mean",tolower(features.txt[,2]))
std_related_var_names <- features.txt[,2][grep("std",tolower(features.txt[,2]))]
std_related_var_indices <- grep("std",tolower(features.txt[,2]))


#dataset requested
mean_std_data <- train_test_data[,sort(c(mean_related_var_indices,std_related_var_indices, 562,563, 564))]






##############
##############
##############
#Step 3
##############
##############
##############

#convert mean_std_data$activity_type to a factor then activity_labels.txt$V2 to be the levels of the factor
mean_std_data$activity_type <- as.factor(mean_std_data$activity_type) 
levels(mean_std_data$activity_type) <-  as.character(activity_labels.txt$V2)                                        






##############
##############
##############
#Step 4
##############
##############
##############

#take mean_related_var_names from step 2 (variable names for mean of a measurement)
#take std_related_var_names from step 3 (variable names for mean of a measurement)
#along with "activity_type", "subject", and "data_ind" to be the names of the variables in mean_std_data
var_names <- c(as.character(mean_related_var_names),as.character(std_related_var_names), "activity_type", "subject", "data_ind" )
names(mean_std_data) <- var_names






##############
##############
##############
#Step 5
##############
##############
##############

#define list consisting of activity_type and subject vectors 
facs <- list(activity_type=as.factor(mean_std_data$activity_type), 
              subject=as.factor(mean_std_data$subject)
)
 

#compute mean of the 86 measurements for each activity_type and subject
tidy_data <- aggregate(mean_std_data[,1:86],facs, function(x){mean(x,na.rm=T)})



##############
##############
##############
#output the dataset
##############
##############
##############
#write.table(tidy_data, "tidy_data.txt",row.names=F)
