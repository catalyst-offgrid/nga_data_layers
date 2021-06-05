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
data <- fread('./data/raw/sect11_plantingw4.csv')
#layer_data <- na.omit(data, cols = 's4bq8')

toilet_types <- list('Piped Sewer System', 'Septic Tank', 'Pit Latrine', 'Open Drain', 'Flushed Elsewhere',
                     'Ventilated Improved Pit Latrine (VIP)', 'Pit Latrine with Slab',
                     'Open Pit Latrine', 'Composting Toilet')

waste <- data[s11q36 == 1, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, piped_sewer_system := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='piped_sewer_system')

waste <- data[s11q36 == 2, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, septic_tank := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='septic_tank')

waste <- data[s11q36 == 3, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, pit_latrine := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='pit_latrine')

waste <- data[s11q36 == 4, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, open_drain := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='open_drain')

waste <- data[s11q36 == 5, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, flushed_elsewhere := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='flushed_elsewhere')

waste <- data[s11q36 == 6, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, ventilated_improved_pit_latrine := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='ventilated_improved_pit_latrine')

waste <- data[s11q36 == 7, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, pit_latrine_with_slab := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='pit_latrine_with_slab')

waste <- data[s11q36 == 8, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, open_pit_latrine := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='open_pit_latrine')

waste <- data[s11q36 == 9, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, composting_toilet := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='composting_toilet')

waste <- data[s11q36 == 11, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, hanging_toilet_latrine := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='hanging_toilet_latrine')

waste <- data[s11q36 == 12, .N, by=lga]
setkey(waste, lga)
setkey(lga_labels, value)
waste_and_labels <- lga_labels[waste, no_facilities := i.N]  #lga_labels[have_phones]
setnafill(waste_and_labels, fill=0, cols='no_facilities')

write.csv(waste_and_labels, './data/interim/nga_human_waste_disposal.csv')

#################################
# Develop Data Extraction Loop  #
#################################
nga_dta_list <- list.files(path = "./data/raw/", pattern = '*.csv')
mobile_bank <- fread(nga_dta_list[89])

