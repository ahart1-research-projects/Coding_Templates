////////////// TPL Template for ADMB ///////////////////////


// Required sections:
   // DATA_SECTION
   // PARAMETER_SECTION
   // PROCEDURE_SECTION

// Optimal sections:
   // PRELIMINARY_CALCS
   // REPORT_SECTION


DATA_SECTION
   // Data read in from filename.DAT where filename = same name as this .tpl file
   // No differentiable info in this section
   // Start with init when read from .DAT file
   // Must read in data in the order it appears in .DAT file

   ///// Example data
   init_int DataInteger; // Integer read from data file

   init_vector DataVector(1,10); // Data vector (starting value, ending value) can start at any value for indexing, may pass this a parameter

   init_vector DataVector2(1,DataInteger); // if no init this is a local variable

   !! cout << DataVector2 << endl; // Check that the data are read in by printing to screen, cout is cpp command so you need !! in data section

   init_ivector DataIntegerVector(1,10); // Data integer vector

   // Dummy Example Data
   init_int NData;
   init_vector x(1,NData);
   init_vector y(1,NData);


PARAMETER_SECTION
   // Model parameters to estimate, global variables, real numbers and objective function (no int variables allowed)
   // log transformations prevent negative values
   // logit transformations keep values between 0 and 1

   // Estimated parameters (start with init_)
   init_number logpar1; // Estimate parameter, a number, log transformed
   init_number logitpar2; // Estimate parameter, a number, logit transformed

   ///// Global variables that aren't estimated
   number par1; // Parameter, a number, may be used to retransform log/logit transformed estimated parameters 

   vector GlobalVector(1,NData); // estimated or derived values in parameter section (no int variables here)

   // Dummy Example parameters
   init_number a;
   init_number b;
 
 // Objective function
 objective_function_value objfun; // must have objective function to minimize


INITIALIZATION_SECTION
   // Give initial values for parameters, alternatively use .pin file (no ; line endings needed)
 logpar1 -0.6  

PROCEDURE_SECTION
   // Includes calculations and the objective function to minimize
   // Section must start at margin or it causes problems

   // Various expresions
     // mfexp() better than exp()
     // sqrt(); // returns square root
     // posfunc(variablename, eps, penalty); keeps value positive, adds penalty to objfun if negative
     // elem_prod(vector1, vector2); // element multiplication
     // elem_div(vector1, vector2); // element division
     // det(matrix); // determinant
     // inv(matrix); // inverse
     // trans(matrix); // transpose

   // Data management
     // column(matrix,index); // returns column index (e.g. column 1 for index=1) as a vector
     // extract_row(matrix,index); // returns row as a vector
     // extract_diagonal(matrix); // returns diagonal of matrix
     // VectorName(ivector); // indexes by position
     // VectorName(index1,index2); // pull out range of vector values
   // Functions belong here & may be used to break up code, can be called to do things but doesn't return an object


   // Convert from log to normal space
   par1 = mfexp(logpar1);

   // Convert from logit to normal space
   par2 = mfexp(logitpar2)/(1.0 + mfexp(logitpar2));
 
   // Loop over local variable Year from 1:10
   for (int Year=1;Year<=10;Year++){ 
     SumSquares += 1;
   }

   objfun = SumSquares;  
   cout << SumSquares << endl; // Print to screen, no !! needed since C++ commands understood in PROCEDURE_SECTION


   // Dummy Example Procedure 
   ypred = a + b*x;
 


 FUNCTION testfuncction
   // May define function temporary variables here

   int tempvariable; // tempvariable is a local(?) integer

   dvariable tempreal; // tempreal is a differentiable real number

   float tempfloat; // tempfloat is a non-differentiaable real number

   dvar_vector tempvector; // tempvector is a vector of differentiable real numbers
   
   // REST OF FUNCTION HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




REPORT_SECTION
   // Print to .REP file
 report << "print first parameter to in report with this message in .REP file" << par1 << endl;

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

