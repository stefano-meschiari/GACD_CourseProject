# Using the dplyr package to manipulate the data.
library(dplyr)
# Using read_table from the readr package, which is much faster.
library(readr)
# Using reshape2 to melt the dataset.
library(reshape2)

# Convenience function for reading a single vector of values such as
# features.txt, y_test.txt, etc.
read_array <- function(fn) {
  data <- read.delim(fn, sep=" ", header=FALSE, stringsAsFactors=FALSE)
  data[, ncol(data)]
}

data_dir <- "UCI HAR Dataset/"

# Creates a mapping from indices to column names
all_column_names <- make.unique(read_array(str_c(data_dir, 'features.txt')))

# Creates a mapping from indices to activities
activities <- read_array(str_c(data_dir, 'activity_labels.txt'))

# Read the test data, subject array, and activity array and bind them
# into a data.frame
test <- cbind(read_table(str_c(data_dir, 'test/X_test.txt'), col_names=all_column_names),
             subject=read_array(str_c(data_dir, 'test/subject_test.txt')),
             activity=read_array(str_c(data_dir, 'test/y_test.txt')))

# Read the training data, subject array, and activity array and bind them
# into a data.frame. 
train <- cbind(read_table(str_c(data_dir, 'train/X_train.txt'), col_names=all_column_names),
             subject=read_array(str_c(data_dir, 'train/subject_train.txt')),
             activity=read_array(str_c(data_dir, 'train/y_train.txt')))

# The train & test tables now contain the columns in features.txt,
# plus two columns listing activity and subject ids.

# Tidy data for step 4.
#
# 1. Computes the union between the two datasets (using a straight union
#    since they are disjointed).
# 2. Keep the subject & activity columns, and all the columns that contain
#    mean() or std() in its label; discard the rest (iqr, mad, etc.)
# 3. "Melt" the dataset (make it long) using subject and activity as the
#    id vars.
# 4. Change the activity column from being a list of activity IDs to
#    a list of character IDs (WALKING_UPSTAIRS, LAYING, etc.)
tdata <- union(test, train) %>%
  select(subject, activity, contains("mean()"), contains("std()")) %>%
  melt(id.vars=c('subject', 'activity')) %>%
  mutate(activity=activities[activity])

# I also further subdivide the columns into measure, summary_type, and direction.
# E.g., the variable "tBodyAccJerk-mean()-X" is split into measure="tBodyAccJerk",
# summary_type="mean", and direction="X". This makes it into a tidy dataset
# with one "value" column containing the numerical observations, and several
# columns containing the labeling for the observations.
tdata <- cbind(tdata,
              colsplit(tdata$variable, "-", c("measure", "summary_type", "direction"))) %>%
  select(subject, activity, measure, summary_type, direction, value)

# Tidy data for step 5.
#
# I group the dataset created above by subject, activity, measure, summary_type and
# direction, then summarize it by calculating the mean for each group.
ddata <- tdata %>%
  group_by(subject, activity, measure, summary_type, direction) %>%
  summarize(mean_value=mean(value))

write.table(ddata, file='tidy_data.txt', row.name=FALSE)
