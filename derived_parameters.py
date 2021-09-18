import pandas as pd
import numpy as np

measurements = pd.read_csv("Measurements/Measured Parameters.csv")
measurements["Vessel Density"] = measurements["Vessel Area"]/measurements["mCNV Area"]
measurements["Junction Density"] = measurements["Vessel Junctions"]/measurements["Vessel Length"]
measurements.to_csv("Measurements/Derived Parameters.csv", index = False)

print("Done!")