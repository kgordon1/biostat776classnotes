install.packages(c("here", "sessioninfo"))
install.packages("tidyverse")
install.packages("ggplot2")
library(tidyverse)
library(here)
library(sessioninfo)
#load chicago data set
chicago <- readRDS("chicago.rds")

#Create tibble from scratch with coercing a double to integer
tibble(
  a = 1:5,
  b = 6:10,
  c = 1,
  z = (a + b)^2 + c
)


df <- tibble(
  a = 1:5,
  b = 6:10,
  c = 1,
  z = (a + b)^2 + c
)

# Extract by name using $ or [[]]
df$b

#You can also omit variables using the select() function by using the negative sign.
select(chicago, -(city:dptp))

#if we wanted to keep every variable that starts with a “d”
subset <- select(chicago, starts_with("d"))
str(subset)

#The filter() function is used to extract subsets of rows from a data frame. 
#Suppose we wanted to extract the rows of the chicago data frame where the levels of PM2.5 are greater than 30 (which is a reasonably high level), we could do
chic.f <- filter(chicago, pm25tmean2 > 30)
str(chic.f)

#You can see that there are now only 194 rows in the data frame and the distribution of the pm25tmean2 values is.
summary(chic.f$pm25tmean2)

#Project 1 will onclude filtering through this method
#The arrange() function is used to reorder rows of a data frame according to one of the variables/columns.
#order the rows of the data frame by date, so that the first row is the earliest (oldest) observation and the last row is the latest (most recent) observation.
chicago <- arrange(chicago, date)

#check the first few rows
head(select(chicago, date, pm25tmean2), 3)


#Columns can be arranged in descending order too by useing the special desc() operator.
chicago <- arrange(chicago, desc(date))

#Renaming a variable in a data frame in R 
# First look at the names of the first five variables in the chicago data frame.
head(chicago[, 1:5], 3)

#these names are pretty obscure or awkward and probably be renamed to something more sensible
chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)
head(chicago[, 1:5], 3)

#Mutate Columns
#with air pollution data, we often want to detrend the data by subtracting the mean from the data.
#Here, we create a pm25detrend variable that subtracts the mean from the pm25 variable.
chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(chicago)

#group_by() function is used to generate summary statistics from the data frame within strata defined by a variable.
#First, we can create a year variable using as.POSIXlt().
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
#Now we can create a separate data frame that splits the original data frame by year.
years <- group_by(chicago, year)
#Finally, we compute summary statistics for each year in the data frame with the summarize() function.
summarize(years,
          pm25 = mean(pm25, na.rm = TRUE),
          o3 = max(o3tmean2, na.rm = TRUE),
          no2 = median(no2tmean2, na.rm = TRUE)
)

#The pipeline operator %>% is very handy for stringing together multiple dplyr functions in a sequence of operations
#The %>% operator allows you to string operations in a left-to-right fashion, i.e.
chicago %>%
  mutate(year = as.POSIXlt(date)$year + 1900) %>%
  group_by(year) %>%
  summarize(
    pm25 = mean(pm25, na.rm = TRUE),
    o3 = max(o3tmean2, na.rm = TRUE),
    no2 = median(no2tmean2, na.rm = TRUE)
  )

#The slice_sample() function of the dplyr package will allow you to see a sample of random rows in random order.
#This is useful when you're just looking at your data and want to understand it from a random subsample to look at different values you might encounter
slice_sample(chicago, n = 10)

