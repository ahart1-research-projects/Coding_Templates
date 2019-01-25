// C++ template for TMB code

#include <TMB.hpp>
  
  // Optional function which square the value provided
  template <class Type> Type square(Type x){return x*x;}
  
  // Objective function which returns the value to minimize (often the negative log likelihood)
  template<class Type>
  Type objective_function<Type>::operator() ()
  {
    ///// Data section /////
    DATA_INTEGER(data1); 
    DATA_IVECTOR(data2); // Vector of integers ??
    DATA_MATRIX(data3); 
    // DATA_VECTOR(data_object_name); // Vector of data
    
    
    ///// Parameter section /////
    PARAMETER(dummy); // Include dummy variable to debug code without full estimation of likelihood
    //PARAMETER_VECTOR(parameter_vector_name); // Vector of estimated parameters
    //PARAMETER(log_variable); // initial values should be log transformed, values maintained >= 0
    //PARAMETER(logit_variable); // initial values should be logit transformed, values maintained between 0 and 1
    
    // Retransform variables so not in log space 
    // Type local_variable = exp(log_variable); // log transformation keeps parameter positive, exp() retransforms it
    // Type local_variable = exp(logit_variable)/(1+exp(logit_variable)); // logit transformation keeps parameter between 0 to 1, inverse logit (this line) retransforms it
    
    // Local variables
    Type local_variable2; // single value variable which is NOT an integer
    local_variable2 = 5; 
    
    vector<Type> local_vector(5); // vector of length 5
    matrix<Type> local_matrix(3,4); // 3X4col matrix
    
    Type obj_fun; // Always need objective function object
    
    
    ///// Calculate parameters (could also do in R and pass in as DATA) /////

    
    ///// Initialize objective function at zero /////
    obj_fun = 0; 
    
    ///// Code which contributes to objective function /////
    // Generally make a prediction and compare that prediction to data (likelihood)
    // minimize comparison so you pick parameter values to best predict data
    // obj_fun += likelihood_component1 + likelihood_component2...
    obj_fun += dummy*dummy; // dummy objective function used to debug (make sure code compiles) without estimating all parameters
       
    /*
    for (int iloop=0; iloop<5; iloop++) { // loop from 0 to iloop < 5 (0,1,2,3,4), int makes this a local loop variable
      
    }
    */
    
    ///// ADReport reports deviation /////
    // ADREPORT(variable_or_parameter_name_here); // Report variables or parameters with deviation

    
    ///// Report /////
    // REPORT(variable_or_parameter_name_here); // Report variable or parameter value
    
    
    ///// Return objective function /////
    return(obj_fun);
    
    ///// Advice if not compiling /////
    // Check that all lines end in ;
    // Check that * between multiplied objects in equations
    // Check indexing on objects in equations
    // Check indexing of storage objects (e.g. StorageVector = DataVector1[i]*DataVector2[i] won't work since this produces a single value but there is no indexing of StorageVector[i])
    // Check indexing of for() loops (indexing starts at 0)
    // Check spelling of objects in equations
    // Try commenting out parts of the line causing the error and gradually add them back in until it causes an error again to ID the source
  }
  






