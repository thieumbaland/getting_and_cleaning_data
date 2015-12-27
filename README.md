# Assignment Getting and Cleaning Data
## By Mathieu Wauters

####Introduction

One of the most exciting areas in all of data science right now is wearable computing - see for example  this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

This project includes the following files:


- [README.md](https://github.com/thieumbaland/getting_and_cleaning_data/blob/master/README.md): what you're currently reading
- [README.html](https://github.com/thieumbaland/getting_and_cleaning_data/blob/master/README.html): HTML version of what you're currently reading
- [run_analysis.r](https://github.com/thieumbaland/getting_and_cleaning_data/blob/master/run_analysis.r): R script to run the analysis
- [codebook](https://github.com/thieumbaland/getting_and_cleaning_data/blob/master/codebook.Rmd): Codebook
- [tidy.txt](https://github.com/thieumbaland/getting_and_cleaning_data/blob/master/tidy.txt): the output file containing tidy data

####Requirements
You should create one R script called run_analysis.R that does the following:


1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

####run_analysis.r
I have a programming background in C++, which explains why I worked in functions.These are the functions that are present in my version of run_analysis.r:
```
main()
read_input_data()
select_columns(mydf)
label_columns(mydf)
produce_mean(mydf)
```
The function `produce_mean` calls a function that produces the mean for an individual column. This function is entitled `calculate_mean_for_column`. Everything is called from `main()`, including the packages that were used, namely ```readr```, ```dplyr``` and ```plyr```.
```
if(!require(readr))install.packages("readr")
if(!require(dplyr))install.packages("dplyr")
if(!require(plyr))install.packages("plyr")
```

```readr``` is very efficient in reading the text files for the function ```read_input_data()```.

The interested reader will see that each function corresponds with 1 or multiple steps of the requirements. The mapping is as follows:

- ```read_input_data``` - Step 1
  *  Reads the necessary input files
  *  Merges X and Y values and subject IDs
  *  Merges training and test sets
- ```select_columns``` - Step 2
  *  Selects columns that contain the Mean or Standard Deviation
- ```label_columns``` - Step 3 and 4
  *  Includes the activity descriptions instead of the IDs.
  *  Constructs descriptive activity names
- ```produce_mean``` - Step 5
  *  Calculates the mean across all columns for every subject and every activity.
  *  As a result, the final output contains 30 (subjects) by 6 (activities) = 180 rows.

Since [run_analysis.r](https://github.com/thieumbaland/getting_and_cleaning_data/blob/master/run_analysis.r) contains some info and the [codebook](https://github.com/thieumbaland/getting_and_cleaning_data/blob/master/codebook.Rmd) is available as well, I will not comment any further in this document but encourage you to take a look at the script and codebook.

