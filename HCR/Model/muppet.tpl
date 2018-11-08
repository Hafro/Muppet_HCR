// Some of the haddock functions have "had" in the middle of the name.  Could perhaps be made more generic. 

DATA_SECTION

  int debug_input_flag
  !! debug_input_flag=1;
  !! ofstream ofs("input.log");
  init_adstring catchfilename;  // cno, cwt, mat, cwt etc.  
  !! ofs << "catchfilename " << catchfilename << endl;
  // This is a file with total catch in 1000 tonnes for year where CNO is not
  // available (-1) in catch and stock data file.  CWT, SWT and Mat have to
  // be given for those years but are of course some averages.  File with 2
  // columns year totcatch 
  init_adstring totalcatchfilename;  // not used any name
  !! ofs << "totalcatchfilename " << totalcatchfilename << endl;
  init_adstring catchresidualfilename;  // not used any name
  !! ofs << "catchresidualfilename " << catchresidualfilename << endl;
  init_int INITCOND;  // 1 if starting pin file.  
  !! ofs << "INITCOND " << INITCOND << endl;
  init_int BackWards;  // Catch at age (0) or VPA (1) model.  
  !! ofs << "BackWards " << BackWards << endl;


// Survey data can be used up to lastoptyear+1
  init_int firstyear    // firstyear used in the assesment
  init_int lastoptyear;    // Last year used in the assessment (last year with catch)
  init_int nsimuyears     // Number of years simulated
  init_int lastdatayear;  // Last year with catch in numbers data.  

  init_int firstage     // First age
  init_int lastdataage  // 
  init_int lastage        // Last age model makes a plus group out of lastage-lastdataage
  init_int firstcatchage  // First age group in catch
  init_int minssbage;  // First age in SSB
//  init_int firstagewithconstantF; // Above this F is independed of age see nfixedselages
  init_int plusgroup 	  // 1 if plus group else 0

  init_int recrdatadelay  // delay from when a yearclass is born until first data on it is available
			  // survey in assessment year that includes age 1 means a datadelay of 0 year.
			  // most often set to 0.  
  init_int  nfixedselages; //Number of oldest age groups with same F
  init_int estMlastagephase;  //if > 0 M of last age is estimated.  
  !! ofs << "firstyear " << firstyear << "lastoptyear " << lastoptyear << "nsimuyears " << nsimuyears; 
  !! ofs << "lastdatayear " << lastdatayear  << endl;
  
  int noptyears;
  int nyears;  // number of years used in the optimiztion
  int lastyear 
  int nages;
  !!lastyear = lastoptyear  + nsimuyears;
  !!noptyears = lastoptyear - firstyear + 1; 
  !!nyears = noptyears + nsimuyears;

  !! ofs  << " firstage " << firstage << " lastdatage " << lastdataage << " lastage " << lastage << " firstcatchage " << firstcatchage << " plusgroup " << plusgroup;
  !! ofs << " recrdatadelay " << recrdatadelay <<  " nfixedselages " << nfixedselages <<  " estMlastagephase " << estMlastagephase << endl;

  !!nages = lastage - firstage + 1;


  init_adstring stockparametersfilename; //M propM , propF before spawning and more
  !! ofs << "stockparametersfilename " << stockparametersfilename << endl;  
  init_adstring catchparametersfilename; // File describing when selection pattern changes
  !! ofs << "catchparametersfilename " << catchparametersfilename << endl;  
  init_adstring likelihoodparametersfilename;
  !! ofs << "likelihoodparametersfilename " << likelihoodparametersfilename << endl;  // wt on likelihood par etc.  
  init_adstring outputparametersfilename;  //Age range on fbar etc.  
  !! ofs << "outputparametersfilename " << outputparametersfilename << endl;  

  


  init_int nsurveys; // Number of surveys
  !! ofs << "nsurveys " << nsurveys << endl;

  ivector surveyfirstyear(1,nsurveys);
  ivector surveylastyear(1,nsurveys);
  ivector surveyfirstage(1,nsurveys);
  ivector surveylastage(1,nsurveys);
  ivector surveyfirstagewithconstantcatchability(1,nsurveys);
  ivector surveyfirstagewithfullcatchability(1,nsurveys);
  ivector surveytimefromlastyear(1,nsurveys);
  ivector surveytype(1,nsurveys);  // 1 ordinary, 2 biomass+proportions 4 ssb survey
  ivector surveyweightsgiven(1,nsurveys);
  ivector surveycorrphase(1,nsurveys);  //-1 if correlation is not estimated
  ivector surveylogitphase(1,nsurveys); // indicator  > 0 survey q logit else per age group.  


 // Now we come to a little tricky part where the input in AD-model builder is rather 
// limiting.  Have to read from *global_datafile  Three datafiles for each survey.  
  !!int i,j;
  !!ivector tmpsurveydata(1,10);
  !!adstring tmpsurveyfilename;  // Have to pass this to main program through file.
  !!ofstream surveyfile("SURVEYFILES.DAT"); // The temporary file.  
  !!for (i = 1; i<=nsurveys; i++) {
     !!*global_datafile  >> tmpsurveydata;
     !! ofs << "survey nr" << i << " - " << tmpsurveydata << "  ";
     !! surveyfirstyear(i) = tmpsurveydata(1);
     !! surveylastyear(i) = tmpsurveydata(2);
     !! surveyfirstage(i) = tmpsurveydata(3);
     !! surveylastage(i) = tmpsurveydata(4);
     !! surveyfirstagewithfullcatchability(i) = tmpsurveydata(5);
     !! surveyfirstagewithconstantcatchability(i) = tmpsurveydata(6);
     !! surveytimefromlastyear(i) = tmpsurveydata(7);
     !! surveytype(i) = tmpsurveydata(8);
     !! surveycorrphase(i) = tmpsurveydata(9);
     !! surveylogitphase(i) = tmpsurveydata(10);
     !! if(surveylogitphase(i) > 0)  surveyfirstagewithfullcatchability(i) = surveyfirstage(i); // one q level estimated
     !! if(surveylogitphase(i) > 0)  surveyfirstagewithconstantcatchability(i) = surveyfirstage(i);
     !! if(surveyfirstyear(i) < firstyear) surveyfirstyear(i) = firstyear;
     !! if(surveylastyear(i) > lastyear+ surveytimefromlastyear(i)) 
     !!    surveylastyear(i) =  lastyear+ surveytimefromlastyear(i);
     !! if(surveyfirstage(i)  < firstage) surveyfirstage(i) = firstage;
     !! if(surveylastage(i) > lastage) surveylastage(i) = lastage;
     !! if(surveyfirstagewithconstantcatchability(i) > lastage )
     !!      surveyfirstagewithconstantcatchability(i) = lastage;
     !! for (j = 1; j <= 3; j++) {
       !!*global_datafile  >> tmpsurveyfilename;
       !! ofs << tmpsurveyfilename << " "; 
       !! surveyfile << tmpsurveyfilename << " ";
     !! }
     !! surveyfile << endl;
     !! ofs << endl; 
   !!}
   !!surveyfile.close();
   int minsurveyfirstage
   int maxsurveyfirstagewithfullcatchability;
   int maxsurveyfirstagewithconstantcatchability;
   !! minsurveyfirstage = min(surveyfirstage);
   !! maxsurveyfirstagewithfullcatchability = max(surveyfirstagewithfullcatchability);
   !! maxsurveyfirstagewithconstantcatchability = max(surveyfirstagewithconstantcatchability);


   int COUNTER;  // For random number generation

//************************************************************************************************
// Parameters for stock recruitment relationship PropofFbeforeSpawning and 
// init_number PropofMbeforeSpawning should possibly be made agedependent ????
// These parameters are input here as it is decided which parameters are to be estimated.  

  init_int SSBRectype   // if 1 Beverton and Holt, 2  Ricker 6 constant
// Parameters in SSBRecr function  1.  SSBmax   2. Rmax 3.  CV  4.  Correlation 
// 5.  Power for CV as function of ssb
// 6 Timetrendinrecruitment  7.  RefSSB  8.  Minrelssb  9.  Maxrelssb:   
  init_vector SSBRecParameters(1,6);
  init_vector SSBRecSwitches(1,6)  // Phase of  6 first of SSBRecParameters.  -1 not estimated. 

  !!ofs << "SSBRectype " << SSBRectype << endl;
  !!ofs  << " Rmax " << SSBRecParameters(1) << " SSBmax " << SSBRecParameters(2) ; 
  !!ofs << " SSBReccv " << SSBRecParameters(3)  ;
  !!ofs << " SSBReccorr " <<  SSBRecParameters(4) << " SSBRecpow" << SSBRecParameters(5)  << endl;
  !!ofs << " Timetrendinrecruitment" <<  SSBRecParameters(6) << endl; // should really be called productivity change

  !!ofs << " SSBRecSwitches " << SSBRecSwitches << endl;
 
 
//***********************************************************************************************
//Number of Migration events has to be input here as the number of events is dependent on them.  
//The exact years and ages are in read with stock parameters.  
  init_int MigrationNumbers;
  !! ofs << "MigrationNumbers " << MigrationNumbers << endl ;



//**************************************************************************************
// Data regarding output  

//***********************************************************************************+++
// Prognosis  
// CatchRule 1 Specified catch, 2 Specified F, 3 Proportion of biomass
// PrognosisFile contains information on maturity, weight at age etc but 
// later rest of the prognosisdata might be input from file.  

  init_adstring PrognosisFilename;
  !! ofs << "PrognosisFilename " << PrognosisFilename  << endl;
  init_adstring WeightAndMaturityDatafilename;     // Weights and more for prognosis
  !!ofs << "WeightAndMaturityDatafilename" <<  WeightAndMaturityDatafilename << endl;   
  init_int  number_of_seperable_periods;
  !!ofs <<  "number_of_seperable_periods " <<  number_of_seperable_periods << endl;
  init_int prodchangeyear; // Year that productivity change SSBRecParameters(6) occurrs
  !!ofs <<  "prodchangeyear " <<  prodchangeyear << endl;

  // if misreporting is not estimated the value is 0 of logmisreporting except data are read from
  // a pin file.  Might be changed if different level of misreporting iis needed.  

// Here we have reading of different phases and upper and lower bounds.  Gradually more and more
// things should be moved here but we do not want those values to be hardwired in the code.  

 init_adstring OptimDatafilename;  
  !!ofs << "OptimDatafilename " <<  OptimDatafilename << endl;  
// Addition because of problems with bounds especially lower bounds log scale
  !! ad_comm::change_datafile_name(OptimDatafilename);
  init_vector logSSBRecLowerbounds(1,6);
  !!ofs << "logSSBRecLowerbounds " << logSSBRecLowerbounds << endl;
  init_vector logSSBRecUpperbounds(1,6);
  !!ofs << "logSSBRecUpperbounds " << logSSBRecUpperbounds << endl;
  init_number logminssbsurveyCV;  // ssb survey 
  !!ofs << "logminssbsurveyCV " << logminssbsurveyCV << endl;
  init_number logminsurCV;  // normal surveys scaled by multiplier
  !!ofs << "logminsurCV " << logminsurCV << endl;
  // estimation phase for survey .  2 for surveylnqphase -1 for surveypowphase
  init_int surveylnqphase;
  !!ofs << "surveylnqphase " << surveylnqphase << endl;
  init_int surveypowphase;
  !!ofs << "surveypowphase " << surveypowphase << endl;
  init_ivector surveybiopowphase(1,nsurveys);
  !!ofs << "surveybiopowphase " << surveybiopowphase << endl;
  init_int estselphase // selection for each agegroup - if logit model is used.  
  !!ofs << "estselphase " << estselphase << endl;
  init_int catchlogitphase // selection logit og age
  !!ofs << "catchlogitphase " << catchlogitphase << endl;
  init_int catchlogitsizephase // selection logit of stockwts.  
  !!ofs << "catchlogitsizephase " << catchlogitsizephase << endl;
  init_int misreportingphase; // Misreporting estimate -1 misreporting not estimated. Misreporting year fixed as 1999 see scaleCatches.  
  !!ofs <<  "misreportingphase " <<  misreportingphase << endl;

  int LastMisReportingYear;
  number CatchRule;
  number weightcv;
  number weightcorr;
  number Assessmentcv;
  number Assessmentcorr;
  number Recrcorr; 
  number Btrigger;
  number EstimatedAssYrSSB;
  number Maxchange;  // maxchange of catches / *(1+MaxChange)
  number AssessmentErrorRat // Ratio between F(y+1)  assessment error and SSB(Y) asserr 0.6
  int nprogselyears;  
  int nweightandmaturityselyears;  // number of years used to get average Wt and mat for prediction (if file is not specified)
  int IceFishYear;  //Icelandic fishing year 1 or calendar year 0
  int DensDep;// Most often 0. 1 is Icelandic haddock other values can be used for other parameters.   
  int HCRrefAge;  // Biorule based on HCRrefAge +
  int HCRreflebreak; // Biomass is based on LE > HCRreflebreak (icehad).  
  int  HCRBproxyAge  // Biorule HCRBproxyAge + as Bproxy instead of SSB
  int AgeModel // If 1 used age based refbio, else size based.
  number MaxHarvestRatio //Maximum harvest rate allowed used to not crash the stock when HCR calls for more.  

  number HarvestRatio;
  number CurrentTacInput;
  number TacLeftInput;  // Tac left in the beginning of the assessment year
  number LastYearsTacRatio // Ratio of last years TAC IC stabiliser

  vector FutureForCatch(lastoptyear+1,lastyear); // Catch or F for the future.  


  ivector RefBiominage(1,2);  // Ref biomasses RefBio1 and RefBio2 are biomasses above and including certain age.  
  int Frefage1;  // first age Fbar
  int Frefage2;  // last age Fbar
  int WeightedF; // 0 unweighted, 1 weighted by number
  int printPhase;
  ivector mcallwriteswitch(1,6);  // for mcallwrite
  ivector mcwriteswitch(1,22); // for mcmc_write
  ivector MigrationAges(1,MigrationNumbers);
  ivector MigrationYears(1,MigrationNumbers);
  int CatchRobust;  //wide tail distributions
  int SurveyRobust; // not used very much

// Number of likelihood files.  Form of this part might be changed
  int likelihood_mcmc_lines;
  int migration_mcmc_lines;
  int recruitment_mcmc_lines;
  int initpopulation_mcmc_lines;
  int estimatedselection_mcmc_lines;
  int parameter_mcmc_lines;
  int surveypower_mcmc_lines;
  int surveyq_mcmc_lines;
  int effort_mcmc_lines;
  int catch_mcmc_lines;
  int assessmenterror_mcmc_lines;

  int refbio2_mcmc_lines;
  int refbio1_mcmc_lines;
  int hcrrefbio_mcmc_lines;
  int hcrbproxy_mcmc_lines;
  int n3_mcmc_lines;
  int n1st_mcmc_lines;
  int f_mcmc_lines;
  int ssb_mcmc_lines;
  int relssb_mcmc_lines;
  int ssbwerr_mcmc_lines;

  int mcmc_iteration;
  ivector parcolnr(firstyear,lastyear);  // column in parameter vector.  

// Those variables might be input by init_int in the main file or 
// switch to phases.dat

  int catagephase1;
  int catagephase2;
  int catagephase3;
  int catagephase4;
  int vpaphase1;
  int vpaphase2;
  int vpaphase3;
  // Look somewhat better at the phases. 
   !! if(BackWards == 0) {catagephase1 = 1; catagephase2 = 2;catagephase3 = 3;catagephase4 = 4; vpaphase1 = -1; vpaphase2= -1; vpaphase3 =-1;}
  !! if(BackWards == 1) {catagephase1 = -1; catagephase2 = -1;catagephase3 = -1;catagephase4 = -1; vpaphase1 = 1; vpaphase2= 2; vpaphase3=4;}
  int firstestage  // only used in the VPA runs in the estimated years.  
  !! firstestage = firstage;
  !! if(firstage == 0) firstestage = 1; 

INITIALIZATION_SECTION
  logMoldest -1.6;  // exp(-1.6) = 0.2  only used if estMlastagephase > 0
  logFoldestmult  0;

PARAMETER_SECTION

// Estimated variables;
 init_bounded_number logMisreportingRatio(-1,1,misreportingphase);
 init_bounded_number logFoldestmult(-1,1,-2); // Not estimate but option available in VPA runs
 init_bounded_number logMoldest(-3,-0.5,estMlastagephase);
 init_bounded_vector lnMigrationAbundance(1,MigrationNumbers,1,13,catagephase1);
 init_bounded_number lnMeanRecr(10,20,catagephase1);
 init_bounded_dev_vector lnRecr(firstyear,lastoptyear+firstage-recrdatadelay,-6,6,catagephase2) ;// log of recruitment
 init_bounded_number lnMeanInitialpop(7,17,catagephase1);
 init_bounded_dev_vector lnInitialpop(firstage+1,lastage,-7,7,catagephase2);
 init_bounded_matrix EstimatedSelection(firstcatchage,lastage-nfixedselages,1,number_of_seperable_periods,-5,0.2,estselphase); // Same selection of last 4 age groups
 init_bounded_number Catchlogitslope(0.05,5,catchlogitphase);
 init_bounded_number Catchlogitage50(1,11,catchlogitphase);
 init_bounded_number selslope(0.2,5,catchlogitsizephase);
 init_bounded_number fullselwt(500,3000,catchlogitsizephase);


// Error terms, set here in this version as they must be global needed for the haddock model
  vector weighterr(lastoptyear+1,lastyear);  // stock weight
  vector recrweighterr(lastoptyear+1,lastyear); // age 2 
  vector catchweighterr(lastoptyear+1,lastyear); // If CW is a function of SW deviance in that model.  
  vector selerr(lastoptyear+1,lastyear);  // Selection error.  



 init_bounded_number logSigmaCmultiplier(-1,1,catagephase4); 
 init_bounded_number AbundanceMultiplier(-10,10,-6); 
 init_bounded_number lnMeanEffort(-3,3,catagephase1);
 init_bounded_dev_vector lnEffort(firstyear,lastoptyear,-4,4,catagephase2);  // log of Fishing mortality of oldest fish i.e effort
 init_bounded_number meanlogSurvivors(4,15,vpaphase1);
 init_bounded_dev_vector logSurvivors(firstestage,lastage-1,-6,6,vpaphase2);

  
