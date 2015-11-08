---
title: "Reproducible Research: Peer Assessment 1"
author: "Garoe Gonzalez"
output: 
  html_document:
    keep_md: true
---
## Introduction
The goal of this project is to make an analysis report using Markdown.

## Loading and preprocessing the data

We load the activity data and we have a preliminary look to the data frame. We transform the data frame into a tbl_df for easy visualization and the dplyr library to use the easy transformation functions.
```{r}
suppressMessages(suppressWarnings(library(dplyr)))
activity<-tbl_df(read.csv("activity.csv", stringsAsFactors = FALSE))
activity$date<-as.Date(activity$date)
str(activity)
activity
```

## What is mean total number of steps taken per day?

We group the data set per day and we compute the number of steps done each day.
``` {r}
activityPerDay <- activity %>%
     group_by(date) %>%
     summarize(stepsperday = sum(steps))
```
We plot the histogram of the results, showing the distributions of steps done per day.
```{r}
library(ggplot2)
ggplot (data = activityPerDay, aes(x=stepsperday)) + geom_histogram(binwidth = 1000)
```

We compute the mean and median of the number of steps done each day using the summarized data set.

```{r}
with(activityPerDay , mean  (stepsperday, na.rm = TRUE))
with(activityPerDay , median(stepsperday, na.rm = TRUE))
```

## What is the average daily activity pattern?

We group the data per interval time and obtain the mean of steps over all days. 
Then we plot the time series with the interval in the x-axis and the mean steps per day in the y-axis. 

```{r}
TimeSeries <- activity %>%
     group_by(interval) %>%
     summarize (steps = mean(steps, na.rm = TRUE))
ggplot (data = TimeSeries,aes(x=interval, y=steps)) + geom_line()
```

We observed a structure in the time series. Probably intervals between 0 and 500 where the number of steps are close to 0 corresponds to resting periods of the subjects. Maximum number of steps 206, is reached at interval 835. 

```{r}
TimeSeries [which.max(TimeSeries$steps), ]
```

## Imputing missing values

We calculte the number of missing values for the steps column.
```{r}
sum(is.na (activity$steps))
```

## Are there differences in activity patterns between weekdays and weekends?
