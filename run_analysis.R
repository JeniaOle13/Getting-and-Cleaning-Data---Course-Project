setwd("/home/acari/Рабочий стол/ekhfbesbv/")

# 1 Merges the training and the test sets to create one data set.
################################################################################################
# 1.1 Read train data
subject_train <- read.table("train/subject_train.txt", col.names = 'subject')
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt", col.names = 'activity')

# 1.2 Read test data
subject_test <- read.table("test/subject_test.txt", col.names = 'subject')
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt", col.names = 'activity')

# 1.3 Combined data  
x_data <- rbind(x_test, x_train)
y_data <- rbind(y_test, y_train)
subject_data <- rbind(subject_test, subject_train)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
##############################################################################################

# 2.1 Read labels x_data columns
features <- read.table('features.txt')

# 2.2 Extracting numbers labels contain "mean" and "std"
mead_std <- grep("-(mean|std)\\(\\)", features[,2])

# 2.3 Extracting numbers x_data columns  
x_data <- x_data[, mead_std]

# 2.4 Adding names columns x_data
names(x_data) <- features[mead_std, 2]

# 3 Uses descriptive activity names to name the activities in the data set
##############################################################################################

activity_labels <- read.table("activity_labels.txt", colClasses = 'character')
y_data$activity <- as.factor(y_data$activity)
levels(y_data$activity) <-levels(factor(activity_labels$V2, levels = c(activity_labels$V2)))

# 4 Appropriately labels the data set with descriptive variable names.
##############################################################################################

all_data <- cbind(y_data, subject_data, x_data)

# 5 From the data set in step 4, creates a second, independent tidy 
#   data set with the average of each variable for each activity and each subject.
##############################################################################################

tidy_data <- 
    aggregate(all_data[,-(1:2)], 
                            by = list(activity = all_data$activity, 
                                      subject = all_data$subject), mean)

write.table(tidy_data, 'tidy_data', row.names = F)
