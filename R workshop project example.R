library(tidyverse)
library(openintro)
library(table1)
library(broom)

# Step 1 identify our dataset
data()

# Step 2 look at the data
glimpse(yrbss)

# Step 3 - develop research question
# What is the association between hours of sleep and texting while driving?
# exposure - school_night_hours_sleep
# outcome - text_while_driving_30d

# Step 4 - get to know your variables
yrbss %>% 
  group_by(school_night_hours_sleep) %>% 
  summarise(n = n())

yrbss %>% 
  group_by(text_while_driving_30d) %>% 
  summarise(n = n())

yrbss %>% 
  group_by(gender) %>% 
  summarise(n = n())

# Step 5 - recode variables as necessary
yrbss_clean <- yrbss %>% 
  mutate(slept_8hrs = case_when(
    school_night_hours_sleep %in% c("8", "9", "10+") ~ "8 or more hours of sleep",
    school_night_hours_sleep %in% c("7", "6" , "5", "<5") ~ "Less than 8 hours of sleep",
    TRUE ~ NA
  ),
  any_text_while_driving = case_when(
    text_while_driving_30d == "0" ~ "Did not text and drive",
    text_while_driving_30d %in% c("1-2", "10-19", "20-29", "3-5", "30", "6-9") ~ "Did text and drive",
    text_while_driving_30d == "did not drive" ~ "did not drive",
    TRUE ~ NA
  ))

# quality check 
yrbss_clean %>% 
  group_by(school_night_hours_sleep, slept_8hrs) %>% 
  summarise(n = n())

yrbss_clean %>% 
  group_by(text_while_driving_30d, any_text_while_driving) %>% 
  summarise(n = n())

# Step 6 - define analytic sample by excluding students who don't drive 
yrbss_clean <- yrbss_clean %>% 
  filter(!(any_text_while_driving == "did not drive"),
         !(is.na(any_text_while_driving)),
         !(is.na(slept_8hrs)),
         !(is.na(gender)))

yrbss_clean %>% 
  group_by(slept_8hrs, any_text_while_driving) %>% 
  summarise(n = n())

# Step 7 - create table 1 
# need to run this function which will help you create a column with a p-value for the chi-square 
# (categorical covariate) or t-test (continuous covariate)

### for p values 
### function
pvalue <- function(x, ...) {
  # Construct vectors of data y, and groups (strata) g
  y <- unlist(x)
  g <- factor(rep(1:length(x), times=sapply(x, length)))
  if (is.numeric(y)) {
    # For numeric variables, perform a standard 2-sample t-test
    p <- t.test(y ~ g)$p.value
  } else {
    # For categorical variables, perform a chi-squared test of independence
    p <- chisq.test(table(y, g))$p.value
  }
  # Format the p-value, using an HTML entity for the less-than sign.
  # The initial empty string places the output on the line below the variable label.
  c("", sub("<", "&lt;", format.pval(p, digits=3, eps=0.001)))
}
###

table1(~ gender | slept_8hrs, data = yrbss_clean, overall=F, extra.col=list(`P-value`=pvalue))

# Step 8 - raw (unadjusted) logistic regression model
yrbss_clean <- yrbss_clean %>% 
  mutate(text_binary = case_when(
    any_text_while_driving == "Did text and drive" ~ 1,
    any_text_while_driving == "Did not text and drive" ~ 0, 
    TRUE ~ NA
  ))

yrbss_clean %>% 
  group_by(any_text_while_driving, text_binary) %>% 
  summarise(n = n())

model_raw <- glm(text_binary ~ slept_8hrs, data = yrbss_clean, family = "binomial") 

tidy(model_raw) %>% 
  mutate(estimate_exp = exp(estimate))


# Step 9 - adjusted logistic regression model
model_adj <- glm(text_binary ~ slept_8hrs + gender, data = yrbss_clean, family = "binomial") 

tidy(model_adj) %>% 
  mutate(estimate_exp = exp(estimate))









  