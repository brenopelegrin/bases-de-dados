import pandas as pd
import matplotlib.pyplot as plt
import os
import dataframe_image as dfi 
 

for file in os.listdir("output_scripts"):
    if file.endswith(".csv"):
        df = pd.read_csv(os.path.join("output_scripts", file))
        dfi.export(df, os.path.join("output_scripts", file.replace('.csv', '.png')), dpi=150)