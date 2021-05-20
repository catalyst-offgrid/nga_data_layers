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
data <- fread('./data/raw/sect4b_plantingw4.csv')
#layer_data <- na.omit(data, cols = 's4bq8')

have_phones <- data[s4bq8 == 1, .N, by=lga]

setkey(have_phones, lga)
setkey(lga_labels, value)
phone_and_labels <- lga_labels[have_phones, have_phones := i.N]  #lga_labels[have_phones]
setnafill(phone_and_labels, fill=0, cols='have_phones')

internet <- data[s4bq14 == 1, .N, by=lga]
setkey(internet, lga)
setkey(phone_and_labels, value)
phone_and_labels[internet, have_internet := i.N]
setnafill(phone_and_labels, fill=0, cols='have_internet')

write.csv(phone_and_labels, './data/interim/nga_phone_internet.csv')

#################################
# Develop Data Extraction Loop  #
#################################
nga_dta_list <- list.files(path = "./data/raw/", pattern = '*.csv')
mobile_bank <- fread(nga_dta_list[89])

