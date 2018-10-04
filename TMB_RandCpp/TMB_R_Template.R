# R template for use with TMB code

setwd("DirectoryName")

require(TMB)

# Read in data here
data_obj1 <- 1
data_obj2 <- c(1,2,3)
data_obj3 <- matrix(5,2,3)

# Create list of data objects, names of list items must match DATA objects in Cpp code
ModelData <- list(data1 = data_obj1, data2 = data_obj2, data3 = data_obj3)

# Create list of parameters and provide initial values (may include parameter vector, e.g. param_vec = rep(0,5))
ModelParameters <- list(dummy=0) # must be a list even if only 1 item in list

# Compile Cpp code
compile("TMB_Cpp_Template.cpp") # file must be in working directory or provide full file path name
dyn.load(dynlib("TMB_Cpp_Template"))

# Use map function to specify which parameters to estimate, those that are not estimated are fixed at initial values and must have a factor(NA) in map list
ModelMap <- list(dummy = factor(NA)) # rep(factor(NA),5) for a parameter vector of length 5

# Construct objective function to optimize based on data, parameters, and Cpp code
Model <- MakeADFun(data = ModelData, parameters = ModelParameters, DLL="TMB_Cpp_Template",silent=T,map = ModelMap) # silent=T silences a bunch of extra print statements

# Set bounds on different parameters, length of this vector must equal number of estimate parameters
lowbnd <- c(-Inf) # rep( 0.1, 5) for a parameter vector of length 5 with lower bound 0.1, syntax for upper bound is the same
uppbnd <- c(Inf)

# Fit model to data using structure provided by MakeADFun() function call
     # eval.max = max number evaluations of objective function
     # iter.max = max number of iterations allowed
     # rel.tol = relative tolerance 
fit <- nlminb(Model$par, Model$fn, Model$gr, control=list(rel.tol=1e-12,eval.max=100000,iter.max=1000), lower=lowbnd,upper=uppbnd) # notice the inclusion of the lower and upper bound vectors
# fit <- nlminb(Model$par, Model$fn, Model$gr, control=list(eval.max=100000,iter.max=1000)) # no bounds on parameters

##### Fitted model results #####
# Best parameter estimates
best <- Model$env$last.par.best
print(best) 

# Report parameter estimates & std error
rep <- sdreport(Model)  
print(summary(rep))

# Print objective function
print(model$report()$obj_fun)

# print objective (likelihood)
fit$objective

# Check for Hessian
VarCo <- solve(Model$he())
print(sqrt(diag(VarCo)))

# Get reported info & predicted data
Predicted <- Model$report()$PredictedVariableNameHere 

