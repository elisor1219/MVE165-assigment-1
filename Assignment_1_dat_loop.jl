CROPS_INDEX = 1:3
FUEL_INDEX = 1:3

CROPS = ["Soybeans" "Sunflower" "Cotton"]
FUEL = ["B5" "B30" "B100"]

#             Yield     Water   Oil
crop_table = [2.6       5.0     0.178   #Soybeans
              1.4       4.2     0.216   #Sunflower
              0.9       1.0     0.433]  #Cotton

#               Biodiesel    Price       Tax
product_table = [0.05        1.43        0.20       #B5
                 0.30        1.29        0.05       #B30
                 1.00        1.16        0.00]      #B100