// Survey parameters  here some cleaning of values and bounds could be done.  More file control.
  vector Surveylikelihood(1,nsurveys);
  init_bounded_matrix SurveyPowerest(1,nsurveys,minsurveyfirstage,maxsurveyfirstagewithconstantcatchability,1,3,surveypowphase);
  !!dvector surveybiopowlb(1,nsurveys); //0.02
  !!dvector surveybiopowub(1,nsurveys); //0.85
  !! for(int i = 1;i <= nsurveys; i++)  surveybiopowlb(i) = 0.5;
  !! for(int i = 1;i <= nsurveys; i++) surveybiopowub(i) = 2;
  init_bounded_number_vector surveybiopow(1,nsurveys,surveybiopowlb,surveybiopowub,surveybiopowphase);
  init_bounded_vector SigmaSurveypar(1,nsurveys,-5,3,catagephase4);
  init_bounded_matrix SurveylnQest(1,nsurveys,minsurveyfirstage,maxsurveyfirstagewithfullcatchability,-30,15,4); //4
  init_bounded_vector surveylogitslope(1,nsurveys,0.1,3,4);  // should perhaps try to have the phase variable
  init_bounded_vector surveylogitage50(1,nsurveys,-2,12,4);  
  !!dvector scorrlb(1,nsurveys); //0.02
  !!dvector scorrub(1,nsurveys); //0.85
  !! for(int i = 1;i <= nsurveys; i++) scorrlb(i) =0.0005;
  !! for(int i = 1;i <= nsurveys; i++) scorrub(i) =0.95;
  !!ivector scorrphase(1,nsurveys); //-1
  !!scorrphase = ivector(surveycorrphase);
  init_bounded_number_vector Surveycorr(1,nsurveys,scorrlb,scorrub,scorrphase);
  init_bounded_matrix logSigmaSurvey(1,nsurveys,firstage,lastage,logminsurCV,1,vpaphase3); 
  init_bounded_vector logSigmaSurveybio(1,nsurveys,logminssbsurveyCV,-0.7,5);  // Later make the pase variable. 

// Parameters in SSB-recruitment.  
  !!ivector srphase(1,6);
  !!srphase = ivector(SSBRecSwitches);
  init_bounded_number_vector estSSBRecParameters(1,6,logSSBRecLowerbounds,logSSBRecUpperbounds,srphase);




  number firsttime; // for printing

// -1 is missing value.  
  matrix ObsCatchInNumbers(firstyear,lastyear,firstage,lastage); // with misreporting
  matrix ObsCatchInNumbersInput(firstyear,lastyear,firstage,lastage);

  matrix CatchDiff(firstyear,lastyear,firstage,lastage);

// Data are the original variables read from files.  
  matrix CatchWeightsData(firstyear,lastyear,firstage,lastage);
  matrix StockWeightsData(firstyear,lastyear,firstage,lastage);
  matrix SSBWeightsData(firstyear,lastyear,firstage,lastage) ;
  matrix StockMaturityData(firstyear,lastyear,firstage,lastage);

// This set is the same as before but for stochastic simulations 
  matrix CatchWeights(firstyear,lastyear,firstage,lastage);
  matrix StockWeights(firstyear,lastyear,firstage,lastage);
  matrix SSBWeights(firstyear,lastyear,firstage,lastage) ;
  matrix StockMaturity(firstyear,lastyear,firstage,lastage);


  matrix N(firstyear,lastyear,firstage,lastage)
  matrix Nhat(firstyear,lastyear,firstage,lastage)
  matrix F(firstyear,lastyear,firstage,lastage)
  matrix natM(firstyear,lastyear,firstage,lastage)   // Natural mortality 
  matrix Z(firstyear,lastyear,firstage,lastage);  // Total mortality
  matrix PropInCatch(firstyear,lastyear,firstage,lastage); // Modelled proportion in catch
  vector TotalCalcCatchInNumbers(firstyear,lastyear); // modeled catch in numbers by year
  vector CalcCatchIn1000tons(firstyear,lastyear);  //  Modelled catch ***
  vector TotCatchIn1000tons(firstyear,lastyear);  // Catch used when CNO not available.  
  vector CatchIn1000tons(firstyear,lastyear);  // Observed catch
  vector CatchIn1000tonsInput(firstyear,lastyear);  // Observed catch
  vector FishingYearCatch(firstyear,lastyear);  //Icelandic fishing year.  

  matrix CalcCatchInNumbers(firstyear,lastyear,firstage,lastage); // modelled catch in no by year and age
  vector meansel(firstage,lastage); // mean selection
  vector progsel(firstage,lastage); // selection in prognosis (last ?? years)
  vector ProgF(lastoptyear+1,lastyear);
  vector SigmaC(firstage,lastage);
  vector SigmaCinp(firstage,lastage);




  vector Mdata(firstage,lastage); // input M as function of age;
  vector PredictedRecruitment(firstyear,lastyear);
  vector Recruitment(firstyear,lastyear);
  vector RecruitmentResiduals(firstyear,lastyear);
  
  vector Misreporting(firstyear,lastoptyear);

  vector Foldestinp(firstyear,lastdatayear); // For VPA runs 

// Some reference values that later could be set as sdreport_vector

  vector RefBio1(firstyear,lastyear);
  vector RefBio2(firstyear,lastyear);
  vector HCRrefbio(firstyear,lastyear);
  vector HCRBproxy(firstyear,lastyear)
  vector N3(firstyear,lastyear);
  vector N1st(firstyear,lastyear);
  vector CbioR(firstyear,lastyear);
  vector Totbio(firstyear,lastyear);

// sdreport vectors that need to be set.  
  vector PredRefF(lastoptyear-5,lastyear); //sd
  vector PredSpawningstock(lastoptyear-5,lastyear); //sd
  vector PredN(lastoptyear-5,lastyear); //sd
  vector Survivors(firstage,lastage); //sd

  sdreport_vector RefF(firstyear,lastyear);
  sdreport_vector Spawningstock(firstyear,lastyear);
//  vector RefF(firstyear,lastyear);
//  vector Spawningstock(firstyear,lastyear);
  vector SpawningstockWithErr(firstyear,lastyear); // Only defined from lastoptyear.  
  sdreport_vector RelSpawningstock(firstyear,lastyear);
  vector SigmaSSBRec(firstyear,lastyear);
  vector EggProduction(firstyear,lastyear);
  vector TimeDrift(firstyear,lastyear); // Timedrift in Rmax in SSB-Recruitment relationship.  

  


// Surveys

  vector SurveyPropOfF(1,nsurveys); // Proportion of F before survey 
  vector SurveyPropOfM(1,nsurveys); // Proportion of M before survey 
  matrix SurveyResolution(1,nsurveys,firstage,lastage);  // must give all agegrups
  matrix SigmaSurveyInp(1,nsurveys,firstage,lastage);  // input from file.  
  matrix SigmaSurvey(1,nsurveys,firstage,lastage);
  matrix SurveylnQ(1,nsurveys,firstage,lastage);
  matrix SurveyPower(1,nsurveys,firstage,lastage);
  3darray ObsSurveyNr(1,nsurveys,firstyear,lastyear,firstage,lastage);
  3darray CalcSurveyNr(1,nsurveys,firstyear,lastyear,firstage,lastage);  
  3darray SurveyResiduals(1,nsurveys,firstyear,lastyear,firstage,lastage); 
  3darray SurveyWeights(1,nsurveys,firstyear,lastyear,firstage,lastage); 
  3darray CalcSurveyBiomassProportion(1,nsurveys,firstyear,lastyear,firstage,lastage);  
  3darray ObsSurveyBiomassProportion(1,nsurveys,firstyear,lastyear,firstage,lastage);  

  matrix SurveylnYeareffect(1,nsurveys,firstyear,lastyear);
  matrix ObsSurveyBiomass(1,nsurveys,firstyear,lastyear);
  matrix ObsSurveyTotnr(1,nsurveys,firstyear,lastyear);
  matrix CalcSurveyBiomass(1,nsurveys,firstyear,lastyear);
  matrix CalcSurveyTotnr(1,nsurveys,firstyear,lastyear);

  vector PropofFbeforeSpawning(minssbage,lastage);
  vector PropofMbeforeSpawning(minssbage,lastage);
  number RefSSB;
  number Minrelssb;
  number Maxrelssb; 



// Numbers related to HCR and stochasticity.  
  number CurrentTac;
  number TacLeft; 
  vector AssessmentErr(lastoptyear+1,lastyear);
  vector MeanSel(firstage,lastage);
 
  number CatchResolution; // Proportion 
  vector Likeliweights(1,10); 
  number sigmatotalcatch;
  vector LnLikelicomp(1,10);  // likelihood function

  number MaxFishMort;
  number largenumber;
  number LNMEANEFFORT;  // Temporary fix for likelihood component 9 (see evaluate_the_objective_function)
  objective_function_value LnLikely;





GLOBALS_SECTION
  #include <admodel.h>
  // Might have to calculate progsel every year if it is function of size.  
//Catchrule 1 TAC, 2 Tac in advisory year F there after, 3 IcodHCr
//4 F all years, 5 F with reduction below Btrigger, 6 IcodHCR with 
// reduction below Btrigger, 7 IcodHcr without stabilizer.
  ofstream all_mcmc;
  ofstream likelihood_mcmc;
  ofstream migration_mcmc;
  ofstream recruitment_mcmc;
  ofstream initpopulation_mcmc;
  ofstream assessmenterror_mcmc;
  ofstream estimatedselection_mcmc;
  ofstream parameter_mcmc;
  ofstream surveypower_mcmc;
  ofstream surveyq_mcmc;
  ofstream effort_mcmc;
  ofstream catch_mcmc;
  ofstream refbio1_mcmc;
  ofstream refbio2_mcmc;
  ofstream hcrrefbio_mcmc;
  ofstream hcrbproxy_mcmc;
  ofstream n3_mcmc;
  ofstream n1st_mcmc;
  ofstream f_mcmc;
  ofstream ssb_mcmc;
  ofstream ssbwerr_mcmc;
  ofstream relssb_mcmc;




// this list of files could be rduced somehow.  

TOP_OF_MAIN_SECTION
  gradient_structure::set_CMPDIF_BUFFER_SIZE(10000000);
  gradient_structure::set_GRADSTACK_BUFFER_SIZE(1000000);
  gradient_structure::set_MAX_NVAR_OFFSET(1500);
  gradient_structure::set_NUM_DEPENDENT_VARIABLES(1500);
  arrmblsize = 50000000;


RUNTIME_SECTION 
  convergence_criteria .1, .01, .0001, .0000001
  maximum_function_evaluations 800000
 

PRELIMINARY_CALCS_SECTION 
 logSigmaSurveybio = logminssbsurveyCV+0.2;  // Matters for IC
 AssessmentErrorRat = 0.6; // Changed from 0.3
 COUNTER = 0;
// Some dummy values 
// Parameters that are sometimes estimated.
  LastMisReportingYear = firstyear-1 ;  // Default value
  FishingYearCatch = -1; 
  Nhat = 0;
  RefSSB = 1000; 
  Maxrelssb = 1000; 
  Minrelssb = 0; 
  ObsCatchInNumbers = 0;
  AssessmentErr = 0;  // Set in sd_phase
  int i;
  for(i = 1; i < nsurveys; i++) logSigmaSurvey(i) = logminsurCV+0.2;  
  SurveyPower = 1; 
  for(i = 1; i <= nsurveys; i++) SurveyPowerest(i) = 1; 
  for(i = 1; i <= nsurveys; i++) surveybiopow(i) = 1; 

  if(INITCOND == 0) { // No pin file
//  logMoldest = log(Mdata(lastage));  // Start value.  Have to read Mdata first.   
//    Surveycorr = 0.6 01; 
    SigmaSurveypar = log(0.25);
    logMisreportingRatio = 0;

    SurveylnQ = -2;
    Catchlogitslope = 1;
    surveylogitslope = 2;
    surveylogitage50 = 1;
    Catchlogitage50 = 5;
    SigmaSurveypar = log(0.25);
    lnMeanRecr = 17;
    lnMeanInitialpop = 17;
    lnMeanEffort = -0;
    meanlogSurvivors = 15;
   }
   for( i = 1; i <= 4; i++) 
       if(SSBRecSwitches(i) < 0 || INITCOND==0)  estSSBRecParameters(i) = log(SSBRecParameters(i));
    for( i = 5; i <= 6; i++) 
       if(SSBRecSwitches(i) < 0 || INITCOND==0)  estSSBRecParameters(i) = SSBRecParameters(i);

   MaxFishMort = 1.2; // Maximum modelled fishing mortality ?
   largenumber = 10000;
   TimeDrift = 0;
   CatchWeights = SSBWeights = StockWeights = StockMaturity = 0;
   ObsCatchInNumbers  = CatchDiff =  -1;
   CatchIn1000tons = -1;

   PredictedRecruitment = RecruitmentResiduals = Recruitment =-1;
   for(i = 1; i <= nsurveys; i++ ) ObsSurveyNr(i) = 0.0; 
   cout << "ReadCatchandStockData " << endl;
   ReadCatchandStockData();
   cout << "ReadStockParameters " << endl;
   ReadStockParameters();
   cout << "ReadCatchParameters " << endl;
   ReadCatchParameters();
   cout << "ReadLikelihoodParameters " << endl;
   ReadLikelihoodParameters();
   cout << "ReadOutputParameters " << endl; 
   ReadOutputParameters();
   cout << " ReadPrognosis " << endl; 
    ReadPrognosis();
   cout << " ReadSurveyInfo " << endl;
    for(i = 1; i <= nsurveys; i++) 
     SurveyWeights(i) = StockWeights;  // Changed if weights are read from file.
   adstring parameterfilename;
   adstring datafilename; 
   adstring residualfilename;
   ifstream surveylistfile("SURVEYFILES.DAT");
   ofstream surveylogfile("survey.log");
   for( i = 1; i <= nsurveys; i++) {
      surveylistfile >>  parameterfilename;
      surveylistfile >>  datafilename;
      surveylistfile >>  residualfilename;
       ReadSurveyInfo(parameterfilename,datafilename,residualfilename,i,surveylogfile);
   }
//   WriteInputDataInMatrixForm();  // For user to look at.  

  for(i = firstyear; i <= lastdatayear ; i++) {
      CatchIn1000tons(i) = sum(elem_prod(CatchWeights(i),ObsCatchInNumbers(i)))/1.0e6;
      if(CatchIn1000tons(i) < 0) CatchIn1000tons(i) = TotCatchIn1000tons(i);
  }
// Save the input values when misreporting is included.  
  CatchIn1000tonsInput = CatchIn1000tons;
  ObsCatchInNumbersInput= ObsCatchInNumbers;
  likelihood_mcmc_lines = 0;
  migration_mcmc_lines = 0;
  recruitment_mcmc_lines = 0;
  initpopulation_mcmc_lines = 0;
  estimatedselection_mcmc_lines = 0;
  parameter_mcmc_lines = 0;
  surveypower_mcmc_lines = 0;
  surveyq_mcmc_lines = 0;
  effort_mcmc_lines = 0;
  catch_mcmc_lines = 0;
  assessmenterror_mcmc_lines = 0;
  refbio1_mcmc_lines = 0;
  refbio2_mcmc_lines = 0;
  hcrrefbio_mcmc_lines = 0;
  hcrbproxy_mcmc_lines = 0;
  n1st_mcmc_lines = 0;
  n3_mcmc_lines = 0;
  f_mcmc_lines = 0;
  ssb_mcmc_lines = 0;
  ssbwerr_mcmc_lines = 0;

  mcmc_iteration = 1;


PROCEDURE_SECTION
  ScaleCatches();  
  if(BackWards == 0){
    HistoricalSimulation();
  }
  if(BackWards == 1) {
     BackwardHistoricalSimulation();
     if(printPhase) cout << "current " << current_phase() << endl;
  }
  COUNTER = COUNTER + 1;
  //cout << "StartPrognosis " << endl;
  // SetPredValues();  // Set various sdreport objects from bw.tpl NPEL2007
  Prognosis();
  //cout << "FinishedProg " << endl;
  evaluate_the_objective_function();
  //cout  << "LnLikelicomp" <<  LnLikelicomp << endl;
//   cout << "Finished eval " << LnLikely << endl;
  if(mceval_phase()){
     write_mcmc();
     write_mcmc_all();
  }
REPORT_SECTION
   report << "LnLikelicomp" <<  LnLikelicomp << endl;
   report << "Surveylikelihood " << Surveylikelihood << endl;
   report << endl << "SigmaSurvey " << endl << SigmaSurvey << endl;
   int i,j;
   ofstream outfile("resultsbyyearandage");
   outfile << "year\tage\tN\tZ\tStockWeights\tM\tF\tCalcCno\tCatchWeights\tSSBWeights\tStockMaturity\tObsCno\tCatchDiff";
   for(i = 1; i <= nsurveys; i++) 
      outfile << "\tCalcSurveyNr" << i <<"\tObsSurveyNr" << i <<"\tSurveyResiduals" << i;
   outfile  << endl;


   int k;
   for(i = firstyear ; i <= lastyear; i++) {
     for(j = firstage; j <= lastage; j++) {
        outfile << i << "\t" << j << "\t" << N(i,j) << "\t" << Z(i,j) << "\t" << StockWeights(i,j) << "\t" << natM(i,j) << "\t" ;
       outfile << F(i,j) << "\t" << CalcCatchInNumbers(i,j) << "\t" << CatchWeights(i,j) << "\t" << SSBWeights(i,j) << "\t" <<  StockMaturity(i,j) << "\t";
       outfile << ObsCatchInNumbers(i,j) << "\t" << CatchDiff(i,j);
       for(k = 1; k<= nsurveys; k++) 
         outfile << "\t" <<  CalcSurveyNr(k,i,j) << "\t" << ObsSurveyNr(k,i,j) << "\t" << SurveyResiduals(k,i,j) ;
       outfile << endl;
    }
   }
   outfile.close() ;


   outfile.open("resultsbyyear"); 


// Recruitment is same value as first age but put on the year that the fish is born.  
  outfile << "year\tRefF\tCalcCatchIn1000tons\tCatchIn1000tons\tSpawningstock\tEggproduction\tCbioR\tRefBio1\tRefBio2\tPredictedRecruitment\tRecruitment\tN1st\tN3\tN6";
  for(i = 1; i <= nsurveys; i++) 
   outfile << "\tCalcSurveyBiomass"<<i<<"\tObsSurveyBiomass"<<i;
  outfile << endl;

  for(i = firstyear; i <= lastyear; i++) {
    outfile << i << "\t" <<  RefF(i) << "\t" <<  CalcCatchIn1000tons(i) << "\t" << CatchIn1000tons(i) << "\t" << Spawningstock(i) << "\t" << EggProduction(i) << "\t" << 
     CbioR(i) << "\t" << RefBio1(i) << "\t" << RefBio2(i) << "\t" << PredictedRecruitment(i) << "\t" << Recruitment(i) << "\t" << N(i,firstage) << "\t" << N(i,3) << "\t" << N(i,6) ;
    for(j = 1; j <= nsurveys; j++) 
      outfile << "\t" << CalcSurveyBiomass(j,i) << "\t" << ObsSurveyBiomass(j,i); 
    outfile  << endl;
   }

   outfile.close(); 

   outfile.open("resultsbyage");
 
  outfile << "age\tmeansel\tprogsel\tSigmaC";
  for(i = 1; i <= nsurveys; i++) 
    outfile << "\tSigmaSurvey" << i << "\tSurveylnQ" << i << "\tSurveyPower" << i;
  outfile << endl;

  for(i = firstage; i <= lastage; i++) {
    outfile << i << "\t" <<  meansel(i) << "\t" << progsel(i) << "\t" << SigmaC(i);
    for(j = 1; j <= nsurveys; j++){ 
       if(i >= surveyfirstage(j) | i <= surveylastage(j)) 
         outfile << "\t" <<  SigmaSurvey(j,i) << "\t" << mfexp(SurveylnQ(j,i)) << "\t" << SurveyPower(j,i); 
       else 
         outfile << "\t-1\t-1\t-1"; 
     }
    outfile << endl;

  }
  outfile.close();

  
  if(BackWards == 0) { // Print out F of oldest.  
     ofstream Ffile("Foldest.dat");
     dvar_vector Foldest(firstyear,lastdatayear);
     for(i = firstyear; i <=lastdatayear ; i++) Foldest(i) = F(i,lastage);
     Ffile << Foldest ;
     Ffile.close();
   }


