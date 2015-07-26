Raw data
========

Description
-----------

The raw data is available in the `UCI HAR Dataset/` folder. The dataset
was originally downloaded from the [UCI Machine Learning
Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The dataset consists of a series of measurements carried out on a group
of 30 volunteers with a smartphone equipped with an accelerometer and
gyroscope. Each measurement is categorized by the type of activity
performed by the volunteer (e.g. STANDING, LAYING, etc.) and the type of
measurement (e.g. body acceleration, jerk, etc.).

The dataset is divided between a training group (70% of volunteers) and
a testing group (30% of volunteers), respectively in the test/ and
train/ folders. The types of measurements listed in the two datasets are
described in features\_info.txt and features.txt; the types of
activities is listed in activities.txt.

Structure
---------

The training and testing datasets are split into three files:

-   `X.txt`: contains the actual numerical measurements. Each column in
    the file corresponds to a column in `features.txt`. Each measurement
    is normalized to be in the [-1,1] domain, and is therefore unitless.
-   `y.txt`: contains a list of the corresponding activities, as
    numerical IDs.
-   `subject.txt`: contains a list of the subject IDs.

Processed data
==============

Procedure
---------

The processing procedure is contained in the `run_analysis.R` R script.
The script uses the `dplyr` and `reshape2` packages to munge and clean
the raw data.

The procedure is as follows:

-   The three files in the raw data were merged (assigning column
    `subject` to the subject IDs and `activity` to the activity IDs).
-   The test and training datasets were merged. Only the columns
    containing either the mean or the standard deviation of the
    measurement were retained (those columns contain `mean()` or `std()`
    in their label in the raw data).
-   The dataset is converted into a long format, such that the subject
    IDs, activity IDs, type of measurement (e.g. bodyAccJerk), type of
    summary (mean or std), and direction (X/Y/Z) were all ID variables
    and the numerical measurements themselves are the only value column.
    The resulting dataset is formatted as follows (showing first 5
    rows):

<table>
<thead>
<tr class="header">
<th align="right">subject</th>
<th align="left">activity</th>
<th align="left">measure</th>
<th align="left">summary_type</th>
<th align="left">direction</th>
<th align="right">value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">30</td>
<td align="left">WALKING_UPSTAIRS</td>
<td align="left">tBodyAcc</td>
<td align="left">mean()</td>
<td align="left">X</td>
<td align="right">0.3515035</td>
</tr>
<tr class="even">
<td align="right">30</td>
<td align="left">WALKING_UPSTAIRS</td>
<td align="left">tBodyAcc</td>
<td align="left">mean()</td>
<td align="left">X</td>
<td align="right">0.2996653</td>
</tr>
<tr class="odd">
<td align="right">30</td>
<td align="left">WALKING_UPSTAIRS</td>
<td align="left">tBodyAcc</td>
<td align="left">mean()</td>
<td align="left">X</td>
<td align="right">0.2078607</td>
</tr>
<tr class="even">
<td align="right">30</td>
<td align="left">WALKING_UPSTAIRS</td>
<td align="left">tBodyAcc</td>
<td align="left">mean()</td>
<td align="left">X</td>
<td align="right">0.2942302</td>
</tr>
<tr class="odd">
<td align="right">30</td>
<td align="left">WALKING_UPSTAIRS</td>
<td align="left">tBodyAcc</td>
<td align="left">mean()</td>
<td align="left">X</td>
<td align="right">0.2761366</td>
</tr>
</tbody>
</table>

-   Finally, we group the dataset by the ID variables and summarize the
    observations by taking the mean. The resulting dataset is formatted
    as follows (showing first 5 rows):

<table>
<thead>
<tr class="header">
<th align="right">subject</th>
<th align="left">activity</th>
<th align="left">measure</th>
<th align="left">summary_type</th>
<th align="left">direction</th>
<th align="right">mean_value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">1</td>
<td align="left">LAYING</td>
<td align="left">fBodyAcc</td>
<td align="left">mean()</td>
<td align="left">X</td>
<td align="right">-0.9390991</td>
</tr>
<tr class="even">
<td align="right">1</td>
<td align="left">LAYING</td>
<td align="left">fBodyAcc</td>
<td align="left">mean()</td>
<td align="left">Y</td>
<td align="right">-0.8670652</td>
</tr>
<tr class="odd">
<td align="right">1</td>
<td align="left">LAYING</td>
<td align="left">fBodyAcc</td>
<td align="left">mean()</td>
<td align="left">Z</td>
<td align="right">-0.8826669</td>
</tr>
<tr class="even">
<td align="right">1</td>
<td align="left">LAYING</td>
<td align="left">fBodyAcc</td>
<td align="left">std()</td>
<td align="left">X</td>
<td align="right">-0.9244374</td>
</tr>
<tr class="odd">
<td align="right">1</td>
<td align="left">LAYING</td>
<td align="left">fBodyAcc</td>
<td align="left">std()</td>
<td align="left">Y</td>
<td align="right">-0.8336256</td>
</tr>
</tbody>
</table>

Variables
---------

The final dataset is saved in `tidy_data.txt`. Each row contains an
observation. The columns are as follows:

-   `subject`: the subject ID.
-   `activity`: the type of activity (LAYING, SITTING, etc.).
-   `measure`: the measure name, as listed in the raw dataset (e.g.
    tBodyAcc).
-   `summary_type`: the type of summary in the raw dataset ("mean()" or
    "std()").
-   `direction`: the axis along which the measurement is taken (X/Y/Z or
    "" if not applicable)
-   `mean_value`: the mean value taken over all the values in the raw
    dataset for given subject, activity, and measure.
