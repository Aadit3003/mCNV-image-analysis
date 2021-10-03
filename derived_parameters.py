import pandas as pd


measurements = pd.read_csv("Measurements/Measurements_Tort_fixed.csv")
measurements["Vessel Density"] = measurements["Vessel Area"]/measurements["mCNV Area"]
measurements["Junction Density"] = measurements["Vessel Junctions"]/measurements["Vessel Length"]
measurements["Vessel Diameter"] = 1000*measurements["Vessel Area"]/measurements["Vessel Length"]
measurements.to_csv("Measurements/Derived_Complete.csv", index=False)

print("Done!")



