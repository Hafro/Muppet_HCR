#ifdef DEBUG
  #ifndef __SUNPRO_C
    #include <cfenv>
    #include <cstdlib>
  #endif
#endif
  #include <admodel.h>
  // Might have to calculate progsel every year if it is function of size.  
  adstring outputprefix;
  adstring outputpostfix;
  ofstream all_mcmc;
  ofstream likelihood_mcmc;
  ofstream migration_mcmc;
  ofstream recruitment_mcmc;
  ofstream initpopulation_mcmc;
  ofstream assessmenterror_mcmc;
  ofstream implementationerror_mcmc;  
  ofstream estimatedselection_mcmc;
  ofstream parameter_mcmc;
  ofstream surveypower_mcmc;
  ofstream surveyq_mcmc;
  ofstream effort_mcmc;
  ofstream catch_mcmc;
  ofstream fishyearcatch_mcmc; 
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
#include <admodel.h>
#include <contrib.h>

  extern "C"  {
    void ad_boundf(int i);
  }
#include <muppet.htp>

model_data::model_data(int argc,char * argv[]) : ad_comm(argc,argv)
{
 debug_input_flag=1;
 ofstream ofs("input.log");
  catchfilename.allocate("catchfilename");
 ofs << "catchfilename " << catchfilename << endl;
  totalcatchfilename.allocate("totalcatchfilename");
 ofs << "totalcatchfilename " << totalcatchfilename << endl;
  catchresidualfilename.allocate("catchresidualfilename");
 ofs << "catchresidualfilename " << catchresidualfilename << endl;
  INITCOND.allocate("INITCOND");
 ofs << "INITCOND " << INITCOND << endl;
  BackWards.allocate("BackWards");
 ofs << "BackWards " << BackWards << endl;
  firstyear.allocate("firstyear");
  lastoptyear.allocate("lastoptyear");
  nsimuyears.allocate("nsimuyears");
  lastdatayear.allocate("lastdatayear");
  firstage.allocate("firstage");
  lastdataage.allocate("lastdataage");
  lastage.allocate("lastage");
  firstcatchage.allocate("firstcatchage");
  minssbage.allocate("minssbage");
  plusgroup.allocate("plusgroup");
  recrdatadelay.allocate("recrdatadelay");
  nfixedselages.allocate("nfixedselages");
  estMlastagephase.allocate("estMlastagephase");
 ofs << "firstyear " << firstyear << "lastoptyear " << lastoptyear << "nsimuyears " << nsimuyears; 
 ofs << "lastdatayear " << lastdatayear  << endl;
lastyear = lastoptyear  + nsimuyears;
noptyears = lastoptyear - firstyear + 1; 
nyears = noptyears + nsimuyears;
 ofs  << " firstage " << firstage << " lastdatage " << lastdataage << " lastage " << lastage << " firstcatchage " << firstcatchage << " plusgroup " << plusgroup;
 ofs << " recrdatadelay " << recrdatadelay <<  " nfixedselages " << nfixedselages <<  " estMlastagephase " << estMlastagephase << endl;
nages = lastage - firstage + 1;
  stockparametersfilename.allocate("stockparametersfilename");
 ofs << "stockparametersfilename " << stockparametersfilename << endl;  
  catchparametersfilename.allocate("catchparametersfilename");
 ofs << "catchparametersfilename " << catchparametersfilename << endl;  
  likelihoodparametersfilename.allocate("likelihoodparametersfilename");
 ofs << "likelihoodparametersfilename " << likelihoodparametersfilename << endl;  // wt on likelihood par etc.  
  outputparametersfilename.allocate("outputparametersfilename");
 ofs << "outputparametersfilename " << outputparametersfilename << endl;  
  nsurveys.allocate("nsurveys");
 ofs << "nsurveys " << nsurveys << endl;
  surveyfirstyear.allocate(1,nsurveys);
  surveylastyear.allocate(1,nsurveys);
  surveyfirstage.allocate(1,nsurveys);
  surveylastage.allocate(1,nsurveys);
  surveyfirstagewithconstantcatchability.allocate(1,nsurveys);
  surveyfirstagewithfullcatchability.allocate(1,nsurveys);
  surveytimefromlastyear.allocate(1,nsurveys);
  surveytype.allocate(1,nsurveys);
  surveyweightsgiven.allocate(1,nsurveys);
  surveycorrphase.allocate(1,nsurveys);
  surveylogitphase.allocate(1,nsurveys);
int i,j;
ivector tmpsurveydata(1,10);
adstring tmpsurveyfilename;  // Have to pass this to main program through file.
ofstream surveyfile("SURVEYFILES.DAT"); // The temporary file.  
for (i = 1; i<=nsurveys; i++) {
*global_datafile  >> tmpsurveydata;
 ofs << "survey nr" << i << " - " << tmpsurveydata << "  ";
 surveyfirstyear(i) = tmpsurveydata(1);
 surveylastyear(i) = tmpsurveydata(2);
 surveyfirstage(i) = tmpsurveydata(3);
 surveylastage(i) = tmpsurveydata(4);
 surveyfirstagewithfullcatchability(i) = tmpsurveydata(5);
 surveyfirstagewithconstantcatchability(i) = tmpsurveydata(6);
 surveytimefromlastyear(i) = tmpsurveydata(7);
 surveytype(i) = tmpsurveydata(8);
 surveycorrphase(i) = tmpsurveydata(9);
 surveylogitphase(i) = tmpsurveydata(10);
 if(surveylogitphase(i) > 0)  surveyfirstagewithfullcatchability(i) = surveyfirstage(i); // one q level estimated
 if(surveylogitphase(i) > 0)  surveyfirstagewithconstantcatchability(i) = surveyfirstage(i);
 if(surveyfirstyear(i) < firstyear) surveyfirstyear(i) = firstyear;
 if(surveylastyear(i) > lastyear+ surveytimefromlastyear(i)) 
    surveylastyear(i) =  lastyear+ surveytimefromlastyear(i);
 if(surveyfirstage(i)  < firstage) surveyfirstage(i) = firstage;
 if(surveylastage(i) > lastage) surveylastage(i) = lastage;
 if(surveyfirstagewithconstantcatchability(i) > lastage )
      surveyfirstagewithconstantcatchability(i) = lastage;
 for (j = 1; j <= 3; j++) {
*global_datafile  >> tmpsurveyfilename;
 ofs << tmpsurveyfilename << " "; 
 surveyfile << tmpsurveyfilename << " ";
 }
 surveyfile << endl;
 ofs << endl; 
}
surveyfile.close();
 minsurveyfirstage = min(surveyfirstage);
 maxsurveyfirstagewithfullcatchability = max(surveyfirstagewithfullcatchability);
 maxsurveyfirstagewithconstantcatchability = max(surveyfirstagewithconstantcatchability);
  SSBRectype.allocate("SSBRectype");
  SSBRecParameters.allocate(1,6,"SSBRecParameters");
  SSBRecSwitches.allocate(1,6,"SSBRecSwitches");
ofs << "SSBRectype " << SSBRectype << endl;
ofs  << " Rmax " << SSBRecParameters(1) << " SSBmax " << SSBRecParameters(2) ; 
ofs << " SSBReccv " << SSBRecParameters(3)  ;
ofs << " SSBReccorr " <<  SSBRecParameters(4) << " SSBRecpow" << SSBRecParameters(5)  << endl;
ofs << " Timetrendinrecruitment" <<  SSBRecParameters(6) << endl; // should really be called productivity change
ofs << " SSBRecSwitches " << SSBRecSwitches << endl;
  MigrationNumbers.allocate("MigrationNumbers");
 ofs << "MigrationNumbers " << MigrationNumbers << endl ;
  PrognosisFilename.allocate("PrognosisFilename");
 ofs << "PrognosisFilename " << PrognosisFilename  << endl;
  WeightAndMaturityDatafilename.allocate("WeightAndMaturityDatafilename");
ofs << "WeightAndMaturityDatafilename" <<  WeightAndMaturityDatafilename << endl;   
  number_of_seperable_periods.allocate("number_of_seperable_periods");
ofs <<  "number_of_seperable_periods " <<  number_of_seperable_periods << endl;
  prodchangeyear.allocate("prodchangeyear");
ofs <<  "prodchangeyear " <<  prodchangeyear << endl;
  OptimDatafilename.allocate("OptimDatafilename");
ofs << "OptimDatafilename " <<  OptimDatafilename << endl;  
 ad_comm::change_datafile_name(OptimDatafilename);
  logSSBRecLowerbounds.allocate(1,6,"logSSBRecLowerbounds");
ofs << "logSSBRecLowerbounds " << logSSBRecLowerbounds << endl;
  logSSBRecUpperbounds.allocate(1,6,"logSSBRecUpperbounds");
ofs << "logSSBRecUpperbounds " << logSSBRecUpperbounds << endl;
  logminssbsurveyCV.allocate("logminssbsurveyCV");
ofs << "logminssbsurveyCV " << logminssbsurveyCV << endl;
  logminsurCV.allocate("logminsurCV");
ofs << "logminsurCV " << logminsurCV << endl;
  surveylnqphase.allocate("surveylnqphase");
ofs << "surveylnqphase " << surveylnqphase << endl;
  surveypowphase.allocate("surveypowphase");
ofs << "surveypowphase " << surveypowphase << endl;
  surveybiopowphase.allocate(1,nsurveys,"surveybiopowphase");
ofs << "surveybiopowphase " << surveybiopowphase << endl;
  estselphase.allocate("estselphase");
ofs << "estselphase " << estselphase << endl;
  catchlogitphase.allocate("catchlogitphase");
ofs << "catchlogitphase " << catchlogitphase << endl;
  catchlogitsizephase.allocate("catchlogitsizephase");
ofs << "catchlogitsizephase " << catchlogitsizephase << endl;
  misreportingphase.allocate("misreportingphase");
ofs <<  "misreportingphase " <<  misreportingphase << endl;
  Mmultphase.allocate("Mmultphase");
ofs <<  "Mmultphase " <<  Mmultphase << endl;
  FutureForCatch.allocate(lastoptyear+1,lastyear);
  RefBiominage.allocate(1,2);
  mcallwriteswitch.allocate(1,6);
  mcwriteswitch.allocate(1,23);
  MigrationAges.allocate(1,MigrationNumbers);
  MigrationYears.allocate(1,MigrationNumbers);
  parcolnr.allocate(firstyear,lastyear);
 if(BackWards == 0) {catagephase1 = 1; catagephase2 = 2;catagephase3 = 3;catagephase4 = 4; vpaphase1 = -1; vpaphase2= -1; vpaphase3 =-1;}
 if(BackWards == 1) {catagephase1 = -1; catagephase2 = -1;catagephase3 = -1;catagephase4 = -1; vpaphase1 = 1; vpaphase2= 2; vpaphase3=4;}
 firstestage = firstage;
 if(firstage == 0) firstestage = 1;
}

void model_parameters::initializationfunction(void)
{
  logMoldest.set_initial_value(-1.6);
  logFoldestmult.set_initial_value(0);
}

