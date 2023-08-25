#AneBritt Borchert
#08/23/23

#create two different dictionaries
#first dictionary: key = SAMPLE ID and the value: whole row 
#second dictionary: key = SAMPLE ID and the value: the disk name
#combine into a single string and then output it into a spreadsheet

import pandas as pd
from datetime import datetime

# Import the spreadsheets
df = pd.read_excel(r'AB_TEX_LL_summer_2023.xlsx')
dish_df = pd.read_excel(r'AB_TEX_LL_dish_info.xlsx')

# Initialize empty dictionaries
D1_species_info = {}
D2_dish_info = {}

# Create a for loop to populate the dictionaries
for index, row in df.iterrows():
    key = row['SAMPLE ID'] # Extracting the sample id column value from the current row
    values = row.tolist()  # Convert the entire row to a list
    D1_species_info[key] = values

for index, row in dish_df.iterrows():
    sample_id = row['SAMPLE ID']
    dish_no = row["DISH NO"]
    D2_dish_info[sample_id] = dish_no

# Initialize lists to store individual column data
dish_numbers = []
sample_ids = []
species_names = []
collector_nos = []
localities = []
times = []

# Iterate through the keys in D1_species_info (which contains the SAMPLE IDs)
for sample_id, data_values in D1_species_info.items():
    dish_value = D2_dish_info.get(sample_id, "No dish information")

    # Convert datetime object to string
    time_value = data_values[4]  # Assuming the time value is in the fifth position
    if isinstance(time_value, datetime):
        time_value_str = time_value.strftime('%m/%d/%Y')
    else:
        time_value_str = str(time_value)

    # Append values to respective lists
    dish_numbers.append(dish_value)
    sample_ids.append(sample_id)
    species_names.append(data_values[1])
    collector_nos.append(data_values[2])
    localities.append(data_values[3])
    times.append(time_value_str)

# Create a DataFrame from the lists
output_df = pd.DataFrame({
    'DISH NO': dish_numbers,
    'SAMPLE ID': sample_ids,
    'SPECIES NAME': species_names,
    'COLLECTOR NO.': collector_nos,
    'LOCALITY': localities,
    'TIME': times
})

# Export the DataFrame to an Excel file
output_excel_file = 'output.xlsx'
output_df.to_excel(output_excel_file, index=False)

print("Output written to 'output.xlsx'")
