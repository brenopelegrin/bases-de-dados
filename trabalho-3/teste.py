import pandas as pd
import matplotlib.pyplot as plt

# Read CSV
df = pd.read_csv("./output_scripts/3.3a.csv")

# Filter to show only the first 3 rows
df.drop(columns=["datas_disponiveis"], inplace=True)
# Create the figure and axes with larger size
fig, ax = plt.subplots(figsize=(12, 6))  # Increase figure size
ax.axis('off')  # No axes

# Create table
table = ax.table(cellText=df.values, colLabels=df.columns, loc='center', cellLoc='center')

# Adjust font size and cell size
table.auto_set_font_size(False)
table.set_fontsize(4)  # Larger font
table.scale(1.2, 1.5)   # Scale width and height

# Save as image with high DPI for better quality
plt.savefig("table_image.png", bbox_inches='tight', dpi=300)