// ****************************************************
// Migrations not included here but could be added as mig ratios
// Look at plus group in terminal year.  
 
FUNCTION void BackwardHistoricalSimulation()
  int i,year,age;
  int trend = 0;  // Trend or shift in certain year.  
  if(trend == 1) {
    TimeDrift(firstyear) = 0; 
    for(year = firstyear+1; year <= lastoptyear-5 ;year++)     
      TimeDrift(year) = TimeDrift(year-1) +  estSSBRecParameters(6); 
// Stop trend
    for(year = lastoptyear-4; year <= lastyear ;year++)     
      TimeDrift(year) = TimeDrift(year-1); 
 }
 if(trend == 0)  { // shift 1985
    for(year = firstyear+1; year <= prodchangeyear ;year++)     
      TimeDrift(year) = 0;
    for(year = prodchangeyear+1 ; year <= lastyear ; year++) 
      TimeDrift(year) =  estSSBRecParameters(6);
 }
 dvariable Nnew,Nold;
// Question about using N from the separable model.  This code is only for plus group.  
  int HistoricalAssessment = 1;
  dvariable FixNold = 100;  // Min left .  
  N = 0;
  dvar_vector Foldest(firstyear,lastdatayear);
  Foldest  = Foldestinp*mfexp(logFoldestmult);
  for(age = firstestage; age < lastage; age++) 
    N(lastoptyear+1,age) = mfexp(meanlogSurvivors+logSurvivors(age));
  CalcNaturalMortality1(lastoptyear);
  N(lastoptyear+1,lastage) =  (ObsCatchInNumbers(lastoptyear,lastage)/(1-exp(-Foldest(lastoptyear)-natM(lastoptyear,lastage)))*(Foldest(lastoptyear)+natM(lastoptyear,lastage))/Foldest(lastoptyear)+FixNold)*exp(-Foldest(lastoptyear)-natM(lastoptyear,lastage));
  for(year = lastoptyear; year >=  firstyear; year-- ) {
    CalcNaturalMortality1(year);
    N(year,lastage) = ObsCatchInNumbers(year,lastage)/(1-exp(-Foldest(year)-natM(year,lastage)))*(Foldest(year)+natM(year,lastage))/Foldest(year)+FixNold;
    N(year,lastage-1) = ObsCatchInNumbers(year,lastage-1)/(1-exp(-Foldest(year)-natM(year,lastage-1)))*(Foldest(year)+natM(year,lastage-1))/Foldest(year)+FixNold;  
  //New, 1 might have to be fixed.  
    for(age = firstcatchage; age <= lastage - 2; age++) 
      N(year,age) =  (N(year+1,age+1)*exp(natM(year,age)/2)+ObsCatchInNumbers(year,age))*exp(natM(year,age)/2);
    for(age = firstage; age < firstcatchage; age++) 
      N(year,age) = N(year+1,age+1)*exp(natM(year,age));
    // mean of last 4 ages
  }
  for(year = firstyear; year <= lastoptyear; year++) {
     for(age = firstage; age < lastage-1; age++) {
       Z(year,age) = -log(N(year+1,age+1)/N(year,age));  
       F(year,age) = Z(year,age) - natM(year,age);
     }
     F(year,lastage) = F(year,lastage-1) = Foldest(year);
     Z(year,lastage) = Foldest(year) + natM(year,lastage);
     Z(year,lastage-1) = Foldest(year) + natM(year,lastage-1);
     CalcCatchInNumbers(year)=elem_prod(elem_div(F(year),Z(year)),elem_prod((1.-mfexp(-Z(year))),N(year)));
     CalcCatchIn1000tons(year) = sum(elem_prod(CalcCatchInNumbers(year),CatchWeights(year)))/1.0e6;
//     CalcPredationNumbers(year)=elem_prod(elem_div(natM(year),Z(year)),elem_prod((1.-mfexp(-Z(year))),N(year)));
//     CalcPredationIn1000tons(year) = sum(elem_prod(CalcPredationNumbers(year),StockWeights(year)))/1.0e6;
     PredictSSB(year);
     PredictedRecruitment(year) = PredictRecruitment(year);
     if(year >= firstyear+firstage)
       Recruitment(year-firstage) = N(year,firstage); 

  }
// Calculate reference biomasses, mean selection, selection last 5 years etc.  
// The switch Historical Assessment is to have meansel and progsel calculated first.  
  CalcRefValues(firstyear,lastoptyear,HistoricalAssessment);   
   if(recrdatadelay > 0) {     
      for(year = lastoptyear-recrdatadelay+1; year <= lastoptyear; year++){
          PredictedRecruitment(year) = PredictRecruitment(year);
          Recruitment(year) = PredictedRecruitment(year);
      }
    }
    Recruitment(lastoptyear-firstage+1) = N(lastoptyear+1,firstage);
    if(firstage > 1)
       for(year = lastoptyear -firstage+2; year <= lastoptyear; year++) 
         Recruitment(year) = PredictedRecruitment(year);
 
//**********************************************************


FUNCTION void HistoricalSimulation()
  int year,i;
  int trend = 0;  // Trend or shift in 1985.  
  if(trend == 1) {
    TimeDrift(firstyear) = 0; 
    for(year = firstyear+1; year <= lastoptyear-5 ;year++)     
      TimeDrift(year) = TimeDrift(year-1) +  estSSBRecParameters(6); 
// Stop trend
    for(year = lastoptyear-4; year <= lastyear ;year++)     
      TimeDrift(year) = TimeDrift(year-1); 
 }
 if(trend == 0)  { // shift certain year
    for(year = firstyear+1; year <= prodchangeyear ;year++)     
      TimeDrift(year) = 0;
    for(year = prodchangeyear+1 ; year <= lastyear ; year++) 
      TimeDrift(year) =  estSSBRecParameters(6);
 }



  int HistoricalAssessment = 1;
  N = 0;
// Migrations are not included in prognosis in retros.  
  for(i = 1; i <= MigrationNumbers ; i++) 
    if(int(MigrationYears(i)) >= firstyear & int(MigrationYears(i)) <= lastoptyear & 
      int(MigrationAges(i)) >= firstage  & int(MigrationAges(i)) <= lastage)
      N(int(MigrationYears(i)),int(MigrationAges(i))) +=mfexp(lnMigrationAbundance(i));
  for(year = firstyear; year <=  lastoptyear-recrdatadelay+firstage; year++ ) { 
    N(year,firstage) += mfexp(lnMeanRecr+lnRecr(year));
    if(year - firstage >= firstyear) 
        Recruitment(year-firstage) = N(year,firstage);
   }

   for(i = firstage+1; i <= lastage; i++) 
     N(firstyear,i) = mfexp(lnMeanInitialpop+lnInitialpop(i));
  for(year = firstyear; year <= lastoptyear ;year++){
    CalcNaturalMortality1(year);
 
// The user must now check that only one of the values catchlogitphase,
// estselphase and catchlogitsizephase is larger than 0.  
    if(catchlogitphase > 0) 
       CalcFishingMortality1a(year);
    if(estselphase > 0)
       CalcFishingMortality1b(year);
    if(catchlogitsizephase > 0)
       CalcFishingMortality1c(year);

     


    Z(year) = F(year) + natM(year) ;
    if(year > lastoptyear-recrdatadelay+firstage) {
       PredictSSB(year-firstage);
       PredictedRecruitment(year-firstage) = PredictRecruitment(year-firstage);
       Recruitment(year-firstage) = PredictedRecruitment(year-firstage);
       N(year,firstage) = PredictedRecruitment(year-firstage);
    }
    CalcCatchInNumbers(year)=elem_prod(elem_div(F(year),Z(year)),elem_prod((1.-mfexp(-Z(year))),N(year)));
    CalcCatchIn1000tons(year) = sum(elem_prod(CalcCatchInNumbers(year),CatchWeights(year)))/1.0e6;
    CalcNextYearsN(year);
   }
// Calculate reference biomasses, mean selection, selection last 5 years etc.  
// The switch Historical Assessment is to have meansel and progsel calculated first.  
 
   CalcRefValues(firstyear,lastoptyear,HistoricalAssessment);  
   if(recrdatadelay > 0) {     
      for(year = lastoptyear-recrdatadelay+1; year <= lastoptyear; year++){
          PredictedRecruitment(year) = PredictRecruitment(year);
          Recruitment(year) = PredictedRecruitment(year);
      }
    }

    
// *****************************************************



//Biorule always based on biomass in the beginning of the Ass year
//If ProxyAge == 0 use SSB as proxy
// If ProxyAge > 0 use StockWeights, CatchWeights if it is less than 0
// IceFishYear if september 1st - aug 31 is the fishing year.

FUNCTION void BioRatioHockeystick(int yr)
// Bases advice on stock biomass in the beginning of assessment year.  
   int age;
// Need refage and proxyage
// if SSB might also use Bproxy.  Currently only SSB is allowed as trigger in
// size based models.  
   if(HCRBproxyAge == 0  || AgeModel== 0) {
      HCRBproxy(yr) = 0;
      for(age = minssbage; age <= lastage; age++)
      HCRBproxy(yr) += N(yr,age)*SSBWeights(yr,age)*StockMaturity(yr,age)*
     mfexp(-(natM(yr-1,age)*PropofMbeforeSpawning(age)+F(yr-1,age)*PropofFbeforeSpawning(age)))/1e6; 
   }
   if(HCRBproxyAge > 0)
      HCRBproxy(yr) = sum(elem_prod(N(yr)(HCRBproxyAge,lastage),StockWeights(yr)(HCRBproxyAge,lastage)))/1e6;
   if(HCRBproxyAge < 0)
      HCRBproxy(yr) = sum(elem_prod(N(yr)(-HCRBproxyAge,lastage),CatchWeights(yr)(-HCRBproxyAge,lastage)))/1e6;
    if(AgeModel == 1) {
      if(HCRrefAge > 0)
        HCRrefbio(yr) = sum(elem_prod(N(yr)(HCRrefAge,lastage),StockWeights(yr)(HCRrefAge,lastage)))/1e6;
     if(HCRrefAge < 0)
        HCRrefbio(yr) = sum(elem_prod(N(yr)(-HCRrefAge,lastage),CatchWeights(yr)(-HCRrefAge,lastage)))/1e6;     
   }
   if(AgeModel==0)  // Length model haddock
      HCRrefbio(yr) =  sum(elem_prod(N(yr),elem_prod(StockWeights(yr),wtsel(StockWeights(yr),HCRreflebreak))))/1e6;
      
   dvariable ratio = mfexp(log(HCRBproxy(yr))+AssessmentErr(yr))/Btrigger;
   ratio = SmoothDamper(ratio,1.0,0.0);  // ratio max 1  do not need the smooth version.  
   dvariable Hratio = ratio*HarvestRatio; 
   dvariable LastYTacRat = LastYearsTacRatio*ratio; // Gradual  like saithe


   dvariable AnnualCatch;  
   dvariable mincatch = 0.0;
   dvariable refcatch = Hratio*mfexp(log(HCRrefbio(yr))+AssessmentErr(yr));
   dvariable Catch = LastYTacRat*CurrentTac +  (1-LastYTacRat)*refcatch;  
   Catch = SmoothDamper(Catch,MaxHarvestRatio*HCRrefbio(yr),mincatch);
   if(IceFishYear) {
      AnnualCatch =  TacLeft + Catch/3; 
      AnnualCatch = SmoothDamper(AnnualCatch,MaxHarvestRatio*HCRrefbio(yr),mincatch); 
      TacLeft = Catch*2/3;
      FishingYearCatch(yr) = Catch;  // FishingYearCatch(2018) is 2018/2018
   }
   if(!IceFishYear)
       AnnualCatch =  CurrentTac;

   CurrentTac = Catch;  
   AnnualCatch = SmoothDamper(AnnualCatch,MaxHarvestRatio*HCRrefbio(yr),mincatch);
   ProgF(yr) = FishmortFromCatch(AnnualCatch*1e6,N(yr),CatchWeights(yr),progsel,natM(yr));


FUNCTION void SetWeightErrorsHad() // For the haddock model.  
// Could est the starting point based on current value i.e negative
// Here it only sets weighterr.  

  random_number_generator r(COUNTER+10000);  // To avoid correlation
  random_number_generator r1(COUNTER+10001);  // To avoid correlation
  random_number_generator r2(COUNTER+10002);  // To avoid correlation
  random_number_generator r3(COUNTER+10003);  // To avoid correlation
  
  
  dvariable ratio = sqrt(1-weightcorr*weightcorr);
  int i;
  weighterr = recrweighterr = catchweighterr = selerr =  0; 

 // if(mceval_phase()|| mceval_phase()) { not needed set outside program
    for(i = lastoptyear+2; i <= lastyear; i++)
      weighterr(i) = randn(r);
    weighterr(lastoptyear+2) = weighterr(lastoptyear+2)/ratio;
    for(i = lastoptyear+2; i <= lastyear; i++)
      weighterr(i) = weightcorr*weighterr(i-1)+weighterr(i);
    weighterr=weighterr*weightcv*ratio;

  dvariable recrweightcorr = 0.3;
  dvariable recrweightcv = 0.12;
  ratio = sqrt(1-recrweightcorr*recrweightcorr);
  for(i = lastoptyear+2; i <= lastyear; i++)
      recrweighterr(i) = randn(r1);
    recrweighterr(lastoptyear+2) = recrweighterr(lastoptyear+2)/ratio;
    for(i = lastoptyear+2; i <= lastyear; i++)
      recrweighterr(i) = recrweightcorr*recrweighterr(i-1)+recrweighterr(i);
    recrweighterr=recrweighterr*recrweightcv*ratio;

 dvariable catchweightcorr = 0.3;
 dvariable catchweightcv = 0.12;
 ratio = sqrt(1-catchweightcorr*catchweightcorr);
 for(i = lastoptyear+1; i <= lastyear; i++)
      catchweighterr(i) = randn(r2);
    catchweighterr(lastoptyear+1) = catchweighterr(lastoptyear+1)/ratio;
    for(i = lastoptyear+2; i <= lastyear; i++)
      catchweighterr(i) = catchweightcorr*catchweighterr(i-1)+catchweighterr(i);
    catchweighterr=catchweighterr*catchweightcv*ratio;

 dvariable selcv = 0.2; // Later from file
 dvariable selcorr = 0.9; //Later from file

 ratio = sqrt(1-selcorr*selcorr);
 for(i = lastoptyear+1; i <= lastyear; i++)
   selerr(i) = randn(r3);
   selerr(lastoptyear+1) = selerr(lastoptyear+1)/ratio;
   for(i = lastoptyear+2; i <= lastyear; i++)
     selerr(i) = selcorr*selerr(i-1)+selerr(i);
   selerr=selerr*selcv*ratio;



FUNCTION void SetAssessmentErr()
  random_number_generator r(COUNTER+20000);  // To avoid correlation with recrerr
  dvariable ratio = sqrt(1-Assessmentcorr*Assessmentcorr);
  int i;
  for(i = lastoptyear+1; i <= lastyear; i++)
      AssessmentErr(i) = randn(r);
  AssessmentErr(lastoptyear+1) = log(EstimatedAssYrSSB/AssYearSSB())/ratio/Assessmentcv*0.45; //AssessmentErrorRat ; Highest value that the model works on. 
//  AssessmentErr(lastoptyear+1) = log(EstimatedAssYrSSB/AssYearSSB())/ratio/Assessmentcv; //AssessmentErrorRat ; Highest value that the model works on.  
  for(i = lastoptyear+2; i <= lastyear; i++)
    AssessmentErr(i) = Assessmentcorr*AssessmentErr(i-1)+AssessmentErr(i);
  AssessmentErr=AssessmentErr*ratio;
  for(i = lastoptyear+1; i <= lastyear; i++){
    if(AssessmentErr(i) > 2) AssessmentErr(i) = 2;  //Max asserr 
    if(AssessmentErr(i) < -2) AssessmentErr(i) = -2;  //-2 or 21
  }
  AssessmentErr=AssessmentErr*Assessmentcv      ;

// Set Recruitment and assessment error 


FUNCTION void Prognosis()


  dvariable ratio;
  dvariable wfrat = 0; // convert weighted and unweighted F.  

  int lastprogyear; // To reduce computer time in early part of simulation
  if ( current_phase() < 4) 
    lastprogyear = lastoptyear + 2; 
  else 
    lastprogyear = lastyear;
  CurrentTac= CurrentTacInput; // For catch rule start value.  
  TacLeft = TacLeftInput;  // For catch rule start value.  
  int i;
//  UpdateWeightsAndMaturity() has to be called every year if 
//  Weights are linked to stocksize.
   if(mceval_phase()){
     if(DensDep==0) UpdateWeightsAndMaturity(); // Have to do this every year with density dependence
     SetAssessmentErr();
//   N(lastoptyear+1)=mfexp(log(N(lastoptyear+1))-AssessmentErr(lastoptyear+1));
     if(DensDep == 1) SetWeightErrorsHad();
   }
// Set Assessment error 
  random_number_generator r(COUNTER) ;  //stoch
  dvar_vector recrerr(lastoptyear+1,lastyear);
  recrerr = 0;
