using FMI, FMIImport, FMICore

myFMU = fmiLoad(string(pwd(), "/src/FMI2/Mwe_1.fmu"))
fmiInfo(myFMU)
myFMU.type == FMIImport.fmi2TypeModelExchange
fmiInstantiate!(myFMU)
fmi2SetupExperiment(myFMU)
fmi2EnterInitializationMode(myFMU)
fmi2ExitInitializationMode(myFMU)
c = myFMU.components[end]
fmi2EnterContinuousTimeMode(myFMU)
fmi2EnterEventMode(myFMU)
fmi2NewDiscreteStates!(myFMU.components[end], myFMU.components[end].eventInfo)
fmi2GetDerivatives!(myFMU.components[end], zeros(2))
out = zeros(2)
fmi2CompletedIntegratorStep(myFMU, FMICore.fmi2True)
fmi2GetEventIndicators!(myFMU.components[end], out)
fmi2SetContinuousStates(myFMU, [0.1])
FMIImport.fmi2GetNominalsOfContinuousStates(myFMU)
fmi2GetContinuousStates(myFMU)
fmi2ComponentStateError == (myFMU.components[end].state)
# fmiIsModelExchange(myFMU)
# fmi2EnterEventMode(myFMU)
# fmi2EnterContinuousTimeMode(myFMU)
dx = c(;dx=[0.0], x=[0.1], t=0.0)
solution = fmiSimulate(myFMU, (0.0, 1.0); recordValues=["x", "y"])

solution.values.saveval
Plots.plot(solution.values.t, collect(x[1] for x in solution.values.saveval))
Plots.plot(solution.values.t, collect(x[2] for x in solution.values.saveval))

solution.states