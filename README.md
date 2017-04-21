#  Coursera Programming Assignment

## Getting and Cleaning Human Activity Recognition Using Smartphones Data Set

## Introduction:
Requirements: Getting and Cleaning Data for further Analysis. 

Data Set is provided from:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 

Code Book and Data Management Description is found on:
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones )

## Data Wrangling code in run_analysis.R:
### Load Data Set
Please note: All operations are done in Working Directory. Load of two datasets which have to be merged.

### Subset of features, only observations of Mean and Std-Values
By using Regular Expressions, columns of interest had been selected. 

### Labels of the Features
For readability issues, label of columns had been renamed. 

### Descriptive Information on Activities
Supply a column with attributes on activities as a factorized variable. 

### Finalization of data set
After merging information about observational subjects, clean data set is analyzed by co-founding variables subjects and activities. Results are exported into csv-file. 