// mceval_phase does not work
 if(mceval_phase()) {
    dvariable Recrcorr1 = Recrcorr;
    if(SSBRecSwitches[4] > 0) Recrcorr1 = mfexp(estSSBRecParameters[4]);
    dvariable recrratio = sqrt(1-Recrcorr1*Recrcorr1);
    for(i = lastoptyear+1; i <= lastyear; i++)
     recrerr(i) = randn(r);
    for(i = lastoptyear+2; i <= lastyear; i++)
      recrerr(i) = Recrcorr1*recrerr(i-1)+recrerr(i);
    recrerr=recrerr*recrratio;
// Addition September 2016 HB get rid of outliers
    dvariable MinMaxRec = 2.0;  // Later from files
    for(i = lastoptyear+2; i <= lastyear; i++) {
      if(recrerr(i) > MinMaxRec) recrerr(i) = MinMaxRec; 
      if(recrerr(i) < -MinMaxRec) recrerr(i) = -MinMaxRec;
    }
  }     

  dvariable Catch;
  for(i = lastoptyear+1; i <= lastprogyear; i++) {
    if(mceval_phase() && DensDep == 1) UpdateWeightandMaturityHad(i); // not done in optimization.  
    CalcNaturalMortality1(i); 
    //CalcRefValues(i,i,0);  // can not be called here for some reason
    if(firstcatchage == 0){ // Have to do it here if 0group is caught.  
       PredictSSB(i);  // Then SSB must be at the start of the year.
       PredictedRecruitment(i) = mfexp(log(PredictRecruitment(i))+recrerr(i)*SigmaSSBRec(i));
       N(i,firstage) = PredictedRecruitment(i-firstage);
    } 

    // Specify TAC.  Short term prognosis only 
    if(CatchRule == 1 || i <= lastdatayear) {  
        if(current_phase() < 4) // have to start with F for convergence
           ProgF(i) = 0.5;
        else {
          if(i > lastdatayear) 
            Catch = FutureForCatch(i)*1e6; // right units for the program (kgs)
          else 
            Catch = CatchIn1000tons(i)*1e6;
	  ProgF(i) = FishmortFromCatch(Catch,N(i),CatchWeights(i),progsel,natM(i));
        }
    }

//  Fishing mortality but TAC for assessment year.  Usually used during optimization.   
    if(CatchRule == 2 & i > lastdatayear){
      if(i == (lastdatayear+1)) {// Tac in assessment year. 
         if(current_phase() <= 3) // have to start with F for convergence
           ProgF(i) = 0.3;
	 if(current_phase() > 3) {
	      ProgF(i) = FishmortFromCatch(FutureForCatch(i)*1e6,N(i),CatchWeights(i),progsel,natM(i));
	 }	   
	      
      }
      else {      
        if(WeightedF == 1) {
	    F(i) = FutureForCatch(i)*progsel;
            wfrat = CalcWeightedMeanF(F(i),N(i))/FutureForCatch(i);//+1e-8
	    ProgF(i) = mfexp(log(FutureForCatch(i)/wfrat)+AssessmentErr(i));
        }
        else ProgF(i) = mfexp(log(FutureForCatch(i))+AssessmentErr(i));
      }
    }
// End of catchrule 2  
//  Fishing mortality for all years.  Problems with tac constraint in estimation.  
 
    if(CatchRule == 4){
        ProgF(i) = mfexp(log(FutureForCatch(i))+AssessmentErr(i));
    }

//  Fishing mortality multplier.  F reduces below Btrigger defined from the assessment year.
//  Not a very useful rule.  
    if(CatchRule == 5 & i > lastdatayear){
      if(i == lastdatayear+1) {// Tac in assessment year. 
         if(current_phase() <= 3) // have to start with F for convergence
           ProgF(i) = 0.3;
	 if(current_phase() > 3) 
	      ProgF(i) = FishmortFromCatch(FutureForCatch(i)*1e6,N(i),CatchWeights(i),progsel,natM(i));
      }
      else {
        SpawningstockWithErr(i-1) =  mfexp(log(Spawningstock(i-1))+AssessmentErr(i)*AssessmentErrorRat);
        ratio = mfexp(log(Spawningstock(i-1))+AssessmentErr(i)*AssessmentErrorRat)/Btrigger; //changed october 19th.  
	ratio = SmoothDamper(ratio,1.0,0.0);  
        ProgF(i) = mfexp(log(FutureForCatch(i)*ratio)+AssessmentErr(i));
      }
    }
//  End of catchrule 5.

//  Biomass rules.
    if(CatchRule == 3 & i > lastdatayear)
      BioRatioHockeystick(i);

// Frule done the proper way i.e TAC prediction through the assessment year.  
    if(CatchRule == 10 & i > lastdatayear) {
      if(i < lastyear) SingleTriggerHCR(i) ;
      if(i == lastyear) ProgF(i) = FishmortFromCatch(CalcCatchIn1000tons(i)*1e6,N(i),CatchWeights(i),progsel,natM(i));
    }


    F(i) = ProgF(i)*progsel; 
    Z(i) = F(i) + natM(i);
    if(firstcatchage > 0 & i > (lastoptyear+firstage-recrdatadelay) ) {
	 PredictSSB(i);
         PredictedRecruitment(i) = mfexp(log(PredictRecruitment(i))+recrerr(i)*SigmaSSBRec(i));
         Recruitment(i) = PredictedRecruitment(i);
  	 N(i,firstage) = PredictedRecruitment(i-firstage);
    }
     if(firstcatchage > 0 & i <= (lastoptyear+firstage-recrdatadelay) ){
	 PredictSSB(i);
         PredictedRecruitment(i) = mfexp(log(PredictRecruitment(i))+recrerr(i)*SigmaSSBRec(i));
         Recruitment(i) = PredictedRecruitment(i);
    }
    CalcCatchInNumbers(i)=elem_prod(elem_div(F(i),Z(i)),elem_prod((1.-mfexp(-Z(i))),N(i)));
    CalcCatchIn1000tons(i) = sum(elem_prod(CalcCatchInNumbers(i),CatchWeights(i)))/1.0e6;
    CalcNextYearsN(i);
    CalcRefValues(i,i,0); // called again as some values change with catch 
  } 
 
// End of rule 10 

// ******************************************************************
// Objective function; 
// This function calls a set of routines that do the job.  
// Likelihood(1) Catch in numbers
// Likelihood(2) Catch in tonnes
// Likelihood(3) SSB_recruitment loglikeli
// Likelihood(4) Standard survey likelihood 


FUNCTION void evaluate_the_objective_function()
   LnLikelicomp = 0;
   dvar_vector tmpsurveylikelihood(1,2); // for biomass survey likelihood that returns two comp i.e biomass and prop.  
   int i,j;
   if(!BackWards) {
     LnLikelicomp(1) = Catch_loglikeliNocorr(); // No meaning for 

// Variations in Total catch  sigmatotalcatch is typically low to 
// follow catch well. 
   if(!BackWards) 
     LnLikelicomp(2) = sum(square(log(CatchIn1000tons(firstyear,lastoptyear))
	-log(CalcCatchIn1000tons(firstyear,lastoptyear))))/
	 (2.*square(sigmatotalcatch))+ noptyears*log(sigmatotalcatch);
  }

  LnLikelicomp(3) = SSB_Recruitment_loglikeli(); 
  for(i = 1; i <= nsurveys; i++) {
      if(surveytype(i) == 1 ) {
        Surveylikelihood(i) = Survey_loglikeli1(i); // Store by survey
        LnLikelicomp(4) +=  Surveylikelihood(i);
      }
      if(surveytype(i) == 2 ) {
        tmpsurveylikelihood = Survey_loglikeli2(i); 
        Surveylikelihood(i)  = sum(tmpsurveylikelihood);
	LnLikelicomp(5) +=  tmpsurveylikelihood(1);  // Biomass
	LnLikelicomp(6) +=  tmpsurveylikelihood(2);  // Proportions 
      }
      if(surveytype(i) == 4) {
         Surveylikelihood(i) = SSB_Survey_loglikeli(i);	
	 LnLikelicomp(4) +=  Surveylikelihood(i); // Breyta?
      }
  }

  LnLikelicomp(8) = 0; 


//
  dvariable SigmaEffort = 0.5; 
  if(current_phase() < 5) LNMEANEFFORT = lnMeanEffort;
  else LnLikelicomp(9) = 0.5*square((lnMeanEffort- LNMEANEFFORT)/SigmaEffort);// Help toward the correct solution ?? 5 is really enough.   

  LnLikely = 0;
//  cout << "Lnlikelicomp " << LnLikelicomp << endl;
  for(i = 1; i <= 10; i++) 
     LnLikely += LnLikelicomp(i)*Likeliweights(i);
//  cout << "totalloglikeli " << LnLikely << endl;


//**************************************************************
// Calculate N for next year based on Z. 
// N has been set to zero initially and += is because the migrations were 
// set in the beginning.  
 
FUNCTION void CalcNextYearsN(int year)
   int age;
   if(year < lastyear) {
     for (age = firstage;age < lastage; age++)
       N(year+1,age+1) += N(year,age)*mfexp(-Z(year,age));
      if(plusgroup == 1)  N(year+1,lastage) += N(year,lastage)*mfexp(-Z(year,lastage));
   }




// ****************************************************
// Likelihood function for Catch in numbers.  
// No correlation between age groups.  

FUNCTION dvariable Catch_loglikeliNocorr()
 dvariable value = 0;
 dvariable totalnumber = 0;
 int i,j;
 for(i = firstcatchage;i <= lastage; i++) 
    SigmaC(i) = SigmaCinp(i)*mfexp(logSigmaCmultiplier);
  if(CatchRobust == 0) { // Not use robust function for catch
    for(i = firstyear; i <=  lastoptyear; i++) {
     totalnumber = 0;
     for( j = firstcatchage; j <= lastage; j++)
       totalnumber+=ObsCatchInNumbers(i,j);
     for( j = firstcatchage; j <= lastage; j++) {
         if(ObsCatchInNumbers(i,j) >= -1) {
           CatchDiff(i,j) = log( (ObsCatchInNumbers(i,j)+CatchResolution*totalnumber)/
           (CalcCatchInNumbers(i,j)+CatchResolution*totalnumber) );
           value += 0.5*square(CatchDiff(i,j)/SigmaC(j)) + log(SigmaC(j));
         }
      } 
    }
  }

  if(CatchRobust == 1) {
    dvariable diff2;
    dvariable v_hat;
     dvariable e = exp(1);
    dvariable pcon = 0.15;
    dvariable b = 2*pcon/(1.772454*e);
    for(i = firstyear; i <=  lastoptyear; i++) {
      for( j = firstcatchage; j <= lastage; j++) {
        if(ObsCatchInNumbers(i,j) >= 0) {
          CatchDiff(i,j) = log( (ObsCatchInNumbers(i,j)+CatchResolution)/(CalcCatchInNumbers(i,j)+CatchResolution) );
          diff2 = square(CatchDiff(i,j));
          v_hat = square(SigmaC(j));
          value += log(v_hat) - log((1-pcon)*exp(-diff2/(2*v_hat))+b/(1.+square(diff2/(square(e)*v_hat))));
       }
      }
    }
   }


 return value;



// ***************************************************************************
// Predicts survey abundance by a power model an possibly year effect.  
FUNCTION void PredictSurveyAbundance1(int surveynr)

// Survey indices Look if surveylastyear > nyrs Add time of year that survey takes place.
  int finalyear =  min(lastoptyear+surveytimefromlastyear(surveynr),surveylastyear(surveynr));
  dvariable value = 0;
   SurveyPower(surveynr)(surveyfirstage(surveynr),surveylastage(surveynr)) = 1;  // Changed for youngest fish.  
  int i;
  int j;
 
// guess  when SurveylnQ is not active.  power is 1 in that case.  
// not use the survey further than nyrs+1 or even nyrs in some cases
// if survey is not available at the time of assessment. The division 
// by  surveylastyear-surveyfirstyear+1 is not exact if there are missing 
// years in between but gives good enough results as initial guess.  
    //int INITCOND = 0;  // Lagaði 29 des 2015
    if(!active(SurveylnQest ) && INITCOND == 0 ) {  
      for(j = surveyfirstage(surveynr); j <= surveylastage(surveynr); j++){
        SurveylnQ(surveynr,j) = 0; 
        for(i = surveyfirstyear(surveynr); i <= finalyear; i++) {
          if(ObsSurveyNr(surveynr,i,j) != -1) 
            SurveylnQ(surveynr,j) += log((ObsSurveyNr(surveynr,i,j)+SurveyResolution(surveynr,j))/N(i,j));
        }
     }
     SurveylnQ(surveynr)/= (finalyear-surveyfirstyear(surveynr)+1);
     SurveylnQest(surveynr) = SurveylnQ(surveynr)(SurveylnQest(surveynr).indexmin(),SurveylnQest(surveynr).indexmax());
 }
 else if(surveylogitphase(surveynr) > 0 ) {  // Then only one  survey lnq is estimated, multiplied by a logit function.  
   for( j  = surveyfirstage(surveynr); j <= surveylastage(surveynr); j++)
     SurveylnQ(surveynr,j) = SurveylnQest(surveynr,surveyfirstage(surveynr))-log((1+mfexp(surveylogitslope(surveynr)*(surveylogitage50(surveynr) - j))));
  }
  else {
   for( j  = surveyfirstage(surveynr); j <= surveyfirstagewithfullcatchability(surveynr); j++)
     SurveylnQ(surveynr,j) = SurveylnQest(surveynr,j);
   for( j  = surveyfirstagewithfullcatchability(surveynr); j <= surveylastage(surveynr); j++)
     SurveylnQ(surveynr,j) = SurveylnQest(surveynr,surveyfirstagewithfullcatchability(surveynr));
   for(j = surveyfirstage(surveynr); j <  surveyfirstagewithconstantcatchability(surveynr); j++)
    SurveyPower(surveynr,j) = SurveyPowerest(surveynr,j);

  }
  dvariable pZ;
  for( i = surveyfirstyear(surveynr); i <= finalyear; i++) {
    for(j = surveyfirstage(surveynr); j <= surveylastage(surveynr); j++) {
      pZ = SurveyPropOfF(surveynr)*F(i,j)+SurveyPropOfM(surveynr)*natM(i,j);
      CalcSurveyNr(surveynr,i,j) = mfexp(log(N(i,j)*mfexp(-pZ))*SurveyPower(surveynr,j)+SurveylnQ(surveynr,j)
      +SurveylnYeareffect(surveynr,i));
    }
  }
  // Here biomass might be put on the total power that option might be available in some version (Faroes).  
  for(i = surveyfirstyear(surveynr); i <= finalyear ; i++) {
    CalcSurveyBiomass(surveynr,i) = sum(elem_prod(CalcSurveyNr(surveynr,i),SurveyWeights(surveynr,i)));
    CalcSurveyTotnr(surveynr,i) = sum(CalcSurveyNr(surveynr,i));
  }

  for(i = surveyfirstyear(surveynr); i <= finalyear ; i++) {
    for(j =  surveyfirstage(surveynr); j <= surveylastage(surveynr); j++) 
       CalcSurveyBiomassProportion(surveynr,i,j) = CalcSurveyNr(surveynr,i,j)*SurveyWeights(surveynr,i,j)/CalcSurveyBiomass(surveynr,i);
  }

// Correct for power on biomass.  
   if(active(surveybiopow(surveynr)) && surveybiopowphase(surveynr) > 0) {
    dvariable scaler;
    for(i = surveyfirstyear(surveynr); i <= finalyear ; i++) {
      scaler = pow(CalcSurveyBiomass(surveynr,i),surveybiopow(surveynr))/CalcSurveyBiomass(surveynr,i);
      CalcSurveyBiomass(surveynr,i) *= scaler;
      for(j =  surveyfirstage(surveynr); j <= surveylastage(surveynr); j++) 
         CalcSurveyNr(surveynr,i,j) *= scaler;
    }
  }

// Matrix to invert has to start at 1 (or it was at least that way)
FUNCTION  dvariable Survey_loglikeli1(int surveynr)
  PredictSurveyAbundance1(surveynr); 
  dvar_matrix Scorrmat(1,surveylastage(surveynr)-surveyfirstage(surveynr)+1,1,surveylastage(surveynr)-surveyfirstage(surveynr)+1);
  dvar_vector SurveyDiff(1,surveylastage(surveynr)-surveyfirstage(surveynr)+1);
  dvariable SurveylnDet;  
// Quickfix that might have to be corrected later as we might not want survey corr  for recruitment survey.  
  dvariable Scorr = Surveycorr(surveynr);

  dvariable value = 0;
  int i; 
  int j; 
  int k; 
  int finalyear =  min(lastoptyear+surveytimefromlastyear(surveynr),surveylastyear(surveynr));
  for(i = surveyfirstage(surveynr); i <= surveylastage(surveynr); i++) 
    if(active(logSigmaSurvey)) 
       SigmaSurvey(surveynr,i) = mfexp(logSigmaSurvey(surveynr,i)); // VPA
    else 
       SigmaSurvey(surveynr,i) = SigmaSurveyInp(surveynr,i)*mfexp(SigmaSurveypar(surveynr));

  for(j = 1; j <= surveylastage(surveynr)-surveyfirstage(surveynr)+1; j++) {  
     Scorrmat(j,j) = 1.0*square(SigmaSurvey(surveynr,j+surveyfirstage(surveynr)-1));
     for(k = 1 ; k < j; k++) {
       Scorrmat(j,k) = pow(Scorr,j-k)*SigmaSurvey(surveynr,j+surveyfirstage(surveynr)-1)*SigmaSurvey(surveynr,k+surveyfirstage(surveynr)-1);
       Scorrmat(k,j) = Scorrmat(j,k);
     }
  }

  SurveylnDet = log(det(Scorrmat));
  Scorrmat = inv(Scorrmat);
  if(SurveyRobust == 0) {
    for( i = surveyfirstyear(surveynr); i <=  finalyear; i++) {
      for(j = surveyfirstage(surveynr); j <= surveylastage(surveynr); j++) {
        if(ObsSurveyNr(surveynr,i,j) != -1) {
          SurveyResiduals(surveynr,i,j) = log( (ObsSurveyNr(surveynr,i,j)+SurveyResolution(surveynr,j))/
	  (CalcSurveyNr(surveynr,i,j)+SurveyResolution(surveynr,j)) );
	  SurveyDiff(j-surveyfirstage(surveynr)+1) =  SurveyResiduals(surveynr,i,j);
        }
      }
      value  += 0.5*(SurveylnDet)+0.5*SurveyDiff*Scorrmat*SurveyDiff;
    }
  }
  if(SurveyRobust == 1) {  // multivariate version not ready.  
    dvariable diff2;
    dvariable v_hat;
     dvariable e = exp(1);
    dvariable pcon = 0.15;
    dvariable b = 2*pcon/(1.772454*e);
     for( i = surveyfirstyear(surveynr); i <=  finalyear; i++) {
      for(j = surveyfirstage(surveynr); j <= surveylastage(surveynr); j++) {
        if(ObsSurveyNr(surveynr,i,j) != -1) {
           SurveyResiduals(surveynr,i,j) = log( (ObsSurveyNr(surveynr,i,j)+SurveyResolution(surveynr,j))/
	  (CalcSurveyNr(surveynr,i,j)+SurveyResolution(surveynr,j)) );
          diff2 = square(SurveyResiduals(surveynr,i,j));
          v_hat = square(SigmaSurvey(surveynr,j));
          value += log(v_hat) - log((1-pcon)*exp(-diff2/(2*v_hat))+b/(1.+square(diff2/(square(e)*v_hat))));
        }
      }
    }
  }
  return value;
  




// Tuning with total biomass and proportion of biomass.  Not finished

