using FMI, FMIImport, FMICore

myFMU = fmiLoad(string(pwd(), "/src/FMI2/Mwe.fmu"))
fmiInfo(myFMU)

fmiInstantiate!(myFMU)
fmi2SetupExperiment(myFMU)
fmi2EnterInitializationMode(myFMU)
fmi2ExitInitializationMode(myFMU)
myFMU.components[end].state
fmi2EnterContinuousTimeMode(myFMU)
fmi2EnterEventMode(myFMU)
fmi2NewDiscreteStates!(myFMU.components[end], myFMU.components[end].eventInfo)
out = zeros(2)
fmi2CompletedIntegratorStep(myFMU, FMICore.fmi2True)
fmi2GetEventIndicators!(myFMU.components[end], out)
fmi2SetContinuousStates(myFMU, [0.1])
FMIImport.fmi2GetNominalsOfContinuousStates(myFMU)
fmi2GetContinuousStates(myFMU)
myFMU.components[end].state
# fmiIsModelExchange(myFMU)
# fmi2EnterEventMode(myFMU)
# fmi2EnterContinuousTimeMode(myFMU)
solution = fmiSimulate(myFMU, (0.0, 1.0); recordValues=["x", "y"])