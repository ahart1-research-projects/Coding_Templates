////////////// ADMB Example: Herring Count 8/19/19 ///////////////////////

DATA_SECTION
   // Data read in from herringexample.DAT 
   init_int Nobs; // Number of observations
   init_vector fishCounts(1,Nobs); // Fish counts
   init_vector fishMonth(1,Nobs); // Month in which fish counts took place

PARAMETER_SECTION
  // Model parameters to estimate, global variables, real numbers and objective function (no int variables allowed)

   init_vector loglambda(1,3); // log Lambda parameter for Poisson distribution, vector of length 3 

   vector predictvals(1,Nobs); // Predicted counts
   
 
  // Objective function
  objective_function_value obj_fun; // must have objective function to minimize
 

PROCEDURE_SECTION
   // Includes calculations and the objective function to minimize
   //cout << fishCounts << endl;

  
  for(int iobs=1; iobs<=Nobs; iobs++){
  if(fishMonth(iobs)==4){
      predictvals(iobs) = mfexp(loglambda(1));
    } else if(fishMonth(iobs) == 5){
      predictvals(iobs) = mfexp(loglambda(2));
    } else if (fishMonth(iobs)==6){
      predictvals(iobs) = mfexp(loglambda(3));
    }

    obj_fun += -1.0*log_density_poisson(fishCounts(iobs), predictvals(iobs));
  }
   

REPORT_SECTION
   // Print to .REP file
 report << "loglambda" << loglambda << endl;
 report << "residuals" << endl;
  report << predictvals - fishCounts << endl;
 /*report << "residuals" << endl;
 report << mfexp(loglambda(1)) - fishCounts << endl;*/
 report << "predictions" << endl;
 report << predictvals << endl;
 report << "observations" << endl;
 report <<  fishCounts << endl;


 // If your code isn't working check the following
   // Section headings must start at the margin, but code following section headings must be indented 1 or more spaces (usually 2)
   // Must have an objective_function_value
   // Ensure no int variables in PARAMETER_SECTION
   // Make sure everything is in bounds (weird errors if things aren't indexed correctly & stored in vectors/matrices of the correct size)
   // Ensure .DAT, .PIN, and .TPL files are in same (and current) working directory
   // Make sure previous .par, .std, and .cor files from previous runs have been deleted so that you can check that these are updated & reproduced after debugging
   // ensure all lines end with ;
   // Make sure estimated parameters aren't used in if statements or conditional statements, this could add a discontinutiy when you are trying to solve for the optimal parameter value
   // Ensure local variables declared in advance and given starting value (often set to zero)
 
 // To run, type in ADMB terminal:
    // admb filename.TPL
    // filename - nohess // if you don't want hessian
    // filename // to run as is with hessian