//FUNCTION dvar_vector Survey_loglikeli2(int surveynr)
FUNCTION dvar_vector  Survey_loglikeli2(int surveynr)
  PredictSurveyAbundance1(surveynr); 
  dvar_matrix Scorrmat(1,surveylastage(surveynr)-surveyfirstage(surveynr)+1,1,surveylastage(surveynr)-surveyfirstage(surveynr)+1);
  dvar_vector SurveyDiff(1,surveylastage(surveynr)-surveyfirstage(surveynr)+1);
  dvariable SurveylnDet;  
  dvariable Scorr = Surveycorr(surveynr);

  dvar_vector value(1,2);
  value = 0;
  dvariable residual;
  dvariable surveybiosigma = mfexp(logSigmaSurveybio(surveynr));
  int i,j,k; 
  int finalyear =  min(lastoptyear+surveytimefromlastyear(surveynr),surveylastyear(surveynr));
  int minage = surveyfirstage(surveynr);
  int maxage =  surveylastage(surveynr);
  for(i = surveyfirstage(surveynr); i <= surveylastage(surveynr); i++) 
    if(active(logSigmaSurvey)) 
       SigmaSurvey(surveynr,i) = mfexp(logSigmaSurvey(surveynr,i)); // VPA
    else 
       SigmaSurvey(surveynr,i) = SigmaSurveyInp(surveynr,i)*mfexp(SigmaSurveypar(surveynr));
  for( i = surveyfirstyear(surveynr); i <= finalyear; i++) {
     if(ObsSurveyBiomass(surveynr,i) != -1) {
        residual = log( ObsSurveyBiomass(surveynr,i)/CalcSurveyBiomass(surveynr,i));
        value(1) += 0.5*square(residual/surveybiosigma) + log(surveybiosigma);
     }
  }

  for(j = 1; j <= surveylastage(surveynr)-surveyfirstage(surveynr)+1; j++) {  
     Scorrmat(j,j) = 1.0*square(SigmaSurvey(surveynr,j+surveyfirstage(surveynr)-1));
     for(k = 1 ; k < j; k++) {
       Scorrmat(j,k) = pow(Scorr,j-k)*SigmaSurvey(surveynr,j+surveyfirstage(surveynr)-1)*SigmaSurvey(surveynr,k+surveyfirstage(surveynr)-1);
       Scorrmat(k,j) = Scorrmat(j,k);
     }
  }
  SurveylnDet = log(det(Scorrmat));
  Scorrmat = inv(Scorrmat);

  for( i = surveyfirstyear(surveynr); i <=  finalyear; i++) {
    for(j = surveyfirstage(surveynr); j <= surveylastage(surveynr); j++) {
      if(ObsSurveyNr(surveynr,i,j) != -1) {
        SurveyResiduals(surveynr,i,j) = log( (ObsSurveyBiomassProportion(surveynr,i,j)+SurveyResolution(surveynr,j))/
      (CalcSurveyBiomassProportion(surveynr,i,j)+SurveyResolution(surveynr,j)) );
        SurveyDiff(j-surveyfirstage(surveynr)+1) =  SurveyResiduals(surveynr,i,j);
     }
   }
   value(2)  += 0.5*(SurveylnDet)+0.5*SurveyDiff*Scorrmat*SurveyDiff;
  }

  return value;
 
 
// Tuning with SSB biomass.  

FUNCTION dvariable SSB_Survey_loglikeli(int surveynr) 
//  dvariable surveybiosigma = 0.16;
  dvariable surveybiosigma = mfexp(logSigmaSurveybio(surveynr));
  dvariable value = 0;
  dvariable residual;
  int i; 
  int j;  
  int finalyear =  min(lastoptyear+surveytimefromlastyear(surveynr),surveylastyear(surveynr));
  SurveylnQ(surveynr,minsurveyfirstage) =  SurveylnQest(surveynr,minsurveyfirstage);
  // use firstage for SurveylnQ that is of course not age based.  
  for( i = surveyfirstyear(surveynr); i <= finalyear; i++) {
     CalcSurveyBiomass(surveynr,i) = mfexp(SurveylnQ(surveynr,minsurveyfirstage))*Spawningstock(i);
     if(ObsSurveyBiomass(surveynr,i) > 0) {
        residual = log( ObsSurveyBiomass(surveynr,i)/CalcSurveyBiomass(surveynr,i));
        value += 0.5*square(residual/surveybiosigma) + log(surveybiosigma);
     }
  }
 
  return value;
 

FUNCTION dvariable SSB_Recruitment_loglikeli();

  // logSSBmax is in reality 5 times  the  spawing stock giving 1/2 maximum recruitment if Beverton 
  // and holt.  Therefore logSSBmax/5 in the relationship. SSB and SigmaSSBRec have already been predicted 
  // when this function is called.  
  dvariable value = 0;
// to avoid numerical problems in Ricker function.  Might be skipped for 
// other SSB-recruitment functions as it takes time.  
  dvariable Spawncorr= mfexp(estSSBRecParameters(4));
  dvariable minrecruitment = 1.0;
  dvariable maxrecruitment = 1.0e9;
  int i = 0;
  int j = 0;
  int lastestrecyear= lastoptyear-recrdatadelay;
  int nestrecyears = lastestrecyear-firstyear+1;
  dvar_vector tmpRecresid(1, nestrecyears);
  dvar_matrix Spawncorrmat(1, nestrecyears,1, nestrecyears);
  dvariable SpawnlnDet;
  for(i = firstyear; i <= lastestrecyear; i++){
      PredictedRecruitment(i) = SmoothDamper(PredictRecruitment(i),maxrecruitment,minrecruitment);
      RecruitmentResiduals(i) = log(Recruitment(i)/PredictedRecruitment(i));
      tmpRecresid(i-firstyear+1) =   RecruitmentResiduals(i);
  }
// Put in timeseries might be made faster if SigmaSSBrec is constant  
  for(i = 1; i <=  nestrecyears; i++) {
     Spawncorrmat(i,i) = 1.0*square(SigmaSSBRec(i+firstyear-1));
     for(j = 1; j < i; j++) {
        Spawncorrmat(i,j) = pow(Spawncorr,i-j)*SigmaSSBRec(i+firstyear-1)*SigmaSSBRec(j+firstyear-1);
	Spawncorrmat(j,i) = Spawncorrmat(i,j);
     }
  } 
  SpawnlnDet = log(det(Spawncorrmat));
  Spawncorrmat = inv(Spawncorrmat);
  value  = 0.5*(SpawnlnDet)+0.5*tmpRecresid*Spawncorrmat*tmpRecresid;
  return(value);


FUNCTION dvariable SSB_Recruitment_loglikeliNocorr();

  // logSSBmax is in reality 5 times  the  spawing stock giving 1/2 maximum recruitment if Beverton 
  // and holt.  Therefore logSSBmax/5 in the relationship. SSB and SigmaSSBRec have already been predicted 
  // when this function is called.  
  dvariable value = 0;
// to avoid numerical problems in Ricker function.  Might be skipped for 
// other SSB-recruitment functions as it takes time.  
  dvariable minrecruitment = 1.0;
  dvariable maxrecruitment = 1.0e9;
  int i = 0;
  int j = 0;
  for(i = firstyear; i <= lastoptyear-recrdatadelay; i++){
      PredictedRecruitment(i) = SmoothDamper(PredictRecruitment(i),maxrecruitment,minrecruitment);
      RecruitmentResiduals(i) = log(Recruitment(i)/PredictedRecruitment(i));
  }
// Put in timeseries effect later.  
  for(i = firstyear; i <= lastoptyear-recrdatadelay; i++) 
      value += log(SigmaSSBRec(i))+0.5*(square(RecruitmentResiduals(i)/SigmaSSBRec(i)));
   return(value);


// Function that predicts recruitment in a gven year from spawning stock or other variables.  
FUNCTION dvariable PredictRecruitment(int year)

   dvariable value;
   dvariable Rmax = mfexp(estSSBRecParameters(1));
   dvariable SSBmax = mfexp(estSSBRecParameters(2));
   if(SSBRectype == 1) {
        value = Rmax*mfexp(-TimeDrift(year))*Spawningstock(year)/
        (SSBmax/5.0+Spawningstock(year));
   }
   // Ricker.  Here logSSBmax exists.  
   if(SSBRectype == 2) {
       value = Rmax*mfexp(-TimeDrift(year))*mfexp(1.0)/SSBmax*Spawningstock(year)*mfexp(-Spawningstock(year)/SSBmax);
   } 

   // Ricker Eggproduction.  SSBmax er einhvers skonar Eggproduction maximum.  
   if(SSBRectype == 3) {
       value = Rmax*mfexp(-TimeDrift(year))*mfexp(1.0)/SSBmax*EggProduction(year)*mfexp(-EggProduction(year)/SSBmax);
   }   
   // Beverton and Holt Eggproduction.  
   if(SSBRectype == 4) {
     value = Rmax*mfexp(-TimeDrift(year))*EggProduction(year)/
        (SSBmax/5.0+EggProduction(year));    
   }   


// Segmented regression
   if(SSBRectype == 5) {
     value = Rmax*mfexp(-TimeDrift(year))*Spawningstock(year)/SSBmax;
     value = SmoothDamper(value,Rmax*mfexp(-TimeDrift(year)),0);
   }   

   
// Fixed mean 
   if(SSBRectype == 6) {
       value  = Rmax*mfexp(-TimeDrift(year));
   }
   return value;   

// Calculate fishing mortality from catch.  More complicated version needed for catch of 0 group.  
// except SSB is close to the beginning of the year.  

FUNCTION dvariable FishmortFromCatch(const dvariable C,const dvar_vector& Number,const dvar_vector& Wt,const dvar_vector& sel,const dvar_vector& M)
   int i;
   dvar_vector Biomass(firstage,lastage);
   dvariable Fishmort;
   Biomass = elem_prod(Number,Wt);
   dvariable Cbio;
   dvariable epsilon=0.0001;
   dvariable Catch,Catch1,dCatch;
   int age1 =  Number.indexmin();
   int age2 = Number.indexmax();
   dvar_vector tmpF(age1,age2);
   dvar_vector tmpZ(age1,age2);
   Cbio = sum(elem_prod(sel,elem_prod(Biomass,(mfexp(-M)))));
   Fishmort = C/Cbio+0.05; 
   Cbio = sum(elem_prod(sel,elem_prod(Biomass,(mfexp(-(M+Fishmort))))));
   Fishmort = C/Cbio+0.01; 
   Fishmort = SmoothDamper(Fishmort,MaxFishMort,0.01);

// Newtons method numeric differentiation 5 runs. 
   for(i = 1; i < 10; i++) {
      tmpF = Fishmort*sel;
      tmpZ = tmpF + M;
      Catch = sum(elem_prod(elem_prod(elem_div(tmpF,tmpZ),(1.-mfexp(-tmpZ))),Biomass));
      tmpF = (Fishmort+epsilon)*sel;
      tmpZ = tmpF + M;
      Catch1  = sum(elem_prod(elem_prod(elem_div(tmpF,tmpZ),(1.-mfexp(-tmpZ))),Biomass));
      dCatch = (Catch1-Catch)/epsilon;
      Fishmort = Fishmort - (Catch1-C)/dCatch;
  }
  Fishmort = SmoothDamper(Fishmort,MaxFishMort,0.01);
  return(Fishmort);




// *********************************************
// Reading of Catchfile.  
// Look if summation of plus group is nessecary.  
// Might want residual file as with the surveys.  
FUNCTION void ReadCatchandStockData()

  cifstream infile(catchfilename);
  if(infile.fail()) {
        cout << "File " << catchfilename << 
	"does not exist or something is wrong with it" << endl;
         exit(1);
   }
  ofstream outfile("catchfile.log");
  int i;
  int year;
  int age;
  dvariable ratio;
  dvector tmpvec(1,7);
  for(i = 1; i < largenumber; i++) {
     infile >> tmpvec;
     if(infile.eof()) break;
     year = int(tmpvec(1));
     age = int(tmpvec(2));
// Weights and maturity are changed from negative values (missing values) to 
// 0 .  Questionable.  
     if(year>= firstyear & year<= lastyear & age >= firstage & ((age <= lastage & plusgroup == 0) || (age < lastage & plusgroup == 1) || ((age==lastage) & (lastage==lastdataage) & plusgroup==1 ))) {
     	ObsCatchInNumbers(year,age)  = tmpvec(3);
       	CatchWeightsData(year,age) = tmpvec(4);
        StockWeightsData(year,age) = tmpvec(5);
        StockMaturityData(year,age) = tmpvec(6);
        SSBWeightsData(year,age) = tmpvec(7);
        if(CatchWeightsData(year,age) < 0) CatchWeightsData(year,age) = 0;
        if(StockWeightsData(year,age) < 0) StockWeightsData(year,age) = 0;
        if(SSBWeightsData(year,age) < 0) SSBWeightsData(year,age) = 0;
        if(StockMaturityData(year,age) < 0) StockMaturityData(year,age) = 0;

     }
 // Add data if plus group. CNO used as proxy for stock in numbers in weighting data (( aga 
     if((year>= firstyear) & (year<= lastyear) & (age >=  lastage) & (plusgroup == 1)  & (lastdataage > lastage) ) {
        if(ObsCatchInNumbers(year,lastage) == -1) ObsCatchInNumbers(year,lastage) = 0; // -1 is missing
	ratio = ObsCatchInNumbers(year,lastage)/(ObsCatchInNumbers(year,lastage)+tmpvec(3));
        ObsCatchInNumbers(year,lastage) += tmpvec(3);
 	CatchWeightsData(year,lastage) = CatchWeightsData(year,lastage)*ratio+tmpvec(4)*(1.0-ratio);
 	StockWeightsData(year,lastage) = StockWeightsData(year,lastage)*ratio+tmpvec(5)*(1.0-ratio);
 	StockMaturityData(year,lastage) = StockMaturityData(year,lastage)*ratio+tmpvec(6)*(1.0-ratio);
 	SSBWeightsData(year,lastage) = SSBWeightsData(year,lastage)*ratio+tmpvec(4)*(1.0-ratio);
      }
     outfile << tmpvec << endl;
  }
  outfile.close();
  infile.close();
// CatchWeights is the same as CatchWeightsData + possible random noise.  The same for other variables.  
  CatchWeights = CatchWeightsData;
  StockWeights = StockWeightsData;
  StockMaturity = StockMaturityData;
  SSBWeights = SSBWeightsData;

// Totalcatchfilename is used for the years where catch in numbers does not exist but info on total
// catch exist.  
  cifstream totinfile(totalcatchfilename);  // this file is not needed
  if(totinfile.fail()) {
//        cout << "File " <<  totalcatchfilename << 
//	"does not exist or something is wrong with it" << endl;
  }
  else {
    int yr;
    while( !totinfile.eof()){
      totinfile >> yr;
      if(yr >= firstyear && year <= lastoptyear)
        infile >> TotCatchIn1000tons(yr);
    }
  }

FUNCTION void ReadCatchParameters()
    cifstream infile(catchparametersfilename);
    ofstream outfile("catchparameters.log");
    int i;
    int j;
    dvector changeyears(1,number_of_seperable_periods+1);
    changeyears(1) = firstyear;
    changeyears(number_of_seperable_periods+1)= lastyear;
    if(number_of_seperable_periods > 1){
      outfile << "changeyears ";
      infile >> changeyears(2,number_of_seperable_periods);
      outfile << changeyears(2,number_of_seperable_periods);
    }
    // set separable periods.  
    parcolnr=1; 
    if(number_of_seperable_periods > 1){
      for(i = firstyear; i <= lastyear; i++) {
        for(j = 2; j <= number_of_seperable_periods; j++) 
           if(i > changeyears(j)) parcolnr(i) = j;
      }
    }
//   cout << "parcolnr " << parcolnr << endl;
   if(misreportingphase > 0){  // If misreporting is estimated select when it quits
     infile >> LastMisReportingYear;
     outfile << " LastMisReportingYear  " <<  LastMisReportingYear << endl;
   }
     
   if(BackWards ){
      cifstream Ffile("Foldest.dat");
      Ffile  >> Foldestinp(firstyear,lastdatayear);
      outfile << "Foldestinp " << endl << Foldestinp;
      Ffile.close();
   } 

FUNCTION void ReadLikelihoodParameters()
   ofstream outfile("likelihood.log");
   cifstream infile(likelihoodparametersfilename);
   dvar_vector tmpsigmac(firstage,lastdataage);
   infile >> tmpsigmac;
   SigmaCinp = tmpsigmac(firstage,lastage);
   outfile  << "SigmaCinp " << SigmaCinp << endl;
   infile >> CatchResolution;
   outfile <<  "CatchResolution " << CatchResolution << endl;
   infile >>  sigmatotalcatch;
   outfile << "sigmatotalcatch " << sigmatotalcatch << endl;
   infile >>  CatchRobust;  // Robust log-likeli in catch
   infile >> SurveyRobust; // Robust log-likeli in survey
   outfile  << " CatchRobust " << CatchRobust << " SurveyRobust " << SurveyRobust << endl;
   infile >> Likeliweights(1,10); // Weights on likelhood comp, usually 1
   outfile << "Likeliweights " << Likeliweights << endl ;




FUNCTION void ReadStockParameters()
   ofstream outfile("stockparameters.log");
   cifstream infile(stockparametersfilename);
   dvar_vector tmpM(firstage,lastdataage);
   infile >> tmpM;
   Mdata = tmpM(firstage,lastage);
   outfile  << "Mdata " << Mdata << endl;

   dvar_vector tmpssb(minssbage,lastdataage);
   infile >> tmpssb;
   PropofFbeforeSpawning = tmpssb(minssbage,lastage); 
   outfile << " PropofFbeforeSpawning " <<  PropofFbeforeSpawning << endl;
   infile >> tmpssb;
   PropofMbeforeSpawning = tmpssb(minssbage,lastage); 
   outfile <<  " PropofMbeforeSpawning " <<  PropofMbeforeSpawning << endl;

   if(SSBRecParameters(5) > 0 | SSBRecSwitches(5) != -1) {
     infile >>  RefSSB >> Minrelssb >> Maxrelssb;
     outfile  << "RefSSB " << RefSSB << " Minrelssb " ;
     outfile << Minrelssb << "Maxrelssb " << Maxrelssb << endl;
  }
//***********************************************************************************************
// Migration years and ages.  The number of migrations has been input in main file
   if(MigrationNumbers > 0 ) {
     infile >>  MigrationYears;
     outfile  << "MigrationYears " << MigrationYears << endl ;
     infile >> MigrationAges;
     outfile  << "MigrationAges " << MigrationAges << endl ;
   }
   outfile.close();
   infile.close();


// --------------------------------------------
// Parameters to control the output from the program 

FUNCTION void ReadOutputParameters()
// Mean selection used for catchable biomass
   ofstream outfile("outputparameters.log");
   cifstream infile(outputparametersfilename);
   dvar_vector tmpmeansel(firstage,lastdataage);
   infile >> tmpmeansel;
   MeanSel = tmpmeansel(firstage,lastage);
   outfile  << "MeanSel" << endl << MeanSel << endl;
   infile >> Frefage1 >> Frefage2 >> WeightedF ; 
   outfile << "Frefage1 " << Frefage1 << "Frefage2 " << Frefage2 << "WeightedF" << WeightedF << endl;
   Frefage2 = min(Frefage2,lastage);


   infile >> printPhase ; // For printing phase to debug
   outfile << "printPhase " << printPhase << endl;
   infile >> RefBiominage ; // - means cwt
   outfile << "RefBiominage " << RefBiominage << endl;

   outfile << "mcwriteswitch " << endl;
   infile >> mcwriteswitch;
   for(int i = mcwriteswitch.indexmin(); i <=mcwriteswitch.indexmax(); i++) outfile  << i << " " << mcwriteswitch(i) << endl;

   outfile << "mcallwriteswitch " << endl;  // Write complet N, CW etc matrix
   infile >> mcallwriteswitch;
   for(int i = mcallwriteswitch.indexmin(); i <=mcallwriteswitch.indexmax(); i++) outfile  << i << " " << mcallwriteswitch(i) << endl;



//Sdreport values
FUNCTION void SetPredValues()  
  int i;
  PredRefF = RefF(lastoptyear-5,lastyear);
  PredSpawningstock = Spawningstock(lastoptyear-5,lastyear);
  for(i = lastoptyear-5; i <= lastyear; i++) PredN(i) = N(i,firstage);
  Survivors = N(lastoptyear+1);


