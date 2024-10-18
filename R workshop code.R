library(openintro)
library(tidyverse)
library(haven)
library(table1)

# Run this to view all freely available, loaded data 
data()

yrbss_data <- yrbss

nhanes <- read_csv("nhanes.samp.csv")

nhanes_demo <- read_xpt("DEMO_L.XPT")

nhanes_alc <- read_xpt("ALQ_L.XPT")

nhanes_all <- nhanes_demo %>% 
  full_join(nhanes_alc, by = "SEQN")

data_A <- tibble(
  ID = c(1234, 1235, 1236),
  color = c("Red", "Red", "Yellow")
)

data_B <- tibble(
  ID = c(1234, 1237, 1239),
  shape = c("Square", "Circle", "Triangle")
)

# Left join - keep all observations in the left (starting) dataset
data_left <- data_A %>% 
  left_join(data_B, by = "ID")

# Right join - keep all observations in the right (second) dataset
data_right <- data_A %>% 
  right_join(data_B, by = "ID")

# Inner join - keep all observations that match by ID (key) between the two datasets
data_inner <- data_A %>% 
  inner_join(data_B, by = "ID")

# Anti join - keep all observations that are in data_A but not in data_B
data_anti <- data_A %>% 
  anti_join(data_B, by = "ID")

# Full join - keep all observations regardless of matching ID
data_full <- data_A %>% 
  full_join(data_B, by = "ID")



# using midwest data as an example 
glimpse(midwest)

# here we are making variable selections 
midwest_data <- midwest %>% 
  select(state, popdensity, percwhite, percollege, percbelowpoverty, inmetro) %>% 
  filter(state %in% c("MI", "OH")) %>% 
  # Remove any rows with missing data for percbelowpoverty
  filter(!(is.na(percbelowpoverty))) %>% 
  mutate(inmetro_cat = case_when(
    inmetro == 0 ~ "Rural",
    inmetro == 1 ~ "Urban",
    TRUE ~ NA
  ))

head(midwest_data)

midwest_data %>% 
  group_by(inmetro, inmetro_cat) %>% 
  summarise(n = n())

midwest_data %>% 
  arrange(desc(percollege))


# creating table 1
# assuming our Y outcome variable is `inmetro` that we created earlier

# check out this website: https://cran.r-project.org/web/packages/table1/vignettes/table1-examples.html

table1(~ state | inmetro_cat, data = midwest_data)

table1(~ state + popdensity + percwhite + percollege + percbelowpoverty|inmetro_cat, data = midwest_data)

label(midwest_data$state) <- "State"
label(midwest_data$popdensity) <- "Population density"


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

#table with p value
table1(~ state | inmetro_cat, data = midwest_data, overall=F, extra.col=list(`P-value`=pvalue))


table1(~ state + popdensity + percwhite + percollege + percbelowpoverty|inmetro_cat, 
       overall = F, data = midwest_data, extra.col=list(`P-value`=pvalue))


#### another example using yrbss
yrbss_data <- yrbss

glimpse(yrbss)

table(yrbss$grade)
table(yrbss$gender)

yrbss_data %>% 
  group_by(gender, grade) %>% 
  summarize(N = n())

# to deal with missing issue 
yrbss_data_nonmissing <- yrbss_data %>% 
  filter(!(is.na(gender)) & !(is.na(grade)) & grade != 'other')

# alternative non-dplyr function
#yrbss_data$gender <- na.omit(yrbss_data$gender)
#yrbss_data$grade <- na.omit(yrbss_data$grade)

# to run table1 example
table1(~ grade | gender, data = yrbss_data_nonmissing)

# convert grade to a factor and reorder
yrbss_data_nonmissing <- yrbss_data_nonmissing %>%
  mutate(grade_factor = factor(grade, 
                               levels = c("10", "9", "11", "12")))

# create table 1 with grade_factor instead
table1(~ grade_factor | gender, data = yrbss_data_nonmissing)