model_parameters::model_parameters(int sz,int argc,char * argv[]) : 
 model_data(argc,argv) , function_minimizer(sz)
{
  initializationfunction();
  logMisreportingRatio.allocate(-1,1,misreportingphase,"logMisreportingRatio");
  logFoldestmult.allocate(-1,1,-2,"logFoldestmult");
  logMoldest.allocate(-3,-0.5,estMlastagephase,"logMoldest");
  logMmultiplier.allocate(-2,2,Mmultphase,"logMmultiplier");
  lnMigrationAbundance.allocate(1,MigrationNumbers,1,13,catagephase1,"lnMigrationAbundance");
  lnMeanRecr.allocate(4,20,catagephase1,"lnMeanRecr");
  lnRecr.allocate(firstyear,lastoptyear+firstage-recrdatadelay,-6,6,catagephase2,"lnRecr");
  lnMeanInitialpop.allocate(4,17,catagephase1,"lnMeanInitialpop");
  lnInitialpop.allocate(firstage+1,lastage,-7,7,catagephase2,"lnInitialpop");
  EstimatedSelection.allocate(firstcatchage,lastage-nfixedselages,1,number_of_seperable_periods,-5,0.2,estselphase,"EstimatedSelection");
  Catchlogitslope.allocate(0.05,5,catchlogitphase,"Catchlogitslope");
  Catchlogitage50.allocate(1,11,catchlogitphase,"Catchlogitage50");
  selslope.allocate(0.2,5,catchlogitsizephase,"selslope");
  fullselwt.allocate(500,3000,catchlogitsizephase,"fullselwt");
  weighterr.allocate(lastoptyear+1,lastyear,"weighterr");
  #ifndef NO_AD_INITIALIZE
    weighterr.initialize();
  #endif
  recrweighterr.allocate(lastoptyear+1,lastyear,"recrweighterr");
  #ifndef NO_AD_INITIALIZE
    recrweighterr.initialize();
  #endif
  catchweighterr.allocate(lastoptyear+1,lastyear,"catchweighterr");
  #ifndef NO_AD_INITIALIZE
    catchweighterr.initialize();
  #endif
  selerr.allocate(lastoptyear+1,lastyear,"selerr");
  #ifndef NO_AD_INITIALIZE
    selerr.initialize();
  #endif
  logSigmaCmultiplier.allocate(-1,1,catagephase4,"logSigmaCmultiplier");
  AbundanceMultiplier.allocate(-10,10,-6,"AbundanceMultiplier");
  lnMeanEffort.allocate(-3,3,catagephase1,"lnMeanEffort");
  lnEffort.allocate(firstyear,lastoptyear,-4,4,catagephase2,"lnEffort");
  meanlogSurvivors.allocate(4,17,vpaphase1,"meanlogSurvivors");
  logSurvivors.allocate(firstestage,lastage-1,-6,6,vpaphase2,"logSurvivors");
  Surveylikelihood.allocate(1,nsurveys,"Surveylikelihood");
  #ifndef NO_AD_INITIALIZE
    Surveylikelihood.initialize();
  #endif
  SurveylikelihoodWeights.allocate(1,nsurveys,"SurveylikelihoodWeights");
  #ifndef NO_AD_INITIALIZE
    SurveylikelihoodWeights.initialize();
  #endif
  SurveyPowerest.allocate(1,nsurveys,minsurveyfirstage,maxsurveyfirstagewithconstantcatchability,1,3,surveypowphase,"SurveyPowerest");
dvector surveybiopowlb(1,nsurveys); //0.02
dvector surveybiopowub(1,nsurveys); //0.85
 for(int i = 1;i <= nsurveys; i++)  surveybiopowlb(i) = 0.5;
 for(int i = 1;i <= nsurveys; i++) surveybiopowub(i) = 2;
  surveybiopow.allocate(1,nsurveys,surveybiopowlb,surveybiopowub,surveybiopowphase,"surveybiopow");
  SigmaSurveypar.allocate(1,nsurveys,-5,3,catagephase4,"SigmaSurveypar");
  SurveylnQest.allocate(1,nsurveys,minsurveyfirstage,maxsurveyfirstagewithfullcatchability,-30,15,4,"SurveylnQest");
  surveylogitslope.allocate(1,nsurveys,0.1,3,4,"surveylogitslope");
  surveylogitage50.allocate(1,nsurveys,-2,12,4,"surveylogitage50");
dvector scorrlb(1,nsurveys); //0.02
dvector scorrub(1,nsurveys); //0.85
 for(int i = 1;i <= nsurveys; i++) scorrlb(i) =0.0005;
 for(int i = 1;i <= nsurveys; i++) scorrub(i) =0.95;
ivector scorrphase(1,nsurveys); //-1
scorrphase = ivector(surveycorrphase);
  Surveycorr.allocate(1,nsurveys,scorrlb,scorrub,scorrphase,"Surveycorr");
  logSigmaSurvey.allocate(1,nsurveys,firstage,lastage,logminsurCV,1,vpaphase3,"logSigmaSurvey");
  logSigmaSurveybio.allocate(1,nsurveys,logminssbsurveyCV,-0.7,5,"logSigmaSurveybio");
ivector srphase(1,6);
srphase = ivector(SSBRecSwitches);
  estSSBRecParameters.allocate(1,6,logSSBRecLowerbounds,logSSBRecUpperbounds,srphase,"estSSBRecParameters");
  firsttime.allocate("firsttime");
  #ifndef NO_AD_INITIALIZE
  firsttime.initialize();
  #endif
  ObsCatchInNumbers.allocate(firstyear,lastyear,firstage,lastage,"ObsCatchInNumbers");
  #ifndef NO_AD_INITIALIZE
    ObsCatchInNumbers.initialize();
  #endif
  ObsCatchInNumbersInput.allocate(firstyear,lastyear,firstage,lastage,"ObsCatchInNumbersInput");
  #ifndef NO_AD_INITIALIZE
    ObsCatchInNumbersInput.initialize();
  #endif
  CatchDiff.allocate(firstyear,lastyear,firstage,lastage,"CatchDiff");
  #ifndef NO_AD_INITIALIZE
    CatchDiff.initialize();
  #endif
  CatchWeightsData.allocate(firstyear,lastyear,firstage,lastage,"CatchWeightsData");
  #ifndef NO_AD_INITIALIZE
    CatchWeightsData.initialize();
  #endif
  StockWeightsData.allocate(firstyear,lastyear,firstage,lastage,"StockWeightsData");
  #ifndef NO_AD_INITIALIZE
    StockWeightsData.initialize();
  #endif
  SSBWeightsData.allocate(firstyear,lastyear,firstage,lastage,"SSBWeightsData");
  #ifndef NO_AD_INITIALIZE
    SSBWeightsData.initialize();
  #endif
  StockMaturityData.allocate(firstyear,lastyear,firstage,lastage,"StockMaturityData");
  #ifndef NO_AD_INITIALIZE
    StockMaturityData.initialize();
  #endif
  CatchWeights.allocate(firstyear,lastyear,firstage,lastage,"CatchWeights");
  #ifndef NO_AD_INITIALIZE
    CatchWeights.initialize();
  #endif
  StockWeights.allocate(firstyear,lastyear,firstage,lastage,"StockWeights");
  #ifndef NO_AD_INITIALIZE
    StockWeights.initialize();
  #endif
  SSBWeights.allocate(firstyear,lastyear,firstage,lastage,"SSBWeights");
  #ifndef NO_AD_INITIALIZE
    SSBWeights.initialize();
  #endif
  StockMaturity.allocate(firstyear,lastyear,firstage,lastage,"StockMaturity");
  #ifndef NO_AD_INITIALIZE
    StockMaturity.initialize();
  #endif
  N.allocate(firstyear,lastyear,firstage,lastage,"N");
  #ifndef NO_AD_INITIALIZE
    N.initialize();
  #endif
  Nhat.allocate(firstyear,lastyear,firstage,lastage,"Nhat");
  #ifndef NO_AD_INITIALIZE
    Nhat.initialize();
  #endif
  F.allocate(firstyear,lastyear,firstage,lastage,"F");
  #ifndef NO_AD_INITIALIZE
    F.initialize();
  #endif
  natM.allocate(firstyear,lastyear,firstage,lastage,"natM");
  #ifndef NO_AD_INITIALIZE
    natM.initialize();
  #endif
  Z.allocate(firstyear,lastyear,firstage,lastage,"Z");
  #ifndef NO_AD_INITIALIZE
    Z.initialize();
  #endif
  PropInCatch.allocate(firstyear,lastyear,firstage,lastage,"PropInCatch");
  #ifndef NO_AD_INITIALIZE
    PropInCatch.initialize();
  #endif
  TotalCalcCatchInNumbers.allocate(firstyear,lastyear,"TotalCalcCatchInNumbers");
  #ifndef NO_AD_INITIALIZE
    TotalCalcCatchInNumbers.initialize();
  #endif
  CalcCatchIn1000tons.allocate(firstyear,lastyear,"CalcCatchIn1000tons");
  #ifndef NO_AD_INITIALIZE
    CalcCatchIn1000tons.initialize();
  #endif
  TotCatchIn1000tons.allocate(firstyear,lastyear,"TotCatchIn1000tons");
  #ifndef NO_AD_INITIALIZE
    TotCatchIn1000tons.initialize();
  #endif
  CatchIn1000tons.allocate(firstyear,lastyear,"CatchIn1000tons");
  #ifndef NO_AD_INITIALIZE
    CatchIn1000tons.initialize();
  #endif
  CatchIn1000tonsInput.allocate(firstyear,lastyear,"CatchIn1000tonsInput");
  #ifndef NO_AD_INITIALIZE
    CatchIn1000tonsInput.initialize();
  #endif
  FishingYearCatch.allocate(firstyear,lastyear,"FishingYearCatch");
  #ifndef NO_AD_INITIALIZE
    FishingYearCatch.initialize();
  #endif
  CalcCatchInNumbers.allocate(firstyear,lastyear,firstage,lastage,"CalcCatchInNumbers");
  #ifndef NO_AD_INITIALIZE
    CalcCatchInNumbers.initialize();
  #endif
  meansel.allocate(firstage,lastage,"meansel");
  #ifndef NO_AD_INITIALIZE
    meansel.initialize();
  #endif
  progsel.allocate(firstage,lastage,"progsel");
  #ifndef NO_AD_INITIALIZE
    progsel.initialize();
  #endif
  ProgF.allocate(lastoptyear+1,lastyear,"ProgF");
  #ifndef NO_AD_INITIALIZE
    ProgF.initialize();
  #endif
  SigmaC.allocate(firstage,lastage,"SigmaC");
  #ifndef NO_AD_INITIALIZE
    SigmaC.initialize();
  #endif
  SigmaCinp.allocate(firstage,lastage,"SigmaCinp");
  #ifndef NO_AD_INITIALIZE
    SigmaCinp.initialize();
  #endif
  Mdata.allocate(firstage,lastage,"Mdata");
  #ifndef NO_AD_INITIALIZE
    Mdata.initialize();
  #endif
  PredictedRecruitment.allocate(firstyear,lastyear,"PredictedRecruitment");
  #ifndef NO_AD_INITIALIZE
    PredictedRecruitment.initialize();
  #endif
  Recruitment.allocate(firstyear,lastyear,"Recruitment");
  #ifndef NO_AD_INITIALIZE
    Recruitment.initialize();
  #endif
  RecruitmentResiduals.allocate(firstyear,lastyear,"RecruitmentResiduals");
  #ifndef NO_AD_INITIALIZE
    RecruitmentResiduals.initialize();
  #endif
  Misreporting.allocate(firstyear,lastoptyear,"Misreporting");
  #ifndef NO_AD_INITIALIZE
    Misreporting.initialize();
  #endif
  Foldestinp.allocate(firstyear,lastdatayear+1,lastage-1,lastage,"Foldestinp");
  #ifndef NO_AD_INITIALIZE
    Foldestinp.initialize();
  #endif
  Noldestinp.allocate(firstyear,lastdatayear+1,lastage-1,lastage,"Noldestinp");
  #ifndef NO_AD_INITIALIZE
    Noldestinp.initialize();
  #endif
  RefBio1.allocate(firstyear,lastyear,"RefBio1");
  #ifndef NO_AD_INITIALIZE
    RefBio1.initialize();
  #endif
  RefBio2.allocate(firstyear,lastyear,"RefBio2");
  #ifndef NO_AD_INITIALIZE
    RefBio2.initialize();
  #endif
  HCRrefbio.allocate(firstyear,lastyear,"HCRrefbio");
  #ifndef NO_AD_INITIALIZE
    HCRrefbio.initialize();
  #endif
  HCRBproxy.allocate(firstyear,lastyear,"HCRBproxy");
  #ifndef NO_AD_INITIALIZE
    HCRBproxy.initialize();
  #endif
  N3.allocate(firstyear,lastyear,"N3");
  #ifndef NO_AD_INITIALIZE
    N3.initialize();
  #endif
  N1st.allocate(firstyear,lastyear,"N1st");
  #ifndef NO_AD_INITIALIZE
    N1st.initialize();
  #endif
  CbioR.allocate(firstyear,lastyear,"CbioR");
  #ifndef NO_AD_INITIALIZE
    CbioR.initialize();
  #endif
  Totbio.allocate(firstyear,lastyear,"Totbio");
  #ifndef NO_AD_INITIALIZE
    Totbio.initialize();
  #endif
  PredRefF.allocate(lastoptyear-5,lastyear,"PredRefF");
  #ifndef NO_AD_INITIALIZE
    PredRefF.initialize();
  #endif
  PredSpawningstock.allocate(lastoptyear-5,lastyear,"PredSpawningstock");
  #ifndef NO_AD_INITIALIZE
    PredSpawningstock.initialize();
  #endif
  PredN.allocate(lastoptyear-5,lastyear,"PredN");
  #ifndef NO_AD_INITIALIZE
    PredN.initialize();
  #endif
  Survivors.allocate(firstage,lastage,"Survivors");
  #ifndef NO_AD_INITIALIZE
    Survivors.initialize();
  #endif
  CbioRreflebreak.allocate("CbioRreflebreak");
  #ifndef NO_AD_INITIALIZE
  CbioRreflebreak.initialize();
  #endif
  RefF.allocate(firstyear,lastyear,"RefF");
  Spawningstock.allocate(firstyear,lastyear,"Spawningstock");
  SpawningstockWithErr.allocate(firstyear,lastyear,"SpawningstockWithErr");
  #ifndef NO_AD_INITIALIZE
    SpawningstockWithErr.initialize();
  #endif
  RelSpawningstock.allocate(firstyear,lastyear,"RelSpawningstock");
  SigmaSSBRec.allocate(firstyear,lastyear,"SigmaSSBRec");
  #ifndef NO_AD_INITIALIZE
    SigmaSSBRec.initialize();
  #endif
  EggProduction.allocate(firstyear,lastyear,"EggProduction");
  #ifndef NO_AD_INITIALIZE
    EggProduction.initialize();
  #endif
  TimeDrift.allocate(firstyear,lastyear,"TimeDrift");
  #ifndef NO_AD_INITIALIZE
    TimeDrift.initialize();
  #endif
  SurveyPropOfF.allocate(1,nsurveys,"SurveyPropOfF");
  #ifndef NO_AD_INITIALIZE
    SurveyPropOfF.initialize();
  #endif
  SurveyPropOfM.allocate(1,nsurveys,"SurveyPropOfM");
  #ifndef NO_AD_INITIALIZE
    SurveyPropOfM.initialize();
  #endif
  SurveyResolution.allocate(1,nsurveys,firstage,lastage,"SurveyResolution");
  #ifndef NO_AD_INITIALIZE
    SurveyResolution.initialize();
  #endif
  SigmaSurveyInp.allocate(1,nsurveys,firstage,lastage,"SigmaSurveyInp");
  #ifndef NO_AD_INITIALIZE
    SigmaSurveyInp.initialize();
  #endif
  SigmaSurvey.allocate(1,nsurveys,firstage,lastage,"SigmaSurvey");
  #ifndef NO_AD_INITIALIZE
    SigmaSurvey.initialize();
  #endif
  SurveylnQ.allocate(1,nsurveys,firstage,lastage,"SurveylnQ");
  #ifndef NO_AD_INITIALIZE
    SurveylnQ.initialize();
  #endif
  SurveyPower.allocate(1,nsurveys,firstage,lastage,"SurveyPower");
  #ifndef NO_AD_INITIALIZE
    SurveyPower.initialize();
  #endif
  ObsSurveyNr.allocate(1,nsurveys,firstyear,lastyear,firstage,lastage,"ObsSurveyNr");
  #ifndef NO_AD_INITIALIZE
    ObsSurveyNr.initialize();
  #endif
  CalcSurveyNr.allocate(1,nsurveys,firstyear,lastyear,firstage,lastage,"CalcSurveyNr");
  #ifndef NO_AD_INITIALIZE
    CalcSurveyNr.initialize();
  #endif
  SurveyResiduals.allocate(1,nsurveys,firstyear,lastyear,firstage,lastage,"SurveyResiduals");
  #ifndef NO_AD_INITIALIZE
    SurveyResiduals.initialize();
  #endif
  SurveyWeights.allocate(1,nsurveys,firstyear,lastyear,firstage,lastage,"SurveyWeights");
  #ifndef NO_AD_INITIALIZE
    SurveyWeights.initialize();
  #endif
  CalcSurveyBiomassProportion.allocate(1,nsurveys,firstyear,lastyear,firstage,lastage,"CalcSurveyBiomassProportion");
  #ifndef NO_AD_INITIALIZE
    CalcSurveyBiomassProportion.initialize();
  #endif
  ObsSurveyBiomassProportion.allocate(1,nsurveys,firstyear,lastyear,firstage,lastage,"ObsSurveyBiomassProportion");
  #ifndef NO_AD_INITIALIZE
    ObsSurveyBiomassProportion.initialize();
  #endif
  SurveylnYeareffect.allocate(1,nsurveys,firstyear,lastyear,"SurveylnYeareffect");
  #ifndef NO_AD_INITIALIZE
    SurveylnYeareffect.initialize();
  #endif
  ObsSurveyBiomass.allocate(1,nsurveys,firstyear,lastyear,"ObsSurveyBiomass");
  #ifndef NO_AD_INITIALIZE
    ObsSurveyBiomass.initialize();
  #endif
  ObsSurveyTotnr.allocate(1,nsurveys,firstyear,lastyear,"ObsSurveyTotnr");
  #ifndef NO_AD_INITIALIZE
    ObsSurveyTotnr.initialize();
  #endif
  CalcSurveyBiomass.allocate(1,nsurveys,firstyear,lastyear,"CalcSurveyBiomass");
  #ifndef NO_AD_INITIALIZE
    CalcSurveyBiomass.initialize();
  #endif
  CalcSurveyTotnr.allocate(1,nsurveys,firstyear,lastyear,"CalcSurveyTotnr");
  #ifndef NO_AD_INITIALIZE
    CalcSurveyTotnr.initialize();
  #endif
  PropofFbeforeSpawning.allocate(minssbage,lastage,"PropofFbeforeSpawning");
  #ifndef NO_AD_INITIALIZE
    PropofFbeforeSpawning.initialize();
  #endif
  PropofMbeforeSpawning.allocate(minssbage,lastage,"PropofMbeforeSpawning");
  #ifndef NO_AD_INITIALIZE
    PropofMbeforeSpawning.initialize();
  #endif
  RefSSB.allocate("RefSSB");
  #ifndef NO_AD_INITIALIZE
  RefSSB.initialize();
  #endif
  Minrelssb.allocate("Minrelssb");
  #ifndef NO_AD_INITIALIZE
  Minrelssb.initialize();
  #endif
  Maxrelssb.allocate("Maxrelssb");
  #ifndef NO_AD_INITIALIZE
  Maxrelssb.initialize();
  #endif
  CurrentTac.allocate("CurrentTac");
  #ifndef NO_AD_INITIALIZE
  CurrentTac.initialize();
  #endif
  CurrentCatch.allocate("CurrentCatch");
  #ifndef NO_AD_INITIALIZE
  CurrentCatch.initialize();
  #endif
  TacLeft.allocate("TacLeft");
  #ifndef NO_AD_INITIALIZE
  TacLeft.initialize();
  #endif
  Mmultiplier.allocate("Mmultiplier");
  #ifndef NO_AD_INITIALIZE
  Mmultiplier.initialize();
  #endif
  AssessmentErr.allocate(lastoptyear+1,lastyear,"AssessmentErr");
  #ifndef NO_AD_INITIALIZE
    AssessmentErr.initialize();
  #endif
  ImplementationErr.allocate(lastoptyear+1,lastyear,"ImplementationErr");
  #ifndef NO_AD_INITIALIZE
    ImplementationErr.initialize();
  #endif
  MeanSel.allocate(firstage,lastage,"MeanSel");
  #ifndef NO_AD_INITIALIZE
    MeanSel.initialize();
  #endif
  CatchResolution.allocate("CatchResolution");
  #ifndef NO_AD_INITIALIZE
  CatchResolution.initialize();
  #endif
  Likeliweights.allocate(1,10,"Likeliweights");
  #ifndef NO_AD_INITIALIZE
    Likeliweights.initialize();
  #endif
  sigmatotalcatch.allocate("sigmatotalcatch");
  #ifndef NO_AD_INITIALIZE
  sigmatotalcatch.initialize();
  #endif
  LnLikelicomp.allocate(1,10,"LnLikelicomp");
  #ifndef NO_AD_INITIALIZE
    LnLikelicomp.initialize();
  #endif
  MaxFishMort.allocate("MaxFishMort");
  #ifndef NO_AD_INITIALIZE
  MaxFishMort.initialize();
  #endif
  largenumber.allocate("largenumber");
  #ifndef NO_AD_INITIALIZE
  largenumber.initialize();
  #endif
  LNMEANEFFORT.allocate("LNMEANEFFORT");
  #ifndef NO_AD_INITIALIZE
  LNMEANEFFORT.initialize();
  #endif
  LnLikely.allocate("LnLikely");
  prior_function_value.allocate("prior_function_value");
  likelihood_function_value.allocate("likelihood_function_value");
}

