# Here is a file to show some of the common mistakes early on when coding with R

# unmatched parantheses 
res <- sum(1, 2)
res
                 
# misspelled object
mean(mcar$wt)
# Error: object 'mcar' not found
data(mtcars)
mean(mtcars$wt)

# wrong function
men(mtcars$wt)  

# could not find function because relevant libraries not called
library(dplyr)
mtcars <- mtcars %>% 
  filter(mpg > 18)

# wrong data type
mean(letters[1:5])
mean(c(1:5)) #to use numbers instead

# another datatype error 
as.numeric(c("1","two"))



#######
# lacking information 
mean()

# wrong paranthesis/bracket
mean[1:10]


# note the difference 
x = 5 
x 

x == 5
x == 6
x == 0 

y == 5


# a ggplot example 
library(ggplot2)

ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(shape = factor(cyl))

ggplot(mtcars, aes(wt, mpg, color = factor(cyl)
                   shape = factor(cyl))) +
  geom_point()

# actual correct way of writing
ggplot(mtcars, aes(wt, mpg, color = factor(cyl), 
                   shape = factor(cyl))) +
  geom_point()

# a fun but wrong example
ggplot(mtcars, aes(wt, mpg, color = factor(cyl), shape = factor(cyl))) 
  + geom_point()

# similarly you will see `|>` or ` %>% ` the placement is important



# naming error 
2 <- seq(100, 200, 25)
list1 <- seq(100, 200, 25)

# variable names usually don't start with numbers
# often times if they do, use `` to call the variable



######
# NAs
vec1 <- c(1,2,NA,4)
sum(vec1)
# options within function 
sum(vec1, na.RM = TRUE)
sum(vec1, na.rm = true) #pay attention to the color
sum(vec1, na.rm = t)
sum(vec1, na.rm = T)
sum(vec1, na.rm = TRUE)

# Case when exclusing missing can be wrong
# Create a data frame with manually inputted data
# Always keep in mind how you want to filter data
data_manual <- data.frame(
  Column1 = c(10, 20, NA, 40, 50, 35),
  Column2 = c(NA, 25, 35, 45, 55, 55),
  Column3 = c(15, NA, 35, 45, 55, 77),
  Column4 = c(20, 30, 40, NA, 60, NA),
  Column5 = c(5, 15, 25, 35, NA, 89)
)

# Print the manually created data frame
print(data_manual)

# Remove rows with NA values using na.omit()
data_cleaned <- na.omit(data_manual)

# Print the cleaned data
print(data_cleaned)


# Out of bounds 
m <- matrix(1:6, nrow=2)
m[4, 3]



chisq.test(mtcars$cyl, mtcars$am)


# Computer related 
# Error: vector memory exhausted (limit reached?)



# Trouble-shooting
# General steps to debug R code:
  
# Read the message carefully.
# Check for typos and missing punctuation.
# Check your global environment for created objects (or use ls()).
# Check object attributes (Use str(), dim(),typeof(), class(), etc.)
# Step through the code line by line (See below example).

library(nycflights13)
library(dplyr)

data(flights)

flights %>%
  filter(dest == "IAH") %>%
  group_by(year, month, day) %>% 
  summarize(
    arr_delay = mean(arr_dely, na.rm = TRUE)
  )

ls(flights)

flights %>% 
  filter(dest == "IAH") %>% 
  group_by(year, month, day) %>%  
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# when in doubt, break it down to 
flights_iah <- flights %>% 
  filter(dest == "IAH")

flights %>% 
  filter(dest == "IAH") %>%  
  group_by(year, month, day)

flights_iah2 <- flights_iah %>% 
  group_by(year, month, day) %>% 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )



flights %>% 
  filter(dest == "IAH") %>%  
  group_by(year, month, day) %>% 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# another example
flights %>% 
  filter(dest == "JFK") %>%  
  group_by(year, month, day) %>% 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

table(flights$dest)

# when in doubt, break it down to step by step
flights %>% 
  filter(dest == "JFK")



# Tips for keeping your code organized and avoiding errors
# Read the documentation!
#   
# Know what the functions you use actually do.
# Read package vignettes.
# Practice!
#   
# The more you engage with R programming the more proficient you will become. With time, handling error messages will become second nature.
# Keep your code neat and clean. You can do this by following a style guide, for example, the tidyverse style guide.
# 
# If you use RStudio, you can use ctrl + shift + A to reformat code.
# See this resource on Coding Etiquette for styling tips.
# Include organized code blocks with coding sections (# Name of Section ----).
# Implement good data management practices.
#   
# Keep in mind the difference between .R & .Rmd
# Keep track of created R objects (See the global environment; use ls()).
# Use glimpse(), str(), dim(), and related functions (class()).