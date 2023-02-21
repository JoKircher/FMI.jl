using FMI

myFMU = fmiLoad(string(pwd(), "/src/FMI2/Mwe.fmu"))
solution = fmiSimulate(myFMU, (0.0, 1.0); recordValues=["x", "y"])