// ***************************************************************
// Function that reads information about a survey  
//  

FUNCTION void ReadSurveyInfo(adstring parameterfilename,adstring datafilename, adstring residualfilename,int surveynumber,ofstream& surveylogfile)
  int ReadSurveyWeights = 0;
  int i;
  int year;
  int age;
  surveylogfile << endl << "Survey number " << surveynumber << endl; 
  cifstream parameterinfile(parameterfilename);
  
  int tmpminage;
  int tmpmaxage;
  dvariable tmpnumber;
  parameterinfile >> tmpnumber;
  Surveycorr(surveynumber) = tmpnumber;
  parameterinfile >> SurveyPropOfM(surveynumber);
  parameterinfile >> SurveyPropOfF(surveynumber);
  parameterinfile >> surveyweightsgiven(surveynumber);
  surveylogfile << "Surveycorr " <<   Surveycorr(surveynumber);
  surveylogfile << "SurveyPropOfM " <<   SurveyPropOfM(surveynumber);
  surveylogfile << "SurveyPropOfF " <<   SurveyPropOfF(surveynumber);
  surveylogfile << "surveyweightsgiven " << surveyweightsgiven(surveynumber)  << endl;
  
  parameterinfile >> tmpminage;
  parameterinfile >> tmpmaxage;

  surveylogfile << "tmpminage " << tmpminage << "tmpmaxage " << tmpmaxage << endl;
  surveylogfile << "CV as function of age" << endl;
  for(i = tmpminage; i <= tmpmaxage; i++) {
    parameterinfile >> tmpnumber;
    surveylogfile <<  tmpnumber << " "; 
    if(i >= firstage & i <= lastage) {
       SigmaSurveyInp(surveynumber,i) = tmpnumber;
    }
  }
  surveylogfile << endl;

  surveylogfile << "Resolution as function of age" << endl;
  for(i = tmpminage; i <= tmpmaxage; i++) {
    parameterinfile >> tmpnumber;
    surveylogfile <<  tmpnumber << " "; 
    if(i >= firstage & i <= lastage) {
       SurveyResolution(surveynumber,i) = tmpnumber;
    }
  }

  

  surveylogfile << endl;
  parameterinfile.close();
  cout << " start datafile" << endl;

// ath plus group in survey;
  int ncol;
  if(surveyweightsgiven(surveynumber) == 0) 
     ncol = 3;
  else 
     ncol = 4;
  dvector tmpvec(1,ncol);
  dvariable ratio;
  surveylogfile << "SurveyData " << endl;
  cifstream datainfile(datafilename);
  for( i = 1; i < largenumber; i++) {
     datainfile >> tmpvec;
     if(datainfile.eof()) break;
     year = int(tmpvec(1));
     age = int(tmpvec(2));
     if(year >= firstyear & year <= lastyear & age >= firstage &  ((age <= lastage & plusgroup == 0) | (age < lastage & plusgroup == 1))) {
    	ObsSurveyNr(surveynumber,year,age)  = tmpvec(3);
	if(surveyweightsgiven(surveynumber) != 0) SurveyWeights(surveynumber,year,age) = tmpvec(4);
        surveylogfile << tmpvec << endl;
     }
     if(year >= firstyear & year <= lastyear &  age >= lastage & plusgroup == 1){
     	ratio = ObsSurveyNr(surveynumber,year,lastage)/(ObsSurveyNr(surveynumber,year,lastage)+tmpvec(3)+1e-6);
        ObsSurveyNr(surveynumber,year,lastage) += tmpvec(3);
	if(surveyweightsgiven(surveynumber) != 0) SurveyWeights(surveynumber,year,lastage) = SurveyWeights(surveynumber,year,lastage)*ratio+tmpvec(4)*(1.0-ratio);
     }
//     surveylogfile << tmpvec << endl; Taken out jun 2017 ??
   }

  datainfile.close();

  dvector tmpvec1(1,3);
  surveylogfile << "Residuals " << endl;
  cifstream residualinfile(residualfilename);
  if(!residualinfile.fail()){
     for( i = 1; i < largenumber; i++) {
       residualinfile >> tmpvec1;
       if(residualinfile.eof()) break;
       year = int(tmpvec1(1));
       age = int(tmpvec1(2));
       ObsSurveyNr(surveynumber,year,age)  += tmpvec1(3);
       surveylogfile << tmpvec1 << endl;
     }
  }
  for(year = firstyear ; year <= lastyear; year++) {
     ObsSurveyBiomass(surveynumber,year) = sum(elem_prod(ObsSurveyNr(surveynumber,year),
	SurveyWeights(surveynumber,year)));
     ObsSurveyTotnr(surveynumber,year) = sum(ObsSurveyNr(surveynumber,year)); 
     if(ObsSurveyTotnr(surveynumber,year) == 0) {
	ObsSurveyNr(surveynumber,year) = -1;
	ObsSurveyTotnr(surveynumber,year) = -1;
	ObsSurveyBiomass(surveynumber,year) = -1;
    }
    if(ObsSurveyTotnr(surveynumber,year) == -1){
      for(int j = surveyfirstage(surveynumber); j <= surveylastage(surveynumber); j++)
         ObsSurveyBiomassProportion(surveynumber,year,j) = ObsSurveyNr(surveynumber,year,j)*SurveyWeights(surveynumber,year,j)/ObsSurveyBiomass(surveynumber,year);
   }
 }

//*****************************************************************************************
// Function that reads prognosisdata.  If no file is given the mean of last 3 years 
// is used.  
FUNCTION void ReadPrognosis()
   ofstream outfile("prognosis.log");
    int year;
    int age;
    int nCatchorFyrs;
    int i;
    dvar_vector ProgStockMaturity(firstage,lastage);
    dvar_vector ProgCatchWeights(firstage,lastage);
    dvar_vector ProgStockWeights(firstage,lastage);
    dvar_vector ProgSSBWeights(firstage,lastage);
    ProgStockMaturity =  ProgCatchWeights = ProgStockWeights = ProgSSBWeights = 0;
    cifstream infile(PrognosisFilename);
    infile >> CatchRule; // Number of catch rule.
    outfile << "Catchrule " << CatchRule << endl ;
    infile >> weightcv; // cv of weights
    outfile << "weightcv" << weightcv << endl;
    infile >> weightcorr; // autocorrelations of weights
    outfile << "weightcorr" << weightcorr << endl;
    infile >> Assessmentcv; // cv of Assessments
    outfile << "Assessmentcv" << Assessmentcv << endl;
    infile >> Assessmentcorr; // autocorrelations of Assessments
    outfile << "Assessmentcorr" << Assessmentcorr << endl;
    infile >> Recrcorr; // autocorrelations of Recruitment cv estimated
    outfile << "Recrcorr" << Recrcorr << endl;
    infile >> Btrigger; // SSB trigger in the assessment yar
    outfile << "Btrigger" << Btrigger << endl;
    infile >> Maxchange; // Maxchange 
    outfile << "Maxchange " << Maxchange << endl;
    Maxchange += 1 ;
    infile >> EstimatedAssYrSSB;  // To get starting value for AssErr
    outfile << "EstimatedAssYrSSB" <<  EstimatedAssYrSSB << endl;
    infile >> nprogselyears;  // number of years to use for compiling selection in prognosis
    outfile  << "nprogselyears "<< nprogselyears << endl;
    infile >> nweightandmaturityselyears; // number of years to use for compiling weight and maturty in selection.  
    outfile <<  "nweightandmaturityselyears " << nweightandmaturityselyears << endl;
    if(nprogselyears==0) {
      infile >>  progsel ;  // Read prognosis selection
      outfile << "progsel " << progsel << endl;  
    }
    infile >> IceFishYear;  // Icelandic Fishing Year 0, Calendar 1
    outfile << "IceFishYear " <<  IceFishYear << endl;
    infile >> LastYearsTacRatio; // Weight of last years tac (Ice stabiliser)
    outfile << "LastYearsTacRatio " << LastYearsTacRatio << endl;
    infile >> DensDep;  // 0 for no density dependence, 1 for Icehad and more values available for other stocks.  
    outfile << "DensDep " << DensDep << endl;  
    
    if(CatchRule == 1  || CatchRule == 2 || CatchRule == 4 || CatchRule == 5 || CatchRule == 10 ) { // F or Catch read next ncatch years, fill the rest with last value
        infile >> nCatchorFyrs;
        outfile << "nCatchorFyrs" << nCatchorFyrs << endl;
        if( nCatchorFyrs >  nsimuyears) cerr << "warning  nCathchorFyrs > nsimuyears)"; // Has to be the other way
        outfile << "FutureForCatch "; 
        for(i = lastoptyear+1; i <= lastoptyear+nCatchorFyrs; i++) {
          infile >> FutureForCatch(i); 
          outfile << FutureForCatch(i) << endl; 
        }
        if( nsimuyears > nCatchorFyrs) {
          for(i == lastoptyear+nCatchorFyrs; i <= lastoptyear+nsimuyears; i++) 
            FutureForCatch(i)=FutureForCatch(lastoptyear+nCatchorFyrs);  // Fill the rest) 
        }
    } 
    if(CatchRule == 3 ) {  // Biomass in assessment year
      infile >> AgeModel; // If 1 then we use age else size;
      outfile << "AgeModel " << AgeModel << endl;
      if(AgeModel == 1) {
         infile >> HCRrefAge;   //4 means 4+ -4 4+ CatchWts
         outfile << "HCRrefAge " << HCRrefAge << endl;
         infile >> HCRBproxyAge ;  //4 means 4+ -4 4+ CatchWts 0 means SSB
         outfile << "HCRBproxyAge " << HCRBproxyAge << endl;
      }
      if(AgeModel == 0) { // size
        infile  >> HCRreflebreak;  // Will in the end need more parameters.  
	outfile << "HCRreflebreak " << HCRreflebreak;
      }	
      infile >> HarvestRatio ; 
      outfile << "HarvestRatio " << HarvestRatio << endl;
      infile >> MaxHarvestRatio;  // Maximum that we allow in any year depends on the ratio between ref and total bio 0.6-1
      outfile << "MaxHarvestRatio " << MaxHarvestRatio << endl;
      infile >> CurrentTacInput ; 
      outfile << "CurrentTacInput " << CurrentTacInput << endl;
      infile >> TacLeftInput ;  // Only for ICEFISHYEAR
      outfile << "TacLeftInput " << TacLeftInput << endl;
   }      
   infile.close();
   cifstream  Progwtandmatinfile(WeightAndMaturityDatafilename);
   if(Progwtandmatinfile.fail()){
      cout << "No WeightAndMaturityDatafilename or bad prognosisfile use mean of last ** data years" << endl ;
      int usedlastdatayear = min(lastdatayear,lastyear);
      for(i = usedlastdatayear -nweightandmaturityselyears+1 ; i <= usedlastdatayear; i++) {
	ProgStockMaturity += StockMaturity(i);
	ProgCatchWeights += CatchWeights(i);
	ProgStockWeights += StockWeights(i);
	ProgSSBWeights += SSBWeights(i);
      }
      ProgStockMaturity/= nweightandmaturityselyears;
      ProgCatchWeights/= nweightandmaturityselyears;
      ProgStockWeights/= nweightandmaturityselyears;
      ProgSSBWeights/= nweightandmaturityselyears;
      //cout << ProgStockMaturity << endl << ProgCatchWeights << endl << ProgStockWeights << endl;
      for(i = usedlastdatayear+1; i <= lastyear; i++) {
         StockMaturity(i) = ProgStockMaturity;
	 CatchWeights(i) = ProgCatchWeights;
         StockWeights(i) = ProgStockWeights;
         SSBWeights(i) = ProgSSBWeights;
         StockMaturityData(i) = ProgStockMaturity;
	 CatchWeightsData(i) = ProgCatchWeights;
         StockWeightsData(i) = ProgStockWeights;
         SSBWeightsData(i) = ProgSSBWeights;
      }
      return;
   }
   outfile << "StockAndMaturityData log " << endl;
   dvector tmpvec(1,6);
   for(i = 1; i <= largenumber ; i++) {
      Progwtandmatinfile >> tmpvec;
     if(infile.eof()) break;
      year = int(tmpvec(1));
      age = int(tmpvec(2));
      if(year >= lastdatayear & year <= lastyear & age >= firstage & age <= lastage) {
          CatchWeights(year,age) = tmpvec(3);
          StockWeights(year,age) = tmpvec(4);
          StockMaturity(year,age) = tmpvec(5);
          SSBWeights(year,age) = tmpvec(6);
     }
     outfile << tmpvec << endl;  
   }
   if( year < lastyear) {
      i = year;  
      for(year = i ; year <= lastyear ; year++) {
          CatchWeights(year) = CatchWeights(i);
          StockWeights(year) = StockWeights(i);
          StockMaturity(year) = StockMaturity(i);
          SSBWeights(year) = SSBWeights(i); 
      }
   }
   Progwtandmatinfile.close();
   return;


 //************************************************************************************************************
 //************************************************************************************************************
// Function that writes inputdata in tables.  
FUNCTION void WriteInputDataInMatrixForm()
   int i; 
   ofstream outfile("input1.log");
   dvector ages(firstage,lastage); 
   for(i = firstage; i<= lastage ; i++) ages[i] = i;

   outfile << "CatchInNumbers" << endl;
   outfile << "year\t" << ages << endl;
   for(i = firstyear; i <= lastyear; i++) 
      outfile << i << "\t" << ObsCatchInNumbers(i) << endl;

   outfile << endl <<  "CatchWeights" << endl;
   outfile << "year\t" << ages << endl;
   for(i = firstyear; i <= lastyear; i++) 
      outfile << i << "\t" << CatchWeights(i) << endl;

   outfile << endl <<  "StockWeights" << endl;
   outfile << "year\t" << ages << endl;
   for(i = firstyear; i <= lastyear; i++) 
      outfile << i << "\t" << StockWeights(i) << endl;

   outfile << endl <<  "SSBWeights" << endl;
   outfile << "year\t" << ages << endl;
   for(i = firstyear; i <= lastyear; i++) 
      outfile << i << "\t" << SSBWeights(i) << endl;

     outfile << endl <<  "StockMaturity" << endl;
   outfile << "year\t" << ages << endl;
   for(i = firstyear; i <= lastyear; i++) 
      outfile << i << "\t" << StockMaturity(i) << endl;
   outfile.close();

// Very specific for haddock but equations can be changed.    
FUNCTION void UpdateWeightandMaturityHad(int year)
   int age;
   // Set up stock weights
   dvariable maxgrowthmult = 0.9; // from file later.  
   dvariable biom = 0;
   dvariable growthmult;
   dvariable growth;
   if(year > lastoptyear+1) {// survey in assessment year data on wt.  
      StockWeights(year,1) = 35; // does not matter
      StockWeights(year,2) = 198-0.115*(N(year,2) + N(year,3))/1000.*mfexp(recrweighterr(year));
    }
//   CatchWeights(year) = 9.169988*pow((StockWeights(year)),0.7438964)*mfexp(catchweighterr(year)); //More above 5720g 
    CatchWeights(year) = 8.65813*pow((StockWeights(year)),0.7388)*mfexp(catchweighterr(year)) ;// 1985-2011

   SSBWeights(year) = StockWeights(year);  // Used in haddock
//   StockMaturity(year) = 1.0/(1.0+mfexp(17.314-2.644*log(StockWeights(year)))); // Added fef 2013
   StockMaturity(year) = 1.0/(1.0+mfexp(12.642-1.933*log(StockWeights(year)))); // Added fef 2013


   if(year < lastyear) { // Add one more year
       if(current_phase() < 5) growthmult = 0.85;
       else{
        for(age= 2; age <= lastage; age ++)
          biom += N(year,age)*StockWeights(year,age);
	 biom = biom/1e6;
	  growthmult = (0.960452795-biom*0.000571546);
//         growthmult = 1.05-biom/1000;
         growthmult = SmoothDamper(growthmult,maxgrowthmult,0.01);
       }
     for(age = 2; age < lastage; age++) {
       growth = 14.1*pow((StockWeights(year,age)),-0.30468);
//        growth = 13.55762*pow((StockWeights(year,age)),-0.3007094); // question about for of function growth stops earlier when slow
       growth = growth*growthmult;
       StockWeights(year+1,age+1) = StockWeights(year,age)*growth*mfexp(weighterr(year));
     }
   }
   dvariable fullprogselwt = fullselwt*mfexp(selerr(year));
   dvariable sel;
   for(age = firstcatchage; age <=  lastage; age++) {
      progsel(age) = 1./(1+mfexp(-selslope*log(StockWeights(year,age)/fullprogselwt)));
   }
   progsel=progsel/CalcMeanF(progsel);
 



// Function to set stochasticity on weights and possibly maturity .
// Might later only be used for one year at time 
// it might sometime have to be related to stock size.  
// Other parameters like selection might also be included.

FUNCTION void UpdateWeightsAndMaturity() 
// Could est the starting point based on current value i.e negative

  random_number_generator r(COUNTER+10000);  // To avoid correlation
  dvar_vector weighterr(lastoptyear+1,lastyear);
  dvariable ratio = sqrt(1-weightcorr*weightcorr);
  int i;
  weighterr = 0; 
// mceval_phase does not work
  if(mceval_phase()|| mceval_phase()) {
    for(i = lastoptyear+1; i <= lastyear; i++)
      weighterr(i) = randn(r);
    weighterr(lastoptyear+1) = weighterr(lastoptyear+1)/ratio;
    for(i = lastoptyear+2; i <= lastyear; i++)
      weighterr(i) = weightcorr*weighterr(i-1)+weighterr(i);
    weighterr=weighterr*weightcv*ratio;
  }
  weighterr(lastoptyear+1)*=0.35;  // less weigth in first and second prediction
  weighterr(lastoptyear+2)*=0.7;
  for(i = lastoptyear+1; i <= lastyear; i++)
      CatchWeights(i) = mfexp(log(CatchWeightsData(i))+weighterr(i));
  for(i = lastoptyear+2; i <= lastyear; i++){ //SSB and Stock weights available in Assessyear
      StockWeights(i) = mfexp(log(StockWeightsData(i))+weighterr(i));
      SSBWeights(i) = mfexp(log(SSBWeightsData(i))+weighterr(i));
  }
// Function to set stochasticity on weights and possibly maturity .
// Sets white noise on each age and year.  

FUNCTION void UpdateWeightsAndMaturityWhiteNoise() 
// Could est the starting point based on current value i.e negative
// Same settings of random_number_generator as in UpdateWeightsAndMaturity because they
// are never used both in the same run.  


  random_number_generator r(COUNTER+10000);  // To avoid correlation
  dvar_vector weighterr(firstage,lastage);
  int i;
  int j; 
  weighterr = 0; 