void model_parameters::set_runtime(void)
{
  dvector temp("{.1, .01, .0001, .0000001}");
  convergence_criteria.allocate(temp.indexmin(),temp.indexmax());
  convergence_criteria=temp;
  dvector temp1("{800000}");
  maximum_function_evaluations.allocate(temp1.indexmin(),temp1.indexmax());
  maximum_function_evaluations=temp1;
}

void model_parameters::preliminary_calculations(void)
{

#if defined(USE_ADPVM)

  admaster_slave_variable_interface(*this);

#endif
 AgeModel = 1; // default value if refbio is output in Frules totbio is given
 HCRrefAge = firstage; // default value 
 logSigmaSurveybio = logminssbsurveyCV+0.2;  // Matters for IC
 AssessmentErrorRat = 0.6; // Changed from 0.3
 COUNTER = 0;
  SurveylikelihoodWeights = 1;  //Default value.  Input later.  
  LastMisReportingYear = firstyear-1 ;  // Default value
  FishingYearCatch = -1; 
  Nhat = 0;
  RefSSB = 1000; 
  Maxrelssb = 2; 
  Minrelssb = 0.2; 
  ObsCatchInNumbers = 0;
  AssessmentErr = 0;  // Set in mceval_phase
  ImplementationErr = 0;  // Set in mceeval_phase
  
  int i;
  for(i = 1; i < nsurveys; i++) logSigmaSurvey(i) = logminsurCV+0.2;  
  SurveyPower = 1; 
  for(i = 1; i <= nsurveys; i++) SurveyPowerest(i) = 1; 
  for(i = 1; i <= nsurveys; i++) surveybiopow(i) = 1; 
  if(INITCOND == 0) { // No pin file
    SigmaSurveypar = log(0.25);
    logMisreportingRatio = 0;
    SurveylnQ = -2;
    Catchlogitslope = 1;
    surveylogitslope = 2;
    surveylogitage50 = 1;
    Catchlogitage50 = 5;
    SigmaSurveypar = log(0.25);
    lnMeanRecr =  15;
    lnMeanInitialpop = 15;
    lnMeanEffort = -0;
    meanlogSurvivors = 13;
   }
   for( i = 1; i <= 4; i++) 
       if(SSBRecSwitches(i) < 0 || INITCOND==0)  estSSBRecParameters(i) = log(SSBRecParameters(i));
    for( i = 5; i <= 6; i++) 
       if(SSBRecSwitches(i) < 0 || INITCOND==0)  estSSBRecParameters(i) = SSBRecParameters(i);
   if(!mceval_phase()) MaxFishMort = 1.2;
   if(mceval_phase()) MaxFishMort = 5; // Maximum modelled fishing mortality ?
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
   logMmultiplier = log(Mmultiplier);  // 1;
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
  for(i = firstyear; i <= lastdatayear ; i++) {
      CatchIn1000tons(i) = sum(elem_prod(CatchWeights(i),ObsCatchInNumbers(i)))/1.0e6;
      if(CatchIn1000tons(i) < 0) CatchIn1000tons(i) = TotCatchIn1000tons(i);
  }
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
  fishyearcatch_mcmc_lines = 0;
  assessmenterror_mcmc_lines = 0;
  implementationerror_mcmc_lines = 0;
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
}

