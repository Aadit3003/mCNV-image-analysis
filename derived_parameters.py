import pandas as pd
import numpy as np

measurements = pd.read_csv("Measurements/Measurements_Fractal.csv")
measurements["Vessel Density"] = measurements["Vessel Area"]/measurements["mCNV Area"]
measurements["Junction Density"] = measurements["Vessel Junctions"]/measurements["Vessel Length"]
measurements.to_csv("Measurements/Derived_Fractal.csv", index=False)

print("Done!")