// mceval_phase does not work
  if(mceval_phase() || mceval_phase()) {    
    for(i = lastoptyear+1; i <= lastyear; i++){
      for(j=firstage; j <= lastage; j++) 
        weighterr(j) = randn(r)*weightcv;
      if(i == lastoptyear + 1 )
        CatchWeights(i) = mfexp(log(CatchWeightsData(i))+weighterr*0.35);
      if(i == lastoptyear + 2) {
         CatchWeights(i) = mfexp(log(CatchWeightsData(i))+weighterr*0.7);
         StockWeights(i) = mfexp(log(StockWeightsData(i))+weighterr*0.7);
         SSBWeights(i) = mfexp(log(SSBWeightsData(i))+weighterr*0.7);
      }
      if(i > lastoptyear + 2) { 
         CatchWeights(i) = mfexp(log(CatchWeightsData(i))+weighterr);
         StockWeights(i) = mfexp(log(StockWeightsData(i))+weighterr);
         SSBWeights(i) = mfexp(log(SSBWeightsData(i))+weighterr);
      }
    }
  }


// This function will be edited as needed.  The function is called on year by 
// year basis in prognosis but for all years in assessment.  The flag HistAssessment is 
// not used at the moment but might later be used.  

FUNCTION  void CalcRefValues(int firstyr,int lastyr,int HistAssessment) 
  int i;
  int j;

// Some variables that later might be input from file.  
  

  for(i = firstyr; i <= lastyr; i++) {
     N3(i) = N(i,3);  
     N1st(i) = N(i,1);  
     PredictSSB(i);
     if(RefBiominage(1) > 0) 
       RefBio1(i) = sum(elem_prod(N(i)(RefBiominage(1),lastage),
       StockWeights(i)(RefBiominage(1),lastage)))/1.0e6;
     else
        RefBio1(i) = sum(elem_prod(N(i)(-RefBiominage(1),lastage),
	CatchWeights(i)(-RefBiominage(1),lastage)))/1.0e6;
	
     if(RefBiominage(2) > 0) 
        RefBio2(i) = sum(elem_prod(N(i)(RefBiominage(2),lastage),
       StockWeights(i)(RefBiominage(2),lastage)))/1.0e6;
     else
        RefBio2(i) = sum(elem_prod(N(i)(-RefBiominage(2),lastage),
	CatchWeights(i)(-RefBiominage(2),lastage)))/1.0e6;

// Biomass with specified selection
    CbioR(i) = 0; 
    for(j = firstage; j <= lastage; j++) 
     CbioR(i)  = CbioR(i) + N(i,j)*CatchWeights(i,j)*MeanSel(j)*(1-mfexp(-Z(i,j)))/Z(i,j);
   if(WeightedF == 0) 
       RefF(i) = CalcMeanF(F(i));
    if(WeightedF == 1) 
       RefF(i) = CalcWeightedMeanF(F(i),N(i));
    CbioR(i)/= 1.0e6;
   }
   RelSpawningstock = Spawningstock/Spawningstock(lastoptyear+1);  // Ministers question
   RelSpawningstock(lastoptyear+1) +=   RelSpawningstock(lastoptyear)/1e6;  // To avoind error message

  if(HistAssessment == 1) {
    if(nprogselyears > 0) {  // calculate progsel if it is not read from file.  
       for(j = firstcatchage; j <= lastage; j++) {
         progsel(j) = 0;
         for(i = lastoptyear-nprogselyears+1; i <= lastoptyear; i++)  
           progsel(j)  += F(i,j)/RefF(i); 
       }
       progsel /= nprogselyears;
    }
    for(j = firstcatchage; j <= lastage; j++) {
      meansel(j) = 0;
       for(i = firstyear; i <= lastoptyear; i++)  
        meansel(j)  += F(i,j)/RefF(i);
    } 
    meansel /= noptyears;
  }


// Predict SSB for a given year.  Also the CV in SSB-Recruitment relationship.  

FUNCTION void PredictSSB(int year)
   int age;
   dvariable Eggratio;
   dvariable SSBRecCV = mfexp(estSSBRecParameters(3));
   dvariable SSBRecpow = estSSBRecParameters(5);
    Spawningstock(year) = 0;
   for(age = minssbage; age <= lastage; age++){
     Spawningstock(year) += N(year,age)*SSBWeights(year,age)*StockMaturity(year,age)*
     mfexp(-(natM(year,age)*PropofMbeforeSpawning(age)+F(year,age)*PropofFbeforeSpawning(age)));
     Eggratio = 0.01+0.09*SSBWeights(year,age)/20000;
     Eggratio = SmoothDamper(Eggratio,0.1,0);
     EggProduction(year) += Eggratio*N(year,age)*SSBWeights(year,age)*StockMaturity(year,age)*
     mfexp(-(natM(year,age)*PropofMbeforeSpawning(age)+F(year,age)*PropofFbeforeSpawning(age)));
   }
   Totbio(year) = sum(elem_prod(SSBWeights(year),N(year)))/1e6;
   Spawningstock(year)/= 1e6; 
   EggProduction(year)/= 1e6;  
   SigmaSSBRec(year) = SSBRecCV/pow(SmoothDamper(Spawningstock(year)/
   RefSSB,Maxrelssb,Minrelssb),SSBRecpow); 
 


FUNCTION dvariable CalcMeanF(dvar_vector Fm)
  return mean(Fm(Frefage1,Frefage2));

FUNCTION dvariable CalcWeightedMeanF(dvar_vector Fm,dvar_vector N)
    return sum(elem_prod(Fm(Frefage1,Frefage2),N(Frefage1,Frefage2)))/
	sum(N(Frefage1,Frefage2));


FUNCTION void write_mcmc()
  // Writes MCMC chains to many wide-format files
  // Each quantity gets one column and all files have the same number of lines
  // Strict format: no space before first column, one space between columns, and no space after last column

  // 1 Spawning stock biomass
  if(mcwriteswitch(1) == 1) {
    if(ssb_mcmc_lines == 0)
    {
      ssb_mcmc.open("ssb.mcmc");
      ssb_mcmc<<"Spawningstock."<<Spawningstock.indexmin();
      for(int t=Spawningstock.indexmin()+1; t<=Spawningstock.indexmax(); t++)
      ssb_mcmc<<" Spawningstock."<<t;
      ssb_mcmc<<endl;
    }
    ssb_mcmc<<Spawningstock(Spawningstock.indexmin());
    ssb_mcmc<<Spawningstock.sub(Spawningstock.indexmin()+1,Spawningstock.indexmax())<<endl;
    ssb_mcmc_lines++;
  }


//2  firstage number in stock
  if(mcwriteswitch(2) == 1){
    if(n1st_mcmc_lines == 0)
    {
      n1st_mcmc.open("n1st.mcmc");
      n1st_mcmc<<"N1st."<<N1st.indexmin();
      for(int t=N1st.indexmin()+1; t<=N1st.indexmax(); t++)
        n1st_mcmc<<" N1st."<<t;
      n1st_mcmc<<endl;
    }
    n1st_mcmc<<N1st(N1st.indexmin());
    n1st_mcmc<<N1st.sub(N1st.indexmin()+1,N1st.indexmax())<<endl;
    n1st_mcmc_lines++;
  }
  //3 Reference F
  if(mcwriteswitch(3) == 1){
    if(f_mcmc_lines == 0)
    {
      f_mcmc.open("f.mcmc");    
      f_mcmc<<"RefF."<<RefF.indexmin();
      for(int t=RefF.indexmin()+1; t<=RefF.indexmax(); t++)
        f_mcmc<<" RefF."<<t;
      f_mcmc<<endl;
    }
    f_mcmc<<RefF(RefF.indexmin());
    f_mcmc<<RefF.sub(RefF.indexmin()+1,RefF.indexmax())<<endl;
    f_mcmc_lines++;
  }

// 4 unused.  

// 5 Catch
  if(mcwriteswitch(5) == 1){
    if(catch_mcmc_lines == 0)
    {
      catch_mcmc.open("catch.mcmc");
      catch_mcmc<<"CalcCatchIn1000tons."<<CalcCatchIn1000tons.indexmin();
      for(int t=CalcCatchIn1000tons.indexmin()+1; t<=CalcCatchIn1000tons.indexmax(); t++)
        catch_mcmc<<" CalcCatchIn1000tons."<<t;
      catch_mcmc<<endl;
    }
    catch_mcmc<<CalcCatchIn1000tons(CalcCatchIn1000tons.indexmin());
    catch_mcmc<<CalcCatchIn1000tons.sub(CalcCatchIn1000tons.indexmin()+1,CalcCatchIn1000tons.indexmax())<<endl;
    catch_mcmc_lines++;
  }
//  6  Some parameters 
  if(mcwriteswitch(6) == 1){
    if(parameter_mcmc_lines == 0)
    {
      parameter_mcmc.open("parameter.mcmc");
  
      parameter_mcmc<<"MeanRecr MeanInitialpop Catchlogitslope Catchlogitage50 SigmaCmultiplier AbundanceMultiplier MeanEffort";
      for(int i=1; i<=size_count(estSSBRecParameters); i++)
        parameter_mcmc<<" estSSBRecParameters."<<i;
      parameter_mcmc<<endl;
    }
    parameter_mcmc<<mfexp(lnMeanRecr)<<" "<<mfexp(lnMeanInitialpop)<<" "<<Catchlogitslope<<" "<<Catchlogitage50<<" "
     <<mfexp(logSigmaCmultiplier)<<" "<<AbundanceMultiplier<<" "<<mfexp(lnMeanEffort)<<estSSBRecParameters<<endl;
    parameter_mcmc_lines++;
  }


  // 7 Refbio1
  if(mcwriteswitch(7) == 1){
    if(refbio1_mcmc_lines == 0)
    {
      refbio1_mcmc.open("refbio1.mcmc");
      refbio1_mcmc<<"RefBio1."<<RefBio1.indexmin();
      for(int t=RefBio1.indexmin()+1; t<=RefBio1.indexmax(); t++)
        refbio1_mcmc<<" RefBio1."<<t;
      refbio1_mcmc<<endl;
    }
    refbio1_mcmc<<RefBio1(RefBio1.indexmin());
    refbio1_mcmc<<RefBio1.sub(RefBio1.indexmin()+1,RefBio1.indexmax())<<endl;
    refbio1_mcmc_lines++;

  }
  
  // 8  Reference biomass2
  if(mcwriteswitch(8) == 1){
    if(refbio2_mcmc_lines == 0)
    {
      refbio2_mcmc.open("refbio2.mcmc");
      refbio2_mcmc<<"RefBio2."<<RefBio2.indexmin();
      for(int t=RefBio2.indexmin()+1; t<=RefBio2.indexmax(); t++)
        refbio2_mcmc<<" RefBio2."<<t;
      refbio2_mcmc<<endl;
    }
    refbio2_mcmc<<RefBio2(RefBio2.indexmin());
    refbio2_mcmc<<RefBio2.sub(RefBio2.indexmin()+1,RefBio2.indexmax())<<endl;
    refbio2_mcmc_lines++;
  }
   
    // 9 HCRrefbio
  if(mcwriteswitch(9) == 1){
    if(hcrrefbio_mcmc_lines == 0)
    {
      hcrrefbio_mcmc.open("hcrrefbio.mcmc");
      hcrrefbio_mcmc<<"HCRrefbio."<<HCRrefbio.indexmin();
      for(int t=HCRrefbio.indexmin()+1; t<=HCRrefbio.indexmax(); t++)
        hcrrefbio_mcmc<<" HCRrefbio."<<t;
      hcrrefbio_mcmc<<endl;
    }
    hcrrefbio_mcmc<<HCRrefbio(HCRrefbio.indexmin());
    hcrrefbio_mcmc<<HCRrefbio.sub(HCRrefbio.indexmin()+1,HCRrefbio.indexmax())<<endl;
    hcrrefbio_mcmc_lines++;
  }


//10 AssessmentError

  if(mcwriteswitch(10) == 1){
    if(assessmenterror_mcmc_lines == 0)
    {
      assessmenterror_mcmc.open("assessmenterror.mcmc");
      assessmenterror_mcmc<<"AssessmentErr."<<AssessmentErr.indexmin();
      for(int t=AssessmentErr.indexmin()+1; t<=AssessmentErr.indexmax(); t++)
        assessmenterror_mcmc<<" AssessmentErr."<<t;
      assessmenterror_mcmc<<endl;
    }
    assessmenterror_mcmc<<AssessmentErr(AssessmentErr.indexmin());
    assessmenterror_mcmc<<AssessmentErr.sub(AssessmentErr.indexmin()+1,AssessmentErr.indexmax())<<endl;
    assessmenterror_mcmc_lines++;
  }

  // 11 Survey catchability only for first survey.  Smaller file than ssb.mcmc forexample.
  if(mcwriteswitch(11) == 1){
    if(surveyq_mcmc_lines == 0)
    {
      surveyq_mcmc.open("surveyq.mcmc");
      surveyq_mcmc<<"SurveylnQest.1."<<SurveylnQest.colmin();
      for(int a=SurveylnQest.colmin()+1; a<=SurveylnQest.colmax(); a++)
        surveyq_mcmc<<" SurveylnQest.1."<<a;
      for(int i=2; i<=SurveylnQest.rowsize(); i++)
        for(int a=SurveylnQest.colmin(); a<=SurveylnQest.colmax(); a++)
          surveyq_mcmc<<" SurveylnQest."<<i<<"."<<a;
      surveyq_mcmc<<endl;
    }
    surveyq_mcmc<<SurveylnQest(1,SurveylnQest.colmin());
    surveyq_mcmc<<row(SurveylnQest,1).sub(SurveylnQest.colmin()+1,SurveylnQest.colmax());
    for(int i=2; i<=SurveylnQest.rowsize(); i++)
      surveyq_mcmc<<row(SurveylnQest,i);
    surveyq_mcmc<<endl;
    surveyq_mcmc_lines++;
  }


//   12 Survey  power coefficients
  if(mcwriteswitch(12) == 1){   
     if(surveypower_mcmc_lines == 0)
     {
        surveypower_mcmc.open("surveypower.mcmc");
        surveypower_mcmc<<"SurveyPowerest.1."<<SurveyPowerest.colmin();
        for(int a=SurveyPowerest.colmin()+1; a<=SurveyPowerest.colmax(); a++)
          surveypower_mcmc<<" SurveyPowerest.1."<<a;
        for(int i=2; i<=SurveyPowerest.rowsize(); i++)
          for(int a=SurveyPowerest.colmin(); a<=SurveyPowerest.colmax(); a++)
            surveypower_mcmc<<" SurveyPowerest."<<i<<"."<<a;
        surveypower_mcmc<<endl;
      }
      surveypower_mcmc<<SurveyPowerest(1,SurveyPowerest.colmin());
      surveypower_mcmc<<row(SurveyPowerest,1).sub(SurveyPowerest.colmin()+1,SurveyPowerest.colmax());
      for(int i=2; i<=SurveyPowerest.rowsize(); i++)
        surveypower_mcmc<<row(SurveyPowerest,i);
      surveypower_mcmc<<endl;
      surveypower_mcmc_lines++;
  }

  // 13 Migrations
  if(mcwriteswitch(13) == 1){   
    if(size_count(lnMigrationAbundance) > 0)
    {
      if(migration_mcmc_lines == 0)
      {
        migration_mcmc.open("migration.mcmc");
        migration_mcmc<<"MigrationAbundance."<<MigrationYears(1);
        for(int i=2; i<=size_count(lnMigrationAbundance); i++)
          migration_mcmc<<" MigrationAbundance."<<MigrationYears(i);
        migration_mcmc<<endl;
      }
      migration_mcmc<<mfexp(lnMigrationAbundance(1));
      migration_mcmc<<mfexp(lnMigrationAbundance.sub(2,size_count(lnMigrationAbundance)))<<endl;
      migration_mcmc_lines++;
    }
  }  

// 14 likelihood components
  if(mcwriteswitch(14) == 1){   
    if(likelihood_mcmc_lines == 0)
    {
      likelihood_mcmc.open("likelihood.mcmc");
      likelihood_mcmc<<"LnLikely";
      for(int i=1; i<=5; i++)
        likelihood_mcmc<<" LnLikelicomp."<<i;
      likelihood_mcmc<<endl;
    }
    likelihood_mcmc<<LnLikely<<LnLikelicomp(1,5)<<endl;
    likelihood_mcmc_lines++;
  }  

  // 15 Historical recruitment age 0
  if(mcwriteswitch(15) == 1){   
    if(recruitment_mcmc_lines == 0)
    {
      recruitment_mcmc<<"Recr."<<lnRecr.indexmin();
      for(int t=lnRecr.indexmin()+1; t<=lnRecr.indexmax(); t++)
        recruitment_mcmc<<" lnRecr."<<t;
      recruitment_mcmc<<endl;
    }
    recruitment_mcmc<<mfexp(lnMeanRecr+lnRecr(lnRecr.indexmin()));
    recruitment_mcmc<<mfexp(lnMeanRecr+lnRecr.sub(lnRecr.indexmin()+1,lnRecr.indexmax()))<<endl;
    recruitment_mcmc_lines++;
  }
  
  // 16 Initial population
  if(mcwriteswitch(16) == 1){
    if(initpopulation_mcmc_lines == 0)
    {
      initpopulation_mcmc<<"Initialpop."<<lnInitialpop.indexmin();
      for(int a=lnInitialpop.indexmin()+1; a<=lnInitialpop.indexmax(); a++)
        initpopulation_mcmc<<" Initialpop."<<a;
      initpopulation_mcmc<<endl;
    }
    initpopulation_mcmc<<mfexp(lnMeanInitialpop+lnInitialpop(lnInitialpop.indexmin()));
    initpopulation_mcmc<<mfexp(lnMeanInitialpop+lnInitialpop.sub(lnInitialpop.indexmin()+1,lnInitialpop.indexmax()))<<endl;
    initpopulation_mcmc_lines++;
  }