void model_parameters::userfunction(void)
{
  LnLikely =0.0;
  ScaleCatches();  
  if(BackWards == 0){
    HistoricalSimulation();
  }
  if(BackWards == 1) {
     cout << "HBprint";
     BackwardHistoricalSimulation();
  }
  COUNTER = COUNTER + 1;
  // SetPredValues();  // Set various sdreport objects from bw.tpl NPEL2007
  Prognosis();
  evaluate_the_objective_function();
  if(mceval_phase()){
     write_mcmc();
     write_mcmc_all();
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
   report << "LnLikelicomp" <<  LnLikelicomp << endl;
   report << "Surveylikelihood " << Surveylikelihood << endl;
   report << endl << "SigmaSurvey " << endl << SigmaSurvey << endl;
   int i,j;
   ofstream outfile(outputprefix+"resultsbyyearandage"+outputpostfix);
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
   outfile.open(outputprefix+"resultsbyyear"+outputpostfix); 
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
   outfile.open(outputprefix+"resultsbyage"+outputpostfix);
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
     ofstream Nfile("Noldest.dat");
     dvar_matrix Noldest(firstyear,lastdatayear+1,lastage-1,lastage);
     for(i = firstyear; i <=lastdatayear+1 ; i++) Noldest(i) = N(i)(lastage-1,lastage);
     Nfile << Noldest ;
     Nfile.close();
     ofstream Ffile("Foldest.dat");
      dvar_matrix Foldest(firstyear,lastdatayear+1);
      for(i = firstyear; i <=lastdatayear+1 ; i++) Foldest(i) = F(i)(lastage-1,lastage);
      Ffile << Foldest ;
      Ffile.close();
   }
}

