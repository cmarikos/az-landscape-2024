import folium
import pandas as pd

# Read metrics dataframe

# Create a map centered on a latitude/longitude
m = folium.Map(location=[37.7749, -122.4194],  # San Francisco coords
               zoom_start=12)  # Zoom level (1=world, 20=street)

# Display map (in Jupyter or Colab, just evaluate `m`)
m.save("my_test_map.html")