// 17 Estimated selection
  if(mcwriteswitch(17) == 1){
    if(estimatedselection_mcmc_lines == 0)
    {
      estimatedselection_mcmc.open("estimatedselection.mcmc");
      estimatedselection_mcmc<<"EstimatedSelection."<<EstimatedSelection.colmin();
      for(int a=EstimatedSelection.colmin()+1; a<=EstimatedSelection.colmax(); a++)
        estimatedselection_mcmc<<" EstimatedSelection.1."<<a;
      for(int i=EstimatedSelection.rowmin(); i<=EstimatedSelection.rowmax(); i++)
        for(int a=EstimatedSelection.colmin(); a<=EstimatedSelection.colmax(); a++)
          estimatedselection_mcmc<<" EstimatedSelection."<<i<<"."<<a;
      estimatedselection_mcmc<<endl;
    }
    estimatedselection_mcmc<<EstimatedSelection(1,EstimatedSelection.colmin());
    estimatedselection_mcmc<<row(EstimatedSelection,1).sub(EstimatedSelection.colmin()+1,EstimatedSelection.colmax());
    for(int i=2; i<=EstimatedSelection.rowsize(); i++)
      estimatedselection_mcmc<<row(EstimatedSelection,i);
    estimatedselection_mcmc<<endl;
    estimatedselection_mcmc_lines++;
  }

  // 18  Effort (estimated )
  if(mcwriteswitch(18) == 1){
    if(effort_mcmc_lines == 0)
    {
      effort_mcmc.open("effort.mcmc");
      effort_mcmc<<"Effort."<<lnEffort.indexmin();
      for(int t=lnEffort.indexmin()+1; t<=lnEffort.indexmax(); t++)
        effort_mcmc<<" Effort."<<t;
      effort_mcmc<<endl;
    }
    effort_mcmc<<mfexp(lnMeanEffort+lnEffort(lnEffort.indexmin()));
    effort_mcmc<<mfexp(lnMeanEffort+lnEffort.sub(lnEffort.indexmin()+1,lnEffort.indexmax()))<<endl;
    effort_mcmc_lines++;
  }

  // 19 Bproxy
  if(mcwriteswitch(19) == 1){
    if(hcrbproxy_mcmc_lines == 0)
    {
      hcrbproxy_mcmc.open("hcrbproxy.mcmc");
      hcrbproxy_mcmc<<"HCRBproxy."<<HCRBproxy.indexmin();
      for(int t=HCRBproxy.indexmin()+1; t<=HCRBproxy.indexmax(); t++)
        hcrbproxy_mcmc<<" HCRBproxy."<<t;
      hcrbproxy_mcmc<<endl;
    }
    hcrbproxy_mcmc<<HCRBproxy(HCRBproxy.indexmin());
    hcrbproxy_mcmc<<HCRBproxy.sub(HCRBproxy.indexmin()+1,HCRBproxy.indexmax())<<endl;
    hcrbproxy_mcmc_lines++;
  }
  // 20 N3  
  if(mcwriteswitch(20) == 1){
    if(n3_mcmc_lines == 0)
    {
      n3_mcmc.open("n3.mcmc");
      n3_mcmc<<"N3."<<N3.indexmin();
      for(int t=N3.indexmin()+1; t<=N3.indexmax(); t++)
        n3_mcmc<<" N3."<<t;
      n3_mcmc<<endl;
    }
    n3_mcmc<<N3(N3.indexmin());
    n3_mcmc<<N3.sub(N3.indexmin()+1,N3.indexmax())<<endl;
    n3_mcmc_lines++;
  }

  // 21 SSB with ERR
  if(mcwriteswitch(21) == 1){
    if(ssbwerr_mcmc_lines == 0)
    {
      ssbwerr_mcmc.open("ssbwerr.mcmc");
      ssbwerr_mcmc<<"SpawningstockWithErr."<<SpawningstockWithErr.indexmin();
      for(int t=SpawningstockWithErr.indexmin()+1; t<=SpawningstockWithErr.indexmax(); t++)
      ssbwerr_mcmc<<" SpawningstockWithErr."<<t;
      ssbwerr_mcmc<<endl;
    }
    ssbwerr_mcmc<<SpawningstockWithErr(SpawningstockWithErr.indexmin());
    ssbwerr_mcmc<<SpawningstockWithErr.sub(SpawningstockWithErr.indexmin()+1,SpawningstockWithErr.indexmax())<<endl;
    ssbwerr_mcmc_lines++;
  }

  // 22 SSB relssb
  if(mcwriteswitch(22) == 1){
    if(relssb_mcmc_lines == 0)
    {
      relssb_mcmc.open("relssb.mcmc");
      relssb_mcmc<<"RelSpawningstock."<<RelSpawningstock.indexmin();
      for(int t=RelSpawningstock.indexmin()+1; t<=RelSpawningstock.indexmax(); t++)
        relssb_mcmc<<" RelSpawningstock."<<t;
      relssb_mcmc<<endl;
    }
    relssb_mcmc<<RelSpawningstock(RelSpawningstock.indexmin());
    relssb_mcmc<<RelSpawningstock.sub(RelSpawningstock.indexmin()+1,RelSpawningstock.indexmax())<<endl;
    relssb_mcmc_lines++;
  }

// Write out the matrices by weights.  
FUNCTION void write_mcmc_all()
  if(COUNTER==1 && sum(mcallwriteswitch) > 0){
     all_mcmc.open("all.mcmc");
     all_mcmc << "#years" << endl;
     for(int y = firstyear; y <= lastyear ; y++) all_mcmc << y << " ";
     all_mcmc << endl << "#ages" << endl;
     for(int a = firstage; a <= lastage ; a++) all_mcmc << a << " ";
     all_mcmc << endl;
     all_mcmc << "#N  CW  SW  Mat  F" << endl;
     all_mcmc << mcallwriteswitch << endl;  // info about what is here.  
  }
  all_mcmc << "#iter " << COUNTER << endl; 
  if(mcallwriteswitch(1)==1){ 
    all_mcmc << "#N "<< endl;
    all_mcmc << N << endl;
  }
  if(mcallwriteswitch(2)==1){ 
    all_mcmc << "#CatchWeights"<< endl; 
    all_mcmc <<  CatchWeights << endl;
  }
  if(mcallwriteswitch(3)==1){ 
    all_mcmc << "#StockWeights"<< endl; 
    all_mcmc <<  StockWeights << endl;
  }
  if(mcallwriteswitch(4)==1){ 
    all_mcmc << "#StockMaturity"<< endl; 
    all_mcmc <<  StockMaturity << endl;
  }
  if(mcallwriteswitch(5)==1){ 
    all_mcmc << "#F"<< endl; 
    all_mcmc <<  F << endl;
  }






// For short term predictions when weight is not forcasted assumes pF = pM = 0;
FUNCTION void PredictShorttermSSB(int year,int wmatYear)
   dvariable SSBRecCV = mfexp(estSSBRecParameters(3));
   dvariable SSBRecpow = estSSBRecParameters(5);
   Spawningstock(year) = 0;
   for(int age = minssbage; age <= lastage; age++)
     Spawningstock(year) += Nhat(year,age)*SSBWeights(wmatYear,age)*StockMaturity(wmatYear,age);
//     Spawningstock(year) += N(year,age)*SSBWeights(wmatYear,age)*StockMaturity(wmatYear,age)*
//     mfexp(-(natM(year,age)*PropofMbeforeSpawning(age)+F(year,age)*PropofFbeforeSpawning(age)));
   Spawningstock(year) /= 1e6;
   Totbio(year) = sum(elem_prod(SSBWeights(wmatYear),Nhat(year)))/1e6;
   SigmaSSBRec(year) = SSBRecCV/pow(SmoothDamper(Spawningstock(year)/RefSSB,Maxrelssb,Minrelssb),SSBRecpow); 
 


FUNCTION void SingleTriggerHCR(int year) 
  dvariable wfrat = 0;
  int age = 0;
  if(year == (lastoptyear+1)) CalcCatchIn1000tons(year) = FutureForCatch(year);
    // Simulate the assessment year.  
  for(int age = firstage+1; age <= lastage ; age++) Nhat(year,age)=mfexp(log(N(year,age))+AssessmentErr(year));
  CalcNaturalMortality1(year); 
  ProgF(year) = FishmortFromCatch(CalcCatchIn1000tons(year)*1e6,Nhat(year),CatchWeights(year),progsel,natM(year));

  F(year) = ProgF(year)*progsel; 
  Z(year) = F(year) + natM(year);
  PredictShorttermSSB(year,year);
  PredictedRecruitment(year) = PredictRecruitment(year); // Havent seen the yearclasses
  Nhat(year,firstage) = PredictedRecruitment(year-firstage);
  CalcCatchInNumbers(year)=elem_prod(elem_div(F(year),Z(year)),elem_prod((1.-mfexp(-Z(year))),Nhat(year)));
  CalcCatchIn1000tons(year) = sum(elem_prod(CalcCatchInNumbers(year),CatchWeights(year)))/1.0e6;
  if(year < lastyear) {
    for(age = firstage ; age < lastage ; age++) 
      Nhat(year+1,age+1)  = Nhat(year,age)*mfexp(-Z(year,age));
    Nhat(year+1,lastage) += Nhat(year,lastage)*mfexp(-Z(year,lastage));
    CalcNaturalMortality1(year+1); 
    PredictShorttermSSB(year+1,year);
    dvariable rat = Spawningstock(year+1)/Btrigger;
    ProgF(year+1) = FutureForCatch(year+1)*rat;
    if(ProgF(year+1) > FutureForCatch(year+1))  ProgF(year+1) = FutureForCatch(year+1);
    F(year+1) = ProgF(year+1)*progsel; 
    if(WeightedF == 1) {
       wfrat = CalcWeightedMeanF(F(year+1),Nhat(year+1))/ProgF(year+1); // +1e-8
       F(year+1) /= wfrat;
    }
    Z(year+1) = F(year+1) + natM(year+1);
    PredictShorttermSSB(year+1,year); // Not needed when PF = 0
    SpawningstockWithErr(year+1) = Spawningstock(year+1);
    PredictedRecruitment(year+1) = PredictRecruitment(year+1); // Havent seen the yearclasses
    Nhat(year+1,firstage) = PredictedRecruitment(year+1-firstage);
    CalcCatchInNumbers(year+1)=elem_prod(elem_div(F(year+1),Z(year+1)),elem_prod((1.-mfexp(-Z(year+1))),Nhat(year+1)));
    CalcCatchIn1000tons(year+1) = sum(elem_prod(CalcCatchInNumbers(year+1),CatchWeights(year)))/1.0e6;
    // now the stabilisers enter the picture.  They are both on all the time but can be turned off by appropriate
    // settings of parameters MaxChange=100 or LastYearsTacRatio = 0
    // Stabliliser is set on calendar year.  If there is a demand stabiliser on fishing year could be
    // implemented for this rule.  
    dvariable LastYTacRat = LastYearsTacRatio*rat; // Gradual  like saithe
    CalcCatchIn1000tons(year+1) = LastYTacRat*CurrentTac +  (1-LastYTacRat)*CalcCatchIn1000tons(year+1);  
    if( (CalcCatchIn1000tons(year+1) > Maxchange*CalcCatchIn1000tons(year)) && (Spawningstock(year+1) > Btrigger))  CalcCatchIn1000tons(year+1) =Maxchange*CalcCatchIn1000tons(year);
    if( (CalcCatchIn1000tons(year+1) < CalcCatchIn1000tons(year)/Maxchange) && (Spawningstock(year+1) > Btrigger)) CalcCatchIn1000tons(year+1) =CalcCatchIn1000tons(year)/Maxchange;
    CurrentTac = CalcCatchIn1000tons(year+1);
    FishingYearCatch(year) =  CalcCatchIn1000tons(year+1)*2/3+CalcCatchIn1000tons(year)*1/3; // FishingYearCatch(2018) is 2018/2018
 }
 ProgF(year) = FishmortFromCatch(CalcCatchIn1000tons(year)*1e6,N(year),CatchWeights(year),progsel,natM(year));



FUNCTION void BioRatioHockeystickAdviceYear(int year)
// Bases advice on stock biomass in the beginning of the year following assessment year.
// Only set up for length based HCR and ICEfish year.  Can be changed but basing on
// calendar years is much simpler.  
// Can be adapted to all kinds of HCR.  
  dvariable mincatch = 0.0;
  dvariable Catch;
  dvariable tmpTac;
  int age;
  for(age = firstage+1; age <= lastage ; age++) Nhat(year,age)=mfexp(log(N(year,age))+AssessmentErr(year));
  CalcNaturalMortality1(year); 
  tmpTac = CurrentTac;  // Current Tac is only until September 1st but still used as first proxy.  
  ProgF(year) = FishmortFromCatch(tmpTac*1e6,Nhat(year),CatchWeights(year),progsel,natM(year));
  F(year) = ProgF(year)*progsel; 
  Z(year) = F(year) + natM(year);
  for(age = firstage ; age < lastage ; age++) 
    Nhat(year+1,age+1)  = Nhat(year,age)*mfexp(-Z(year,age));
  Nhat(year+1,lastage) += Nhat(year,lastage)*mfexp(-Z(year,lastage));
  PredictShorttermSSB(year+1,year);   
  // Use length model // Last years weights used
  HCRrefbio(year+1) =  sum(elem_prod(Nhat(year+1),elem_prod(StockWeights(year),wtsel(StockWeights(year),HCRreflebreak))))/1e6;
  dvariable ratio = Spawningstock(year+1)/Btrigger;
  ratio = SmoothDamper(ratio,1.0,0.0);  // ratio max 1  do not need the smooth version.  
  dvariable Hratio = ratio*HarvestRatio; 
  dvariable LastYTacRat = LastYearsTacRatio*ratio; // Gradual  like saithe
  dvariable refcatch = Hratio*HCRrefbio(year+1);
  Catch = LastYTacRat*CurrentTac +  (1-LastYTacRat)*refcatch;
  Catch = SmoothDamper(Catch,MaxHarvestRatio*HCRrefbio(year+1),mincatch);
    
// Second iteration
  tmpTac = CurrentTac*2/3 + Catch*1/3;
  ProgF(year) = FishmortFromCatch(tmpTac*1e6,Nhat(year),CatchWeights(year),progsel,natM(year));
  F(year) = ProgF(year)*progsel; 
  Z(year) = F(year) + natM(year);
  for(age = firstage ; age < lastage ; age++) 
    Nhat(year+1,age+1)  = Nhat(year,age)*mfexp(-Z(year,age));
  Nhat(year+1,lastage) += Nhat(year,lastage)*mfexp(-Z(year,lastage));
  PredictShorttermSSB(year+1,year);   
  // Use length model // Last years weights used
  HCRrefbio(year+1) =  sum(elem_prod(Nhat(year+1),elem_prod(StockWeights(year),wtsel(StockWeights(year),HCRreflebreak))))/1e6;
  ratio = Spawningstock(year+1)/Btrigger;
  ratio = SmoothDamper(ratio,1.0,0.0);  // ratio max 1  do not need the smooth version.  
  Hratio = ratio*HarvestRatio; 
  LastYTacRat = LastYearsTacRatio*ratio; // Gradual  like saithe
  refcatch = Hratio*HCRrefbio(year+1);    
  Catch = LastYTacRat*CurrentTac +  (1-LastYTacRat)*refcatch;
  Catch = SmoothDamper(Catch,MaxHarvestRatio*HCRrefbio(year+1),mincatch);

//  Might add 3rd iteration.  

  dvariable AnnualCatch;  
  if(IceFishYear) {
     AnnualCatch =  TacLeft + Catch/3; 
     AnnualCatch = SmoothDamper(AnnualCatch,MaxHarvestRatio*HCRrefbio(year),mincatch); 
     TacLeft = Catch*2/3;
     FishingYearCatch(year) = Catch;  // FishingYearCatch(2018) is 2018/2018
  }
  CurrentTac = Catch;  
  AnnualCatch = SmoothDamper(AnnualCatch,MaxHarvestRatio*HCRrefbio(year),mincatch);
  ProgF(year) = FishmortFromCatch(AnnualCatch*1e6,N(year),CatchWeights(year),progsel,natM(year));




// Bunch of small functions

//*****************************************************************


// Function to treat misreporting.  Mostly mackerel directed i.e misreporting
// that stops in certain year.  
FUNCTION void ScaleCatches()
   Misreporting  = 1;
   int yr;
   for(yr = firstyear; yr <= LastMisReportingYear; yr++)
     Misreporting(yr) = mfexp(logMisreportingRatio); 
   for(yr = firstyear; yr <= LastMisReportingYear; yr++){
     ObsCatchInNumbers(yr) =  ObsCatchInNumbersInput(yr)*Misreporting(yr);
     CatchIn1000tons(yr) = CatchIn1000tonsInput(yr)*Misreporting(yr);
   }
   



// Logit function simplest version;
FUNCTION void CalcFishingMortality1a(int year) 
   int age;
   for(age = firstcatchage; age <= lastage; age++) 
      F(year,age) = mfexp(lnMeanEffort+lnEffort(year))*1/(1+mfexp(-Catchlogitslope*(age-Catchlogitage50)));


// Separable model with sel per age estimated up to a certain age.    
FUNCTION void CalcFishingMortality1b(int year) 
   
   int age;
   for(age = firstcatchage; age <=  lastage-nfixedselages; age++) 
       F(year,age) = mfexp(lnMeanEffort+lnEffort(year)+EstimatedSelection(age,parcolnr(year)));
   for(age = lastage-nfixedselages+1; age <=  lastage; age++) // Sel 1.  
       F(year,age) = mfexp(lnMeanEffort+lnEffort(year));


// Seperable logit in terms of log stock weight.  
FUNCTION void CalcFishingMortality1c(int year) 
   
   int age;
   dvariable sel;
   for(age = firstcatchage; age <=  lastage; age++) {
      sel = 1./(1+mfexp(-selslope*log(StockWeights(year,age)/fullselwt)));
      F(year,age) = mfexp(lnMeanEffort+lnEffort(year))*sel;
   }





// Logit function with proportion of an age group put in as a multiplier i.e more for larger yearclasses.   
FUNCTION void CalcFishingMortality3(int year) 
   int age;
   dvariable Biomass = 0; 
   dvar_vector proportion(firstage,lastage);
   proportion = 0;
   for( age = firstcatchage; age <= lastage; age++) 
      Biomass += N(year,age)*StockWeights(year,age);
   for( age = firstcatchage; age <= lastage; age++) 
      proportion(age) = N(year,age)*StockWeights(year,age)/Biomass;
   
   for(age = firstcatchage; age <= lastage; age++) 
      F(year,age) = mfexp(lnMeanEffort+lnEffort(year))*1/(1+mfexp(-Catchlogitslope*(age-Catchlogitage50)+proportion(age)*AbundanceMultiplier));                 


   


FUNCTION void CalcNaturalMortality1(int year)
   int i;
   int j;
   dvariable age;
   for(j = firstage; j <= lastage; j++)
	natM(year,j) = Mdata(j);
   if(estMlastagephase > 0) natM(year,lastage) = mfexp(logMoldest); 


//  Smooth Roof and Floor.  
FUNCTION dvariable  SmoothDamper(dvariable x, dvariable Roof,dvariable Floor) 
  dvariable deltax = 0.01;
  if(Roof == Floor) return(x); 
  dvariable lb = 1.0 - deltax/2.0;
  dvariable ub = 1.0 + deltax/2.0;
  if(x <= lb* Roof && x >= ub*Floor) return x;
  if(x >= ub*Roof) return Roof;
  if(x <= lb*Floor) return Floor;
  if(x <= ub*Roof && x >= lb*Roof) {
    dvariable y = (x - ub*Roof);
    return Roof - 0.5/deltax/Roof*y*y;
  }
  if(x >= lb*Floor && x <= ub*Floor) {
    dvariable  y = (x - lb*Floor);
    return Floor +0.5/deltax/Floor*y*y;
  }

// Proportion of biomass above lebreak
FUNCTION dvar_vector wtsel(dvar_vector StockWts,dvariable lebreak)
  return(1.0/(1.0+mfexp(-25.224-5.307*log(StockWts/pow(lebreak,3.0)))));  

// = minage therefore set to minssbage + 1 for blue whiting.  
FUNCTION dvariable AssYearSSB() 
   dvariable tmpssb= 0;
   for(int age = minssbage+1; age <= lastage; age++)
     tmpssb += N(lastoptyear+1,age)*SSBWeights(lastoptyear,age)*StockMaturity(lastoptyear,age)*
     mfexp(-(natM(lastoptyear,age)*PropofMbeforeSpawning(age)+F(lastoptyear,age)*PropofFbeforeSpawning(age)));
   tmpssb/= 1e6; 
   return tmpssb; 
 