void model_parameters::BackwardHistoricalSimulation()
{
  int i,year,age;
  int trend = 0;  // Trend or shift in certain year.  
  if(trend == 1) {
    TimeDrift(firstyear) = 0; 
    for(year = firstyear+1; year <= lastoptyear-5 ;year++)     
      TimeDrift(year) = TimeDrift(year-1) +  estSSBRecParameters(6); 
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
  int HistoricalAssessment = 1;
  dvariable FixNold = 0.1;  // Min left was 100 .  
  N = 0;
  for(age = firstestage; age < lastage; age++) 
    N(lastoptyear+1,age) = mfexp(meanlogSurvivors+logSurvivors(age));
  CalcNaturalMortality1(lastoptyear);
  N(lastoptyear+1,lastage) = Noldestinp(lastoptyear+1,lastage);
  for(year = lastoptyear; year >=  firstyear; year-- ) {
    CalcNaturalMortality1(year);
    N(year,lastage) = Noldestinp(year,lastage);
    for(age = firstcatchage; age <= lastage - 1; age++) 
      N(year,age) =  (N(year+1,age+1)*exp(natM(year,age)/2)+ObsCatchInNumbers(year,age))*exp(natM(year,age)/2);
    for(age = firstage; age < firstcatchage; age++) 
      N(year,age) = N(year+1,age+1)*exp(natM(year,age));
  }
  for(year = firstyear; year <= lastoptyear; year++) {
     for(age = firstage; age < lastage; age++) {
       Z(year,age) = -log(N(year+1,age+1)/N(year,age));  
       F(year,age) = Z(year,age) - natM(year,age);
     }
     F(year,lastage) = Foldestinp(year,lastage);
     Z(year,lastage) = F(year,lastage) + natM(year,lastage);
     CalcCatchInNumbers(year)=elem_prod(elem_div(F(year),Z(year)),elem_prod((1.-mfexp(-Z(year))),N(year)));
     CalcCatchIn1000tons(year) = sum(elem_prod(CalcCatchInNumbers(year),CatchWeights(year)))/1.0e6;
     PredictSSB(year);
     PredictedRecruitment(year) = PredictRecruitment(year);
     if(year >= firstyear+firstage)
       Recruitment(year-firstage) = N(year,firstage); 
  }
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
}

void model_parameters::HistoricalSimulation()
{
  int year,i;
  int trend = 0;  // Trend or shift in 1985.  
  if(trend == 1) {
    TimeDrift(firstyear) = 0; 
    for(year = firstyear+1; year <= lastoptyear-5 ;year++)     
      TimeDrift(year) = TimeDrift(year-1) +  estSSBRecParameters(6); 
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
   CalcRefValues(firstyear,lastoptyear,HistoricalAssessment);  
   if(recrdatadelay > 0) {     
      for(year = lastoptyear-recrdatadelay+1; year <= lastoptyear; year++){
          PredictedRecruitment(year) = PredictRecruitment(year);
          Recruitment(year) = PredictedRecruitment(year);
      }
    }
}

dvariable model_parameters::CalcHCRrefbio(int yr,int refage,int proxy,int nhat,int nweighterryears)
{
   int tmpnweighterryears = 0;  // to treat the ends where we do not reach nweighterryears in the average
   dvariable tmpweighterr = 0;
   if( nweighterryears == 0) tmpweighterr = 1;  // Perfect knowledge.
   if(nweighterryears > 0){
     for(int year=max(lastoptyear+1,yr-nweighterryears-1);year < min(yr,lastyear); year++) {
       tmpweighterr += weighterr(year);
       tmpnweighterryears++;
     }
     tmpweighterr /= (tmpnweighterryears+1e-6);
     tmpweighterr = mfexp(tmpweighterr-weighterr(yr));
   }
   dvariable refbio = 0;
   if(nhat == 0) {
     if(AgeModel==0 && proxy == 0)  // Length model haddock
        refbio =  sum(elem_prod(N(yr),elem_prod(StockWeights(yr),wtsel(StockWeights(yr)*tmpweighterr,HCRreflebreak))))/1e6;
     if(AgeModel == 1 ) {
        if(refage > 0)
          refbio = sum(elem_prod(N(yr)(refage,lastage),StockWeights(yr)(refage,lastage)*tmpweighterr))/1e6;
       if(refage < 0) 
          refbio= sum(elem_prod(N(yr)(-refage,lastage),CatchWeights(yr)(-refage,lastage)*tmpweighterr))/1e6;
     }
     //SSB both for length and age based might use lengthbased Bproxy for length model
     if((AgeModel == 0 && proxy == 1) ||(AgeModel==1 && HCRBproxyAge == 0 && proxy ==1))
       for(int age = minssbage; age <= lastage; age++)
          refbio  += N(yr,age)*(SSBWeights(yr,age)*tmpweighterr)*StockMaturity(yr,age)*
          mfexp(-(natM(yr-1,age)*PropofMbeforeSpawning(age)+F(yr-1,age)*PropofFbeforeSpawning(age)))/1e6;
   }
   if(nhat == 1) {  // Here we might need StockWeightshad or something like that.  
     if(AgeModel==0 && proxy == 0)  // Length model haddock
        refbio =  sum(elem_prod(Nhat(yr),elem_prod(StockWeights(yr)*tmpweighterr,wtsel(StockWeights(yr),HCRreflebreak))))/1e6;
     if(AgeModel == 1) {
        if(refage > 0)
          refbio = sum(elem_prod(Nhat(yr)(refage,lastage),StockWeights(yr)(refage,lastage)*tmpweighterr))/1e6;
       if(refage < 0) 
          refbio= sum(elem_prod(Nhat(yr)(-refage,lastage),CatchWeights(yr)(-refage,lastage)*tmpweighterr))/1e6;
     }
     //SSB both for length and age based might use lengthbased Bproxy for length model
     if((AgeModel == 0 && proxy == 1) ||(AgeModel==0 && HCRBproxyAge == 0 && proxy ==1))
       for(int age = minssbage; age <= lastage; age++)
          refbio  += Nhat(yr,age)*(SSBWeights(yr,age)*tmpweighterr)*StockMaturity(yr,age)*
          mfexp(-(natM(yr-1,age)*PropofMbeforeSpawning(age)+F(yr-1,age)*PropofFbeforeSpawning(age)))/1e6;
   }
   return(refbio);
}

void model_parameters::BioRatioHockeystick(int yr)
{
   int age;
   HCRBproxy(yr) = CalcHCRrefbio(yr,HCRBproxyAge,1,0,nweighterryears);
   HCRrefbio(yr) = CalcHCRrefbio(yr,HCRrefAge,0,0,nweighterryears);
   dvariable ratio = mfexp(log(HCRBproxy(yr))+AssessmentErr(yr))/Btrigger;
   ratio = SmoothDamper(ratio,1.0,0.0);  // ratio max 1  do not need the smooth version.  
   dvariable Hratio = ratio*HarvestRatio; 
   dvariable LastYTacRat = LastYearsTacRatio*ratio; // Gradual  like saithe
   dvariable AnnualCatch;  
   dvariable mincatch = 0.0;
   dvariable refcatch = Hratio*mfexp(log(HCRrefbio(yr))+AssessmentErr(yr));
   dvariable tmpCatch = (LastYTacRat*CurrentTac +  (1-LastYTacRat)*refcatch);
   dvariable Catch = tmpCatch*mfexp(ImplementationErr(yr));
   // small variations so implementation err is not included in the Tac stabiliser.
   // Have to add this to the advice year part.  
   if(yr == (lastoptyear+1) && NextYearsTacInput > 0) Catch = NextYearsTacInput; // Added January 15th. 
   Catch = SmoothDamper(Catch,MaxHarvestRatio*HCRrefbio(yr),mincatch);
   tmpCatch = SmoothDamper(tmpCatch,MaxHarvestRatio*HCRrefbio(yr),mincatch);
   if(IceFishYear) {
      AnnualCatch =  TacLeft + Catch/3; 
      AnnualCatch = SmoothDamper(AnnualCatch,MaxHarvestRatio*HCRrefbio(yr),mincatch); 
      TacLeft = Catch*2/3;
      FishingYearCatch(yr) = Catch;  // FishingYearCatch(2018) is 2018/2018
   }
   if(!IceFishYear)
       AnnualCatch = CurrentCatch ;
   CurrentTac = tmpCatch;
   CurrentCatch = Catch; 
   AnnualCatch = SmoothDamper(AnnualCatch,MaxHarvestRatio*HCRrefbio(yr),mincatch);
   if(mceval_phase()) ProgF(yr) = FishmortFromCatchMCMC(AnnualCatch*1e6,N(yr),CatchWeights(yr),progsel,natM(yr));
   if(!mceval_phase()) ProgF(yr) = FishmortFromCatchOpt(AnnualCatch*1e6,N(yr),CatchWeights(yr),progsel,natM(yr));
}

void model_parameters::SetWeightErrorsHad()
{
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
}

void model_parameters::SetAssessmentErr()
{
  random_number_generator r(COUNTER+20000);  // To avoid correlation with recrerr
  dvariable ratio = sqrt(1-Assessmentcorr*Assessmentcorr);
  int i;
  for(i = lastoptyear+1; i <= lastyear; i++)
      AssessmentErr(i) = randn(r);
  AssessmentErr(lastoptyear+1) = log(EstimatedAssYrSSB/AssYearSSB())/ratio/Assessmentcv;//2019*0.45; //AssessmentErrorRat ; Highest value that the model works on. 
  for(i = lastoptyear+2; i <= lastyear; i++)
    AssessmentErr(i) = Assessmentcorr*AssessmentErr(i-1)+AssessmentErr(i);
  AssessmentErr=AssessmentErr*ratio;
  for(i = lastoptyear+1; i <= lastyear; i++){
    if(AssessmentErr(i) > 2) AssessmentErr(i) = 2;  //Max asserr 
    if(AssessmentErr(i) < -2) AssessmentErr(i) = -2;  //-2 or 21
  }
  AssessmentErr=AssessmentErr*Assessmentcv;
  AssessmentErr=AssessmentErr+Assessmentbias;  // Think about the start values if bias.
  ratio = sqrt(1-Implementationcorr*Implementationcorr);
  for(i = lastoptyear+1; i <= lastyear; i++)
      ImplementationErr(i) = randn(r);
  ImplementationErr(lastoptyear+1) /= ratio;  // Random starting value.  
  for(i = lastoptyear+2; i <= lastyear; i++)
    ImplementationErr(i) = Implementationcorr*ImplementationErr(i-1)+ImplementationErr(i);
  ImplementationErr=ImplementationErr*ratio;
  for(i = lastoptyear+1; i <= lastyear; i++){
    if(ImplementationErr(i) > 2) ImplementationErr(i) = 2;  //Max implerr 
    if(ImplementationErr(i) < -2) ImplementationErr(i) = -2;  //-2 or 2
  }
  ImplementationErr=ImplementationErr*Implementationcv;
  ImplementationErr=ImplementationErr+Implementationbias;  // Think about the start values if bias.  
}

void model_parameters::Prognosis()
{
  dvariable ratio;
  dvariable wfrat = 0; // convert weighted and unweighted F.  
  int lastprogyear; // To reduce computer time in early part of simulation
  if ( current_phase() < 4) 
    lastprogyear = lastoptyear + 2; 
  else 
    lastprogyear = lastyear;
  CurrentTac= CurrentTacInput; // For catch rule start value.
  CurrentCatch = CurrentTacInput;  // Added not to get steabiliser in implementation error.  
  TacLeft = TacLeftInput;  // For catch rule start value.  
  int i;
   if(mceval_phase()){
     // scaling for terminal year added jan 2019
     dvariable CurrentStockError;
     random_number_generator r(COUNTER+20000111);  // To avoid correlation with other errors
      CurrentStockError = randn(r)*CurrentAssessmentErrmultiplier*Assessmentcv; 
     // scale the stock error is stock/presumed stock     
     N(lastoptyear+1)= N(lastoptyear+1)*CurrentStockScaler; // Scale down the stock in the assessment year.
     N(lastoptyear+1)=mfexp(log(N(lastoptyear+1))-CurrentStockError); //
     // Finished scaling the stock.  
     if(DensDep==0) UpdateWeightsAndMaturity(); // Have to do this every year with density dependence
     SetAssessmentErr();
     if(DensDep == 1) SetWeightErrorsHad();
   }
  random_number_generator r(COUNTER) ;  //stoch
  dvar_vector recrerr(lastoptyear+1,lastyear);
  recrerr = 0;
 if(mceval_phase()) {
    dvariable Recrcorr1 = Recrcorr;
    if(SSBRecSwitches[4] > 0) Recrcorr1 = mfexp(estSSBRecParameters[4]);
    dvariable recrratio = sqrt(1-Recrcorr1*Recrcorr1);
    for(i = lastoptyear+1; i <= lastyear; i++)
     recrerr(i) = randn(r);
    for(i = lastoptyear+2; i <= lastyear; i++)
      recrerr(i) = Recrcorr1*recrerr(i-1)+recrerr(i);
    recrerr=recrerr*recrratio;
    dvariable MinMaxRec = 2.0;  // Later from files
    for(i = lastoptyear+2; i <= lastyear; i++) {
      if(recrerr(i) > MinMaxRec) recrerr(i) = MinMaxRec; 
      if(recrerr(i) < -MinMaxRec) recrerr(i) = -MinMaxRec;
    }
  }     
  dvariable Catch;
  for(i = lastoptyear+1; i <= lastprogyear; i++) {
    if(mceval_phase() && DensDep == 1) UpdateWeightandMaturityHad(i); // not done in optimization
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
	  if(mceval_phase()) ProgF(i) = FishmortFromCatchMCMC(Catch,N(i),CatchWeights(i),progsel,natM(i));
	   if(!mceval_phase()) ProgF(i) = FishmortFromCatchOpt(Catch,N(i),CatchWeights(i),progsel,natM(i));
        }
    }
    if(CatchRule == 2 & i > lastdatayear){
      if(i == (lastdatayear+1)) {// Tac in assessment year. 
         if(current_phase() <= 3) // have to start with F for convergence
           ProgF(i) = 0.3;
	 if(current_phase() > 3) {
	      if(!mceval_phase()) ProgF(i) = FishmortFromCatchOpt(FutureForCatch(i)*1e6,N(i),CatchWeights(i),progsel,natM(i));
	      if(mceval_phase()) ProgF(i) = FishmortFromCatchMCMC(FutureForCatch(i)*1e6,N(i),CatchWeights(i),progsel,natM(i));
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
    if(CatchRule == 6){
        ProgF(i) = mfexp(log(FutureForCatch(i))+AssessmentErr(i));
    }
    if(CatchRule == 3 & i > lastdatayear)
      BioRatioHockeystick(i);
    if(CatchRule == 4 & i > lastdatayear)
      BioRatioHockeystickAdviceYear(i);
    if(CatchRule == 5 & i > lastdatayear) {
      if(i < lastyear) SingleTriggerHCR(i) ;
      if(i == lastyear) ProgF(i) = FishmortFromCatchMCMC(CalcCatchIn1000tons(i)*1e6,N(i),CatchWeights(i),progsel,natM(i));
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
}

void model_parameters::evaluate_the_objective_function()
{
   LnLikelicomp = 0;
   dvar_vector tmpsurveylikelihood(1,2); // for biomass survey likelihood that returns two comp i.e biomass and prop.  
   int i,j;
   if(!BackWards) {
     LnLikelicomp(1) = Catch_loglikeliNocorr(); // No meaning for 
   if(!BackWards)
     LnLikelicomp(2) = sum(square(log(CatchIn1000tons(firstyear,lastoptyear))
	-log(CalcCatchIn1000tons(firstyear,lastoptyear))))/
	 (2.*square(sigmatotalcatch))+ noptyears*log(sigmatotalcatch);
  }
  LnLikelicomp(3) = SSB_Recruitment_loglikeli(); 
  for(i = 1; i <= nsurveys; i++) {
      if(surveytype(i) == 1 ) {
        Surveylikelihood(i) = Survey_loglikeli1(i); // Store by survey
        LnLikelicomp(4) +=  Surveylikelihood(i)*SurveylikelihoodWeights(i);
      }
      if(surveytype(i) == 2 ) {
        tmpsurveylikelihood = Survey_loglikeli2(i); 
        Surveylikelihood(i)  = sum(tmpsurveylikelihood);
	LnLikelicomp(5) +=  tmpsurveylikelihood(1)*SurveylikelihoodWeights(i);  // Biomass
	LnLikelicomp(6) +=  tmpsurveylikelihood(2)*SurveylikelihoodWeights(i);  // Proportions 
      }
      if(surveytype(i) == 4) {
         Surveylikelihood(i) = SSB_Survey_loglikeli(i);	
	 LnLikelicomp(4) +=  Surveylikelihood(i)*SurveylikelihoodWeights(i); // Breyta?
      }
  }
  LnLikelicomp(8) = 0; 
  dvariable SigmaEffort = 0.5; 
  if(current_phase() < 5) LNMEANEFFORT = lnMeanEffort;
  else LnLikelicomp(9) = 0.5*square((lnMeanEffort- LNMEANEFFORT)/SigmaEffort);// Help toward the correct solution ?? 5 is really enough.   
  LnLikely = 0;
  for(i = 1; i <= 10; i++) 
     LnLikely += LnLikelicomp(i)*Likeliweights(i);
}

void model_parameters::CalcNextYearsN(int year)
{
   int age;
   if(year < lastyear) {
     for (age = firstage;age < lastage; age++)
       N(year+1,age+1) += N(year,age)*mfexp(-Z(year,age));
      if(plusgroup == 1)  N(year+1,lastage) += N(year,lastage)*mfexp(-Z(year,lastage));
   }
}

dvariable model_parameters::Catch_loglikeliNocorr()
{
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
         if(ObsCatchInNumbers(i,j) >= 0) {
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
}

void model_parameters::PredictSurveyAbundance1(int surveynr)
{
  int finalyear =  min(lastoptyear+surveytimefromlastyear(surveynr),surveylastyear(surveynr));
  dvariable value = 0;
   SurveyPower(surveynr)(surveyfirstage(surveynr),surveylastage(surveynr)) = 1;  // Changed for youngest fish.  
  int i;
  int j;
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
   if(active(surveybiopow(surveynr)) && surveybiopowphase(surveynr) > 0) {
    dvariable scaler;
    for(i = surveyfirstyear(surveynr); i <= finalyear ; i++) {
      scaler = pow(CalcSurveyBiomass(surveynr,i),surveybiopow(surveynr))/CalcSurveyBiomass(surveynr,i);
      CalcSurveyBiomass(surveynr,i) *= scaler;
      for(j =  surveyfirstage(surveynr); j <= surveylastage(surveynr); j++) 
         CalcSurveyNr(surveynr,i,j) *= scaler;
    }
  }
}

dvariable model_parameters::Survey_loglikeli1(int surveynr)
{
  PredictSurveyAbundance1(surveynr); 
  dvar_matrix Scorrmat(1,surveylastage(surveynr)-surveyfirstage(surveynr)+1,1,surveylastage(surveynr)-surveyfirstage(surveynr)+1);
  dvar_vector SurveyDiff(1,surveylastage(surveynr)-surveyfirstage(surveynr)+1);
  dvariable SurveylnDet;  
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
}

dvar_vector model_parameters::Survey_loglikeli2(int surveynr)
{
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
}

dvariable model_parameters::SSB_Survey_loglikeli(int surveynr)
{
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
}

dvariable model_parameters::SSB_Recruitment_loglikeli()
{
  // logSSBmax is in reality 5 times  the  spawing stock giving 1/2 maximum recruitment if Beverton 
  // and holt.  Therefore logSSBmax/5 in the relationship. SSB and SigmaSSBRec have already been predicted 
  // when this function is called.  
  dvariable value = 0;
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
}

dvariable model_parameters::SSB_Recruitment_loglikeliNocorr()
{
  // logSSBmax is in reality 5 times  the  spawing stock giving 1/2 maximum recruitment if Beverton 
  // and holt.  Therefore logSSBmax/5 in the relationship. SSB and SigmaSSBRec have already been predicted 
  // when this function is called.  
  dvariable value = 0;
  dvariable minrecruitment = 1.0;
  dvariable maxrecruitment = 1.0e9;
  int i = 0;
  int j = 0;
  for(i = firstyear; i <= lastoptyear-recrdatadelay; i++){
      PredictedRecruitment(i) = SmoothDamper(PredictRecruitment(i),maxrecruitment,minrecruitment);
      RecruitmentResiduals(i) = log(Recruitment(i)/PredictedRecruitment(i));
  }
  for(i = firstyear; i <= lastoptyear-recrdatadelay; i++) 
      value += log(SigmaSSBRec(i))+0.5*(square(RecruitmentResiduals(i)/SigmaSSBRec(i)));
   return(value);
}

dvariable model_parameters::PredictRecruitment(int year)
{
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
   if(SSBRectype == 5) {
     value = Rmax*mfexp(-TimeDrift(year))*Spawningstock(year)/SSBmax;
     value = SmoothDamper(value,Rmax*mfexp(-TimeDrift(year)),0);
   }   
   if(SSBRectype == 6) {
       value  = Rmax*mfexp(-TimeDrift(year));
   }
   return value;   
}

dvariable model_parameters::FishmortFromCatchMCMC(const dvariable C,const dvar_vector& Number,const dvar_vector& Wt,const dvar_vector& sel,const dvar_vector& M)
{
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
   dvariable deltaF;
   Fishmort = MaxFishMort;
   tmpF = Fishmort*sel;
   tmpZ = tmpF + M;
   Catch = sum(elem_prod(elem_prod(elem_div(tmpF,tmpZ),(1.-mfexp(-tmpZ))),Biomass));
   if(Catch < C) return(Fishmort);
   if(Catch > C) Fishmort = 0.005; 
   tmpF = Fishmort*sel;
   tmpZ = tmpF + M;
   Catch = sum(elem_prod(elem_prod(elem_div(tmpF,tmpZ),(1.-mfexp(-tmpZ))),Biomass));
   deltaF = MaxFishMort/1.8;
   for(i = 1; i < 30; i++){
      if(Catch > C) Fishmort = Fishmort - deltaF;
      if(Catch < C) Fishmort = Fishmort + deltaF;
      if(Fishmort < 0.005) Fishmort = 0.005;
      deltaF = deltaF/2;
      tmpF = Fishmort*sel;
      tmpZ = tmpF + M;
      Catch = sum(elem_prod(elem_prod(elem_div(tmpF,tmpZ),(1.-mfexp(-tmpZ))),Biomass));
   }
   if(Catch > C) Fishmort = Fishmort - deltaF;
   if(Catch < C) Fishmort = Fishmort + deltaF;
   return(Fishmort);
}

dvariable model_parameters::FishmortFromCatchMCMC1(const dvariable C,const dvar_vector& Number,const dvar_vector& Wt,const dvar_vector& sel,const dvar_vector& M)
{
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
}

dvariable model_parameters::FishmortFromCatchOpt(const dvariable C,const dvar_vector& Number,const dvar_vector& Wt,const dvar_vector& sel,const dvar_vector& M)
{
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
}

void model_parameters::ReadCatchandStockData()
{
  cifstream totinfile(totalcatchfilename);  // this file is not needed
  if(totinfile.fail()) {
  }
  else {
    int yr;
    while( !totinfile.eof()){
      totinfile >> yr;
      if(yr >= firstyear && yr <= lastoptyear)
        totinfile >> TotCatchIn1000tons(yr);
    }
  }
  totinfile.close();
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
	ratio = ObsCatchInNumbers(year,lastage)/(ObsCatchInNumbers(year,lastage)+tmpvec(3)+1e-9);
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
  CatchWeights = CatchWeightsData;
  StockWeights = StockWeightsData;
  StockMaturity = StockMaturityData;
  SSBWeights = SSBWeightsData;
}

void model_parameters::ReadCatchParameters()
{
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
   if(misreportingphase > 0){  // If misreporting is estimated select when it quits
     infile >> LastMisReportingYear;
     outfile << " LastMisReportingYear  " <<  LastMisReportingYear << endl;
   }
   if(BackWards ){
      int yr;
      cifstream Nfile("Noldest.dat");
      for(yr = firstyear; yr <= lastoptyear+1; yr++)
        Nfile  >> Noldestinp(yr);
      outfile << "Noldestinp " << endl << Noldestinp;
      Nfile.close();
      cifstream Ffile("Foldest.dat");
      for(yr = firstyear; yr <= lastoptyear+1; yr++)
        Ffile  >> Foldestinp(yr);
      outfile << "Foldestinp " << endl << Foldestinp;
      Ffile.close();
   } 
}

void model_parameters::ReadLikelihoodParameters()
{
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
   outfile << "Likeliweights " << Likeliweights << endl;
   if(!infile.eof()) {// Default value is 1
    infile >>  SurveylikelihoodWeights;  // do not need the last line but better to use it.
    // the inefile.eof() condition does not work but the read does nothing so default values (1) continue.  
    outfile << "SurveylikelikelihoodWeights " << SurveylikelihoodWeights << endl ; }
}

void model_parameters::ReadStockParameters()
{
   ofstream outfile("stockparameters.log");
   cifstream infile(stockparametersfilename);
   dvar_vector tmpM(firstage,lastdataage);
   infile >> tmpM;
   Mdata = tmpM(firstage,lastage);
   outfile  << "Mdata " << Mdata << endl;
   infile >> Mmultiplier ;
   outfile  << "Mmultiplier  " << Mmultiplier << endl;
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
   if(MigrationNumbers > 0 ) {
     infile >>  MigrationYears;
     outfile  << "MigrationYears " << MigrationYears << endl ;
     infile >> MigrationAges;
     outfile  << "MigrationAges " << MigrationAges << endl ;
   }
   outfile.close();
   infile.close();
}

void model_parameters::ReadOutputParameters()
{
   ofstream outfile("outputparameters.log");
   cifstream infile(outputparametersfilename);
   infile >> outputprefix;
   outfile << "outputprefix " << outputprefix << endl;
   infile >> outputpostfix;
   outfile << "outputpostfix " << outputpostfix << endl;
   if(outputpostfix=="***") outputpostfix = "";
   if(outputprefix=="***") outputprefix = "";
   infile >> AgeCbioR ;
   outfile << "AgeCbioR " << AgeCbioR << endl;
   if(AgeCbioR == 1) {
     dvar_vector tmpmeansel(firstage,lastdataage);
     infile >> tmpmeansel;
     MeanSel = tmpmeansel(firstage,lastage);
     outfile  << "MeanSel" << endl << MeanSel << endl;
   }
   if(AgeCbioR == 0) {
     infile >> CbioRreflebreak ;
     outfile <<  "CbioRreflebreak" << CbioRreflebreak << endl;
   }
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
}

void model_parameters::SetPredValues()
{
  int i;
  PredRefF = RefF(lastoptyear-5,lastyear);
  PredSpawningstock = Spawningstock(lastoptyear-5,lastyear);
  for(i = lastoptyear-5; i <= lastyear; i++) PredN(i) = N(i,firstage);
  Survivors = N(lastoptyear+1);
}

void model_parameters::ReadSurveyInfo(adstring parameterfilename,adstring datafilename, adstring residualfilename,int surveynumber,ofstream& surveylogfile)
{
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
}

void model_parameters::ReadPrognosis()
{
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
    if(infile.fail()){
        cout << "File " << PrognosisFilename << 
	"does not exist or something is wrong with it" << endl;
         exit(1);
    }
    infile >> CatchRule; // Number of catch rule.
    outfile << "Catchrule " << CatchRule << endl ;
    infile >> weightcv; // cv of weights
    outfile << "weightcv " << weightcv << endl;
    infile >> weightcorr; // autocorrelations of weights
    outfile << "weightcorr " << weightcorr << endl;
    infile >> nweighterryears;  // number of years to compile average wts 0 means perfect knowledge.  
    outfile << "nweighterryears " << nweighterryears << endl;;  // number of years to compile average wts
    infile >> Assessmentcv; // cv of Assessments
    outfile << "Assessmentcv " << Assessmentcv << endl;
    infile >> Assessmentcorr; // autocorrelations of Assessments
    outfile << "Assessmentcorr " << Assessmentcorr << endl;
    infile >> Assessmentbias; // Bias in assessment
    outfile << "Assessmentbias " << Assessmentbias << endl;
    infile >> Implementationcv; // cv of Implementations
    outfile << "Implementationcv " << Implementationcv << endl;
    infile >> Implementationcorr; // autocorrelations of Implementations
    outfile << "Implementationcorr " << Implementationcorr << endl;
    infile >> Implementationbias; // Bias in Implementation
    outfile << "Implementationbias " << Implementationbias << endl;
    infile >> CurrentAssessmentErrmultiplier;  // Multiplier on assessment error in current year.  Part is in the Hessian
    outfile << "CurrentAssessmentErrmultiplier " << CurrentAssessmentErrmultiplier << endl;  // Added Oct 2012 in the haddock model, 2019 in muppet
    infile >> CurrentStockScaler; // Multiplier on the stock in the assyear 
    outfile << "CurrentStockScaler " << CurrentStockScaler << endl ; // to see if the stock can recover
    infile >> Recrcorr; // autocorrelations of Recruitment cv estimated
    outfile << "Recrcorr " << Recrcorr << endl;
    infile >> Btrigger; // SSB trigger in the assessment yar
    outfile << "Btrigger " << Btrigger << endl;
    infile >> Maxchange; // Maxchange 
    outfile << "Maxchange " << Maxchange << endl;
    Maxchange += 1 ;
    infile >> EstimatedAssYrSSB;  // To get starting value for AssErr
    outfile << "EstimatedAssYrSSB " <<  EstimatedAssYrSSB << endl;
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
    if(CatchRule == 1  || CatchRule == 2 || CatchRule == 5 || CatchRule == 6 ) { // F or Catch read next ncatch years, fill the rest with last value
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
    if(CatchRule == 3 || CatchRule==4 ) {  // Biomass in assessment or advicory year
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
	outfile << "HCRreflebreak " << HCRreflebreak << endl;
      }	
      infile >> HarvestRatio ; 
      outfile << "HarvestRatio " << HarvestRatio << endl;
      infile >> MaxHarvestRatio;  // Maximum that we allow in any year depends on the ratio between ref and total bio 0.6-1
      outfile << "MaxHarvestRatio " << MaxHarvestRatio << endl;
      infile >> CurrentTacInput ; 
      outfile << "CurrentTacInput " << CurrentTacInput << endl;
      infile >> TacLeftInput ;  // Only for ICEFISHYEAR
      outfile << "TacLeftInput " << TacLeftInput << endl;
      infile >> NextYearsTacInput ;  // Only for ICEFISHYEAR
      outfile << "NextYearsTacInput " << NextYearsTacInput << endl;
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
      if(Progwtandmatinfile.eof()) break;
      year = int(tmpvec(1));
      age = int(tmpvec(2));
      if(year >= lastdatayear & year <= lastyear & age >= firstage & age <= lastage) {
          CatchWeights(year,age) = CatchWeightsData(year,age) = tmpvec(3);
          StockWeights(year,age) = StockWeightsData(year,age) = tmpvec(4);
          StockMaturity(year,age) = StockMaturityData(year,age) = tmpvec(5);
          SSBWeights(year,age) = SSBWeightsData(year,age) = tmpvec(6);
     }
     outfile << tmpvec << endl;  
   }
   if( year < lastyear) {
      i = year;
      for(year = i ; year <= lastyear ; year++) {
          CatchWeights(year) = CatchWeightsData(year) = CatchWeightsData(i);
          StockWeights(year) = StockWeightsData(year) = StockWeightsData(i);
          StockMaturity(year) = StockMaturityData(year) = StockMaturityData(i);
          SSBWeights(year) = SSBWeightsData(year) = SSBWeightsData(i); 
      }
   }
   Progwtandmatinfile.close();
   return;
 //************************************************************************************************************
 //************************************************************************************************************
}

void model_parameters::WriteInputDataInMatrixForm()
{
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
}

void model_parameters::UpdateWeightandMaturityHad(int year)
{
   int age;
   // Set up stock weights
   dvariable maxgrowthmult = 0.9; // from file later.  
   dvariable biom = 0;
   dvariable growthmult;
   dvariable growth;
   if(year > lastoptyear+1) {// survey in assessment year data on wt.  
      StockWeights(year,1) = 35; // does not matter
      StockWeights(year,2) = 198-0.115*(N(year,2) + N(year,3))/1000.*mfexp(recrweighterr(year));
      if(StockWeights(year,2) < 120) StockWeights(year,2) = 120;  //change 2019
    }
    CatchWeights(year) = 8.65813*pow((StockWeights(year)),0.7388)*mfexp(catchweighterr(year)) ;// 1985-2011
   SSBWeights(year) = StockWeights(year);  // Used in haddock
   if(year > lastoptyear + 1) StockMaturity(year) = 1.0/(1.0+mfexp(18.94 -2.72*log(StockWeights(year)))); // Added fef 2013
   if(year < lastyear) { // Add one more year
       if(current_phase() < 5) growthmult = 0.85;
       else{
        for(age= 2; age <= lastage; age ++)
          biom += N(year,age)*StockWeights(year,age);
	 biom = biom/1e6;
	  growthmult = (0.960452795-biom*0.000571546);
         growthmult = SmoothDamper(growthmult,maxgrowthmult,0.01);
       }
     for(age = 2; age < lastage; age++) {
       growth = 14.1*pow((StockWeights(year,age)),-0.30468);
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
}

void model_parameters::UpdateWeightsAndMaturity()
{
  random_number_generator r(COUNTER+10000);  // To avoid correlation
  dvar_vector weighterr(lastoptyear+1,lastyear);
  dvariable ratio = sqrt(1-weightcorr*weightcorr);
  int i;
  weighterr = 0; 
  if(mceval_phase()|| mceval_phase()) {
    for(i = lastoptyear+1; i <= lastyear; i++)
      weighterr(i) = randn(r);
    weighterr(lastoptyear+1) = weighterr(lastoptyear+1)/ratio;
    for(i = lastoptyear+2; i <= lastyear; i++)
      weighterr(i) = weightcorr*weighterr(i-1)+weighterr(i);
    weighterr=weighterr*weightcv*ratio;
  }
  weighterr(lastoptyear+1)*=0.35;  // less weight in first and second prediction
  weighterr(lastoptyear+2)*=0.7;
  for(i = lastoptyear+1; i <= lastyear; i++)
      CatchWeights(i)(firstcatchage,lastage) = mfexp(log(CatchWeightsData(i)(firstcatchage,lastage))+weighterr(i));
  for(i = lastoptyear+2; i <= lastyear; i++){ //SSB and Stock weights available in Assessyear
      StockWeights(i) = mfexp(log(StockWeightsData(i))+weighterr(i));
      SSBWeights(i)(minssbage,lastage) = mfexp(log(SSBWeightsData(i)(minssbage,lastage))+weighterr(i));
  }
}

void model_parameters::UpdateWeightsAndMaturityWhiteNoise()
{
  random_number_generator r(COUNTER+10000);  // To avoid correlation
  dvar_vector weighterr(firstage,lastage);
  int i;
  int j; 
  weighterr = 0; 
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
}

void model_parameters::CalcRefValues(int firstyr,int lastyr,int HistAssessment)
{
  int i;
  int j;
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
    if(AgeCbioR == 1) {  // Age based CbioR middle of year
      CbioR(i) = 0; 
      for(j = firstage; j <= lastage; j++) 
        CbioR(i)  = CbioR(i) + N(i,j)*CatchWeights(i,j)*MeanSel(j)*(1-mfexp(-Z(i,j)))/Z(i,j);
     }
     if(AgeCbioR == 0) { // Length based CbioR
      CbioR(i)  = sum(elem_prod(N(i),elem_prod(StockWeights(i),wtsel(StockWeights(i),CbioRreflebreak))));
   }
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
}

void model_parameters::PredictSSB(int year)
{
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
}

dvariable model_parameters::CalcMeanF(dvar_vector Fm)
{
  return mean(Fm(Frefage1,Frefage2));
}

dvariable model_parameters::CalcWeightedMeanF(dvar_vector Fm,dvar_vector N)
{
    return sum(elem_prod(Fm(Frefage1,Frefage2),N(Frefage1,Frefage2)))/
	sum(N(Frefage1,Frefage2));
}

void model_parameters::write_mcmc()
{
  // Writes MCMC chains to many wide-format files
  // Each quantity gets one column and all files have the same number of lines
  // Strict format: no space before first column, one space between columns, and no space after last column
  // 1 Spawning stock biomass
  adstring ss = "./run1/";
  adstring ss1 = "aa";
  if(mcwriteswitch(1) == 1) {
    if(ssb_mcmc_lines == 0)
    {      
      ssb_mcmc.open(outputprefix+"ssb.mcmc"+outputpostfix);
      ssb_mcmc<<"Spawningstock."<<Spawningstock.indexmin();
      for(int t=Spawningstock.indexmin()+1; t<=Spawningstock.indexmax(); t++)
      ssb_mcmc<<" Spawningstock."<<t;
      ssb_mcmc<<endl;
    }
    ssb_mcmc<<Spawningstock(Spawningstock.indexmin());
    ssb_mcmc<<Spawningstock.sub(Spawningstock.indexmin()+1,Spawningstock.indexmax())<<endl;
    ssb_mcmc_lines++;
  }
  if(mcwriteswitch(2) == 1){
    if(n1st_mcmc_lines == 0)
    {
      n1st_mcmc.open(outputprefix+"n1st.mcmc"+outputpostfix);
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
      f_mcmc.open(outputprefix+"f.mcmc"+outputpostfix);    
      f_mcmc<<"RefF."<<RefF.indexmin();
      for(int t=RefF.indexmin()+1; t<=RefF.indexmax(); t++)
        f_mcmc<<" RefF."<<t;
      f_mcmc<<endl;
    }
    f_mcmc<<RefF(RefF.indexmin());
    f_mcmc<<RefF.sub(RefF.indexmin()+1,RefF.indexmax())<<endl;
    f_mcmc_lines++;
  }
  if(mcwriteswitch(4) == 1){
    if(fishyearcatch_mcmc_lines == 0)
    {
      fishyearcatch_mcmc.open(outputprefix+"fishyearcatch.mcmc"+outputpostfix);
      fishyearcatch_mcmc<<"FishingYearCatch."<<FishingYearCatch.indexmin();
      for(int t=FishingYearCatch.indexmin()+1; t<=FishingYearCatch.indexmax(); t++)
        fishyearcatch_mcmc<<" FishingYearCatch."<<t;
      fishyearcatch_mcmc<<endl;
    }
    fishyearcatch_mcmc<<FishingYearCatch(FishingYearCatch.indexmin());
    fishyearcatch_mcmc<<FishingYearCatch.sub(FishingYearCatch.indexmin()+1,FishingYearCatch.indexmax())<<endl;
    fishyearcatch_mcmc_lines++;
  }
  if(mcwriteswitch(5) == 1){
    if(catch_mcmc_lines == 0)
    {
      catch_mcmc.open(outputprefix+"catch.mcmc"+outputpostfix);
      catch_mcmc<<"CalcCatchIn1000tons."<<CalcCatchIn1000tons.indexmin();
      for(int t=CalcCatchIn1000tons.indexmin()+1; t<=CalcCatchIn1000tons.indexmax(); t++)
        catch_mcmc<<" CalcCatchIn1000tons."<<t;
      catch_mcmc<<endl;
    }
    catch_mcmc<<CalcCatchIn1000tons(CalcCatchIn1000tons.indexmin());
    catch_mcmc<<CalcCatchIn1000tons.sub(CalcCatchIn1000tons.indexmin()+1,CalcCatchIn1000tons.indexmax())<<endl;
    catch_mcmc_lines++;
  }
  if(mcwriteswitch(6) == 1){
    if(parameter_mcmc_lines == 0)
    {
      adstring cn = "MeanRecr MeanInitialpop SigmaCmultiplier  MeanEffort ";
      if(catchlogitsizephase > 0)  cn = cn + "selslope fullselwt ";
      if(catchlogitphase > 0) cn = cn + "Catchlogitslope Catchlogitage50 ";
      if(misreportingphase > 0) cn = cn + "logMisreportingRatio ";
      if(Mmultphase > 0) cn = cn + "Mmultiplier ";
      parameter_mcmc.open(outputprefix+"parameter.mcmc"+outputpostfix);
      parameter_mcmc<< cn;
      for(int i=1; i<=size_count(estSSBRecParameters); i++)
        parameter_mcmc<<" estSSBRecParameters."<<i;
      parameter_mcmc<<endl;
    }
    parameter_mcmc<<mfexp(lnMeanRecr)<< " " <<mfexp(lnMeanInitialpop) <<  " " << mfexp(logSigmaCmultiplier)<< " " <<  mfexp(lnMeanEffort) << " ";
    if(catchlogitsizephase > 0) parameter_mcmc << selslope << " "<< fullselwt << " "; 
    if(catchlogitphase > 0) parameter_mcmc <<Catchlogitslope<<" "<<Catchlogitage50<<" ";
    if(misreportingphase > 0)parameter_mcmc << logMisreportingRatio << " ";
    if(Mmultphase > 0) parameter_mcmc << mfexp(logMmultiplier) << " ";
    parameter_mcmc <<estSSBRecParameters<<endl;
    parameter_mcmc_lines++;
  }
  // 7 Refbio1
  if(mcwriteswitch(7) == 1){
    if(refbio1_mcmc_lines == 0)
    {
      refbio1_mcmc.open(outputprefix+"refbio1.mcmc"+outputpostfix);
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
      refbio2_mcmc.open(outputprefix+"refbio2.mcmc"+outputpostfix);
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
    // Calculate HCRrefbio for historic values.  
    for(int yr=firstyear; yr <= lastyear; yr++)
       HCRrefbio(yr) = CalcHCRrefbio(yr,HCRrefAge,0,0,0);
    if(hcrrefbio_mcmc_lines == 0)
    {
      hcrrefbio_mcmc.open(outputprefix+"hcrrefbio.mcmc"+outputpostfix);
      hcrrefbio_mcmc<<"HCRrefbio."<<HCRrefbio.indexmin();
      for(int t=HCRrefbio.indexmin()+1; t<=HCRrefbio.indexmax(); t++)
        hcrrefbio_mcmc<<" HCRrefbio."<<t;
      hcrrefbio_mcmc<<endl;
    }
    hcrrefbio_mcmc<<HCRrefbio(HCRrefbio.indexmin());
    hcrrefbio_mcmc<<HCRrefbio.sub(HCRrefbio.indexmin()+1,HCRrefbio.indexmax())<<endl;
    hcrrefbio_mcmc_lines++;
  }
  if(mcwriteswitch(10) == 1){
    if(assessmenterror_mcmc_lines == 0)
    {
      assessmenterror_mcmc.open(outputprefix+"assessmenterror.mcmc"+outputpostfix);
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
      surveyq_mcmc.open(outputprefix+"surveyq.mcmc"+outputpostfix);
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
  if(mcwriteswitch(12) == 1){   
     if(surveypower_mcmc_lines == 0)
     {
        surveypower_mcmc.open(outputprefix+"surveypower.mcmc"+outputpostfix);
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
        migration_mcmc.open(outputprefix+"migration.mcmc");
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
  if(mcwriteswitch(14) == 1){   
    if(likelihood_mcmc_lines == 0)
    {
      likelihood_mcmc.open(outputprefix+"likelihood.mcmc"+outputpostfix);
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
  if(mcwriteswitch(17) == 1){
    if(estimatedselection_mcmc_lines == 0)
    {
      estimatedselection_mcmc.open(outputprefix+"estimatedselection.mcmc"+outputpostfix);
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
      effort_mcmc.open(outputprefix+"effort.mcmc"+outputpostfix);
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
      hcrbproxy_mcmc.open(outputprefix+"hcrbproxy.mcmc"+outputpostfix);
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
      n3_mcmc.open(outputprefix+"n3.mcmc"+outputpostfix);
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
      ssbwerr_mcmc.open(outputprefix+"ssbwerr.mcmc"+outputpostfix);
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
      relssb_mcmc.open(outputprefix+"relssb.mcmc"+outputpostfix);
      relssb_mcmc<<"RelSpawningstock."<<RelSpawningstock.indexmin();
      for(int t=RelSpawningstock.indexmin()+1; t<=RelSpawningstock.indexmax(); t++)
        relssb_mcmc<<" RelSpawningstock."<<t;
      relssb_mcmc<<endl;
    }
    relssb_mcmc<<RelSpawningstock(RelSpawningstock.indexmin());
    relssb_mcmc<<RelSpawningstock.sub(RelSpawningstock.indexmin()+1,RelSpawningstock.indexmax())<<endl;
    relssb_mcmc_lines++;
  }
  if(mcwriteswitch(23) == 1){
    if(implementationerror_mcmc_lines == 0)
    {
      implementationerror_mcmc.open(outputprefix+"implementationerror.mcmc"+outputpostfix);
      implementationerror_mcmc<<"ImplementationErr."<<ImplementationErr.indexmin();
      for(int t=ImplementationErr.indexmin()+1; t<=ImplementationErr.indexmax(); t++)
        implementationerror_mcmc<<" ImplementationErr."<<t;
      implementationerror_mcmc<<endl;
    }
    implementationerror_mcmc<<ImplementationErr(ImplementationErr.indexmin());
    implementationerror_mcmc<<ImplementationErr.sub(ImplementationErr.indexmin()+1,ImplementationErr.indexmax())<<endl;
    implementationerror_mcmc_lines++;
  }
}

void model_parameters::write_mcmc_all()
{
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
}

void model_parameters::PredictShorttermSSB(int year,int wmatYear)
{
   dvariable SSBRecCV = mfexp(estSSBRecParameters(3));
   dvariable SSBRecpow = estSSBRecParameters(5);
   Spawningstock(year) = 0;
   for(int age = minssbage; age <= lastage; age++)
     Spawningstock(year) += Nhat(year,age)*SSBWeights(wmatYear,age)*StockMaturity(wmatYear,age);
   Spawningstock(year) /= 1e6;
   Totbio(year) = sum(elem_prod(SSBWeights(wmatYear),Nhat(year)))/1e6;
   SigmaSSBRec(year) = SSBRecCV/pow(SmoothDamper(Spawningstock(year)/RefSSB,Maxrelssb,Minrelssb),SSBRecpow); 
}

void model_parameters::SingleTriggerHCR(int year)
{
  dvariable wfrat = 0;
  int age = 0;
  if(year == (lastoptyear+1)) CalcCatchIn1000tons(year) = FutureForCatch(year);
    // Simulate the assessment year.  
  for(int age = firstage+1; age <= lastage ; age++) Nhat(year,age)=mfexp(log(N(year,age))+AssessmentErr(year));
  CalcNaturalMortality1(year); 
  ProgF(year) = FishmortFromCatchMCMC(CalcCatchIn1000tons(year)*1e6,Nhat(year),CatchWeights(year),progsel,natM(year));
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
    CalcCatchInNumbers(year+1)=(elem_prod(elem_div(F(year+1),Z(year+1)),elem_prod((1.-mfexp(-Z(year+1))),Nhat(year+1))))*mfexp(ImplementationErr(year));
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
 ProgF(year) = FishmortFromCatchMCMC(CalcCatchIn1000tons(year)*1e6,N(year),CatchWeights(year),progsel,natM(year));
}

void model_parameters::BioRatioHockeystickAdviceYear(int year)
{
  dvariable mincatch = 0.0;
  dvariable Catch;
  dvariable tmpTac = CurrentTac;
  int age;
  dvariable Hratio;
  dvariable LastYTacRat;
  dvariable refcatch;
  dvariable ratio;
  dvariable AnnualCatch;  // This is the catch for current calendar year.  
  if(year == lastyear){   // Special do not use prediction beyond last year.
     // Use Current Tac for the last year as we do not project to the year after.  
     ProgF(year) = FishmortFromCatchMCMC(CurrentTac*1e6,N(year),CatchWeights(year),progsel,natM(year));
     return;
  }
  if(IceFishYear == 1) {  // Have to iterate as the advice affects the result use 3 iterations 
    tmpTac = TacLeft + CurrentTac*1/3;  // Current Tac is only until September 1st but still used as first proxy.
    for(age = firstage+1; age <= lastage ; age++) Nhat(year,age)=mfexp(log(N(year,age))+AssessmentErr(year));
    for(int i = 1; i <= 3; i++){
      CalcNaturalMortality1(year);
      ProgF(year) = FishmortFromCatchMCMC(tmpTac*1e6,Nhat(year),CatchWeights(year),progsel,natM(year));
      F(year) = ProgF(year)*progsel; 
      Z(year) = F(year) + natM(year);
      for(age = firstage ; age < lastage ; age++) 
        Nhat(year+1,age+1)  = Nhat(year,age)*mfexp(-Z(year,age));
      Nhat(year+1,lastage) += Nhat(year,lastage)*mfexp(-Z(year,lastage));
      HCRrefbio(year+1) = CalcHCRrefbio(year+1,HCRrefAge,0,1,nweighterryears);    
      PredictShorttermSSB(year+1,year);   
    // Use length model // Last years weights used
      ratio = Spawningstock(year+1)/Btrigger;
      ratio = SmoothDamper(ratio,1.0,0.0);  // ratio max 1  do not need the smooth version.  
      Hratio = ratio*HarvestRatio; 
      LastYTacRat = LastYearsTacRatio*ratio; // Gradual  like saithe
      refcatch = Hratio*HCRrefbio(year+1);
      Catch = (LastYTacRat*CurrentTac +  (1-LastYTacRat)*refcatch)*mfexp(ImplementationErr(year));
      // SmoothDamper is a differentiable if, this function will only be used in the mceval mode so this is perhaps not needed.  
      Catch = SmoothDamper(Catch,MaxHarvestRatio*HCRrefbio(year+1),mincatch) ;
      if(year == (lastoptyear+1) && NextYearsTacInput > 0) Catch = NextYearsTacInput; // Added January 15th. 
      tmpTac = TacLeft + Catch/3;
    }
    AnnualCatch =  TacLeft + Catch/3; 
    AnnualCatch = SmoothDamper(AnnualCatch,MaxHarvestRatio*HCRrefbio(year),mincatch); // to avoid too much depletion in stochastic runs.  
    TacLeft = Catch*2/3;
    FishingYearCatch(year) = CurrentTac = Catch;  // FishingYearCatch(2018) is 2018/2019
  }
  if(IceFishYear == 0) { // Calendar year;
    for(age = firstage+1; age <= lastage ; age++) Nhat(year,age)=mfexp(log(N(year,age))+AssessmentErr(year));
    CalcNaturalMortality1(year); 
    tmpTac = CurrentTac;  // Current Tac is for assessment year as calendar year.  
    ProgF(year) = FishmortFromCatchMCMC(tmpTac*1e6,Nhat(year),CatchWeights(year),progsel,natM(year));
    F(year) = ProgF(year)*progsel; 
    Z(year) = F(year) + natM(year);
    for(age = firstage ; age < lastage ; age++) 
      Nhat(year+1,age+1)  = Nhat(year,age)*mfexp(-Z(year,age));
    Nhat(year+1,lastage) += Nhat(year,lastage)*mfexp(-Z(year,lastage));
    HCRrefbio(year+1) = CalcHCRrefbio(year+1,HCRrefAge,0,1,nweighterryears);    
    PredictShorttermSSB(year+1,year);   
    // Use length model // Last years weights used
    ratio = Spawningstock(year+1)/Btrigger;
    ratio = SmoothDamper(ratio,1.0,0.0);  // ratio max 1  do not need the smooth version.  
    Hratio = ratio*HarvestRatio; 
    LastYTacRat = LastYearsTacRatio*ratio; // Gradual  like saithe
    refcatch = Hratio*HCRrefbio(year+1);
    Catch = (LastYTacRat*CurrentTac +  (1-LastYTacRat)*refcatch)*mfexp(ImplementationErr(year));
    Catch = SmoothDamper(Catch,MaxHarvestRatio*HCRrefbio(year+1),mincatch);
    if(year == (lastoptyear+1) && NextYearsTacInput > 0) Catch = NextYearsTacInput;  // Added 15th of Jan
    AnnualCatch =  CurrentTac;
    AnnualCatch = SmoothDamper(AnnualCatch,MaxHarvestRatio*HCRrefbio(year),mincatch); // to avoid too much depletion in stochastic runs.  
    TacLeft = Catch;
  }
  CurrentTac = Catch;  
  ProgF(year) = FishmortFromCatchMCMC(AnnualCatch*1e6,N(year),CatchWeights(year),progsel,natM(year));
}

void model_parameters::ScaleCatches()
{
   Misreporting  = 1;
   int yr;
   for(yr = firstyear; yr <= LastMisReportingYear; yr++)
     Misreporting(yr) = mfexp(logMisreportingRatio); 
   for(yr = firstyear; yr <= LastMisReportingYear; yr++){
     ObsCatchInNumbers(yr) =  ObsCatchInNumbersInput(yr)*Misreporting(yr);
     CatchIn1000tons(yr) = CatchIn1000tonsInput(yr)*Misreporting(yr);
   }
}

void model_parameters::CalcFishingMortality1a(int year)
{
   int age;
   for(age = firstcatchage; age <= lastage; age++) 
      F(year,age) = mfexp(lnMeanEffort+lnEffort(year))*1/(1+mfexp(-Catchlogitslope*(age-Catchlogitage50)));
}

void model_parameters::CalcFishingMortality1b(int year)
{
   int age;
   for(age = firstcatchage; age <=  lastage-nfixedselages; age++) 
       F(year,age) = mfexp(lnMeanEffort+lnEffort(year)+EstimatedSelection(age,parcolnr(year)));
   for(age = lastage-nfixedselages+1; age <=  lastage; age++) // Sel 1.  
       F(year,age) = mfexp(lnMeanEffort+lnEffort(year));
}

void model_parameters::CalcFishingMortality1c(int year)
{
   int age;
   dvariable sel;
   for(age = firstcatchage; age <=  lastage; age++) {
      sel = 1./(1+mfexp(-selslope*log(StockWeights(year,age)/fullselwt)));
      F(year,age) = mfexp(lnMeanEffort+lnEffort(year))*sel;
   }
}

void model_parameters::CalcFishingMortality3(int year)
{
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
}

void model_parameters::CalcNaturalMortality1(int year)
{
   int i;
   int j;
   dvariable age;
   for(j = firstage; j <= lastage; j++)
	natM(year,j) = Mdata(j)*mfexp(logMmultiplier);
   if(estMlastagephase > 0) natM(year,lastage) = mfexp(logMoldest); 
}

dvariable model_parameters::SmoothDamper(dvariable x, dvariable Roof,dvariable Floor)
{
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
}

dvar_vector model_parameters::wtsel(dvar_vector StockWts,dvariable lebreak)
{
  return(1.0/(1.0+mfexp(-25.224-5.307*log(StockWts/pow(lebreak,3.0)))));  
}

dvariable model_parameters::AssYearSSB()
{
   dvariable tmpssb= 0;
   for(int age = minssbage+1; age <= lastage; age++)
     tmpssb += N(lastoptyear+1,age)*SSBWeights(lastoptyear,age)*StockMaturity(lastoptyear,age)*
     mfexp(-(natM(lastoptyear,age)*PropofMbeforeSpawning(age)+F(lastoptyear,age)*PropofFbeforeSpawning(age)));
   tmpssb/= 1e6; 
   return tmpssb; 
}

model_data::~model_data()
{}

model_parameters::~model_parameters()
{}

void model_parameters::final_calcs(void){}

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
  gradient_structure::set_CMPDIF_BUFFER_SIZE(10000000);
  gradient_structure::set_GRADSTACK_BUFFER_SIZE(1000000);
  gradient_structure::set_MAX_NVAR_OFFSET(1500);
  gradient_structure::set_NUM_DEPENDENT_VARIABLES(1500);
  arrmblsize = 50000000;
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
