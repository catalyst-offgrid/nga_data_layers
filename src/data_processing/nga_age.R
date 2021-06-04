#packages
library(tidyverse)
library(data.table)

#Set nga_data_layers git repo as working directory

#########################
# Exploratory Process   #
#########################
# Start with phone and mobile data to explore NGA General Household Survey dataset
# develop data cleaning process
lga_labels <- fread('./data/interim/nga_lga_labels.csv') #get LGA labels

#Load data
data <- fread('./data/raw/sect1_plantingw4.csv')
#layer_data <- na.omit(data, cols = 's4bq8')

minor <- data[s1q6 <= 18, .N, by=lga]

setkey(minor, lga)
setkey(lga_labels, value)
minor_and_labels <- lga_labels[minor, under_18 := i.N]  #lga_labels[have_phones]
setnafill(minor_and_labels, fill=0, cols='under_18')

adult <- data[s1q6 >= 18 & s1q6 <=64, .N, by=lga]

setkey(adult, lga)
setkey(lga_labels, value)
adult_and_labels <- lga_labels[adult, between_18_64 := i.N]  #lga_labels[have_phones]
setnafill(adult_and_labels, fill=0, cols='between_18_64')

elderly <- data[s1q6 >=65, .N, by=lga]

setkey(elderly, lga)
setkey(lga_labels, value)
elderly_and_labels <- lga_labels[elderly, age_65_and_above := i.N]  #lga_labels[have_phones]
setnafill(elderly_and_labels, fill=0, cols='age_65_and_above')

write.csv(elderly_and_labels, './data/interim/nga_age_demographics.csv')

#################################
# Develop Data Extraction Loop  #
#################################
nga_dta_list <- list.files(path = "./data/raw/", pattern = '*.csv')
mobile_bank <- fread(nga_dta_list[89])

