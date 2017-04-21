## receive source files in working directory, if not exist 
dataset_location <- "UCI HAR Dataset"
get_dataset <- function(...){
    zip_name <- "Dataset.zip"
    download_dataset <- function(...){
        file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(file_url, zip_name)
    }
    ifelse(!dir.exists(file.path(getwd(), dataset_location))
           , ifelse(!file.exists(paste(getwd(),zip_name, sep="/"))
                    , download_dataset()
                    , unzip(paste(getwd(),zip_name,sep="/")), exdir=dataset_location)
           , F)
}


## define location of files in working directory
file_location <- function(...) { paste(".", dataset_location,...,sep="/") }

## Merge of test and training datasets and their label-sets
get_dataset()
data_test <- read.table(file_location("test/X_test.txt"))
data_train <- read.table(file_location("train/X_train.txt"))
label_test <- read.table(file_location("test/y_test.txt"))
label_train <- read.table(file_location("train/y_train.txt"))
label_set <- rbind(label_test, label_train)[,1] 

# Requirement 1: Merges the training and the test sets to create one data set.
data_set <- rbind(data_test, data_train) 

## remove datasets not be used furthermore 
rm(data_test, data_train, label_test, label_train)

# deliverable:
print(data_set[1:10,1:4])

## set col-labels with feature list
features <- read.table(file_location("features.txt"))[,2]
colnames(data_set) <- features

## select subset of merged data with features of mean and std values 
features_subset <- grepl('-(mean|std)\\(',features)

# Requirement 2:Extracts only the measurements on the mean and standard deviation for each measurement.
data_set <- subset(data_set, select=features_subset) 
rm(features_subset, features)

## insert col of label of activity into dataset 
activity_label <- unlist(
    read.table(file_location("activity_labels.txt")
               , colClasses = "character")
    [,2]) 
label_set <- activity_label[label_set]

rm(activity_label)

# deliverable:
print(data_set[1:10,1:4])


# Requirement 3: Uses descriptive activity names to name the activities in the data set
data_set <- cbind(Activity = label_set,data_set) 

rm(label_set)

# deliverable:
print(data_set[1:10,1:4])

# Requirement 4: Appropriately labels the data set with descriptive variable names. 
colnames(data_set) <- gsub("X", "axisX", colnames(data_set))
colnames(data_set) <- gsub("Y", "axisY", colnames(data_set))
colnames(data_set) <- gsub("Z", "axisZ", colnames(data_set))
colnames(data_set) <- gsub("tBody", "Time_Body", colnames(data_set))
colnames(data_set) <- gsub("^t", "Time_", colnames(data_set))
colnames(data_set) <- gsub("^f", "Frequency_", colnames(data_set))
colnames(data_set) <- gsub("BodyBody", "Body", colnames(data_set))
colnames(data_set) <- gsub("^angle", "Angle_", colnames(data_set))
colnames(data_set) <- gsub("angle$", "Angle", colnames(data_set))
colnames(data_set) <- gsub("mean", "Mean", colnames(data_set))
colnames(data_set) <- gsub("std", "Std", colnames(data_set))
colnames(data_set) <- gsub("\\(\\)", "", colnames(data_set))
colnames(data_set) <- gsub("-", "_", colnames(data_set))

# deliverable:
print(colnames(data_set))

# export for writing Code Book
lapply(colnames(data_set), write, "columns.txt", append=TRUE, ncolumns=1)


# Requirement 5: Independent tidy data set with the average of each variable for each activity and each subject.
subjects_test <- read.table(file_location("test/subject_test.txt"))
subjects_train <- read.table(file_location("train/subject_train.txt"))
subjects <- rbind(subjects_train,subjects_test)[,1]
second_data_set <- cbind(Subject = subjects,data_set)

rm(subjects_test, subjects_train, subjects)

require('dplyr')
avg_set <- second_data_set %>%
    group_by(Subject,Activity) %>%
    summarise_each(funs(mean))

rm(second_data_set)

# deliverable:
print(avg_set)

# write output file
#write.table(avg_set,row.name = FALSE,file = "deliverable5_output_avgset.txt")
write.csv(avg_set, file="deliverable5_output_avgset.csv")
