#ifdef DEBUG
  #ifndef __SUNPRO_C
    #include <cfenv>
    #include <cstdlib>
  #endif
#endif
#include <admodel.h>
#include <contrib.h>

  extern "C"  {
    void ad_boundf(int i);
  }
#include <herring_example.htp>

model_data::model_data(int argc,char * argv[]) : ad_comm(argc,argv)
{
  Nobs.allocate("Nobs");
  fishCounts.allocate(1,Nobs,"fishCounts");
}

model_parameters::model_parameters(int sz,int argc,char * argv[]) : 
 model_data(argc,argv) , function_minimizer(sz)
{
  initializationfunction();
  loglambda.allocate("loglambda");
  obj_fun.allocate("obj_fun");
  prior_function_value.allocate("prior_function_value");
  likelihood_function_value.allocate("likelihood_function_value");
}

void model_parameters::userfunction(void)
{
  obj_fun =0.0;
   // Includes calculations and the objective function to minimize
   //cout << fishCounts << endl;
   for(int iobs=1; iobs<=Nobs; iobs++){
    obj_fun += -1.0*log_density_poisson(fishCounts(iobs), mfexp(loglambda));
    // NO DOESNT WORK obj_fun += -1.0*log(dpois(fishCounts(iobs), mfexp(loglambda))); // negative log-likelihood for Poisson distribution
   }
}

void model_parameters::report(const dvector& gradients)
{
 adstring ad_tmp=initial_params::get_reportfile_name();
  ofstream report((char*)(adprogram_name + ad_tmp));
  if (!report)
  {
    cerr << "error trying to open report file"  << adprogram_name << ".rep";
    return;
  }
   // Print to .REP file
 report << "loglambda" << loglambda << endl;
 report << "residuals" << endl;
 report << mfexp(loglambda) - fishCounts << endl;
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
}

void model_parameters::preliminary_calculations(void){
#if defined(USE_ADPVM)

  admaster_slave_variable_interface(*this);

#endif
}

model_data::~model_data()
{}

model_parameters::~model_parameters()
{}

void model_parameters::final_calcs(void){}

void model_parameters::set_runtime(void){}

#ifdef _BORLANDC_
  extern unsigned _stklen=10000U;
#endif


#ifdef __ZTC__
  extern unsigned int _stack=10000U;
#endif

  long int arrmblsize=0;

int main(int argc,char * argv[])
{
    ad_set_new_handler();
  ad_exit=&ad_boundf;
    gradient_structure::set_NO_DERIVATIVES();
#ifdef DEBUG
  #ifndef __SUNPRO_C
std::feclearexcept(FE_ALL_EXCEPT);
  #endif
#endif
    gradient_structure::set_YES_SAVE_VARIABLES_VALUES();
    if (!arrmblsize) arrmblsize=15000000;
    model_parameters mp(arrmblsize,argc,argv);
    mp.iprint=10;
    mp.preliminary_calculations();
    mp.computations(argc,argv);
#ifdef DEBUG
  #ifndef __SUNPRO_C
bool failedtest = false;
if (std::fetestexcept(FE_DIVBYZERO))
  { cerr << "Error: Detected division by zero." << endl; failedtest = true; }
if (std::fetestexcept(FE_INVALID))
  { cerr << "Error: Detected invalid argument." << endl; failedtest = true; }
if (std::fetestexcept(FE_OVERFLOW))
  { cerr << "Error: Detected overflow." << endl; failedtest = true; }
if (std::fetestexcept(FE_UNDERFLOW))
  { cerr << "Error: Detected underflow." << endl; }
if (failedtest) { std::abort(); } 
  #endif
#endif
    return 0;
}

extern "C"  {
  void ad_boundf(int i)
  {
    /* so we can stop here */
    exit(i);
  }
}
