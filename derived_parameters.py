import pandas as pd


measurements = pd.read_csv("Measurements/Dataset 2/measurements.csv")
measurements["Vessel Density"] = measurements["Vessel Area"]/measurements["mCNV Area"]
measurements["Junction Density"] = measurements["Vessel Junctions"]/measurements["Vessel Length"]
measurements["Vessel Diameter"] = 1000*measurements["Vessel Area"]/measurements["Vessel Length"]
measurements.to_csv("Measurements/Dataset 2/octa_biomarkers.csv", index=False)

print("Done!")



