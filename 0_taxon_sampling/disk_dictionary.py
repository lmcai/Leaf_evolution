#AneBritt Borchert
#08/23/23

#create two different dictionaries
#first dictionary: key = SAMPLE ID and the value: whole row 
#second dictionary: key = SAMPLE ID and the value: the disk name


import pandas as pd

#import the spreadsheet
df = pd.read_excel(r'AB_TEX_LL_summer_2023.xlsx')
dish_df = pd.read_excel(r'AB_TEX_LL_dish_info.xlsx')

#print(df)
#print(dish_df)


#initialize empty dictionaries
D1_species_info = {}
D2_dish_info = {}

#create a for loop 
for index, row in df.iterrows():
    key = row['SAMPLE ID'] #extracting the sample id column value from current row 
    values = row[1:].tolist()
    D1_species_info[key] = values

#print(D1_species_info)


for index, row in dish_df.iterrows():
    sample_id = row['SAMPLE ID']
    dish_no = row["DISH NO"]
    D2_dish_info[sample_id] = dish_no

#print(D2_dish_info)
    
#asks user for a sample id
while True:
        
    input_key = input("Enter sample id (or 'exit' to quit): ")


    if input_key.lower() == 'exit':
        print("exiting program")
        break  # Exit the loop if the user enters 'exit'

    data_values = D1_species_info.get(input_key)
    dish_value = D2_dish_info.get(input_key)

    # Check if the key exists in 'data_dict'
    if data_values is None:
        print(f"No data found for sample id: {input_key}")
    else:
        print(f"Data for sample id: {input_key}: {data_values}")

    # Check if the key exists in 'dish_dict'
    if dish_value is None:
        print(f"No dish information found for sample id: {input_key}")
    else:
        print(f"Dish number for sample id {input_key}: {dish_value}")

    print()


