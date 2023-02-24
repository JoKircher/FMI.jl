using FMI, FMIImport

myFMU = fmiLoad(string(pwd(), "/src/FMI2/Mwe.fmu"))
fmiInfo(myFMU)
fmi2SetContinuousStates(myFMU, [0.1])
myFMU.components[end].state
fmiInstantiate!(myFMU)
fmi2SetupExperiment(myFMU)
fmi2EnterInitializationMode(myFMU)
fmi2ExitInitializationMode(myFMU)
# fmiIsModelExchange(myFMU)
# fmi2EnterEventMode(myFMU)
# fmi2EnterContinuousTimeMode(myFMU)
solution = fmiSimulate(myFMU, (0.0, 1.0); recordValues=["x", "y"])