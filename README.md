# Sim.factors.transcriptome_model

Code for creating datasets/figures in paper “Simulation study of factors affecting accuracy of the transcriptome model under complex environments”

## Files

### data folder
#### EvaluationWeatherData(Robject : at)
Assuming that the transcriptome will be sampled at 12 time points from 01:00 to 23:00 every two hours every two weeks from 6/7/2008 to 9/27/2008 in Tsukuba City, Ibaraki Prefecture, the actual dates and times are summarized (108 points).
<br>
<br>
#### All_EvaluationWeatherData_1minInterval
Minute-by-minute temperature and solar radiation data for Tsukuba City, Ibaraki Prefecture, Japan, from 5/1/08 to 10/31/08
<br>
<br>
#### ReferenceFIT_Geneexpression
The output of the “EvaluationWeatherData” input to the ReferenceFIT model is a 500 (genes)*108 (time points) matrix of genes on the horizontal axis and gene expression levels on the vertical axis.
<br>
<br>
### RefFIT_MeasurementValue.csv
Matrix of measured gene expression levels used to create the Reference FIT
<br>
<br>
### RefFIT_PridictionValue.csv
Matrix of predicted gene expression levels output by inputting weather conditions at the same time as the actual measured gene expression levels used to create the ReferenceFIT.
<br>
<br>



### SimulationSamplingConditon folder
#### ALTC_xx_001 folder (xx : 1 , 3 , 08 , 08Day , 08Night , 24 , 73)
The xx indicates how many weather conditions are sampled. For example, ALTC_3_001 is the sampling condition for a simulation with 36 samples using 3 weather conditions.
<br>
<br>
#### TestFIT_Expression(Robject : prediction.results)
500 (genes)*108 (time points) matrix data with genes on the horizontal axis and gene expression levels on the vertical axis.
<br>
<br>
### Weather Conditon folder
#### WeatherConditon.csv
73 different weather conditions used to create the simulation sampling conditions
<br>
<br>
#### SampleSize xx _ALTC.csv(xx : 12 , 36 , 96 , 288 , 876)
List indicating which weather conditions were used for each simulation sampling condition
<br>
<br>
### MeasurementResult
Simulation sampling conditions created with actual measurements
#### SampleSize xx (xx : 12 , 36 , 98 , 288 , 876)　folder
Inside are the folders “ALTC_xx_001.prediction” or “ALTC_xx_001.train” respectively, which contain the files used by prediction for the analysis.
<br>
<br>
### Limited Train FIT Model Data
#### ex_p01_day(Robject : prediction.results)
Reference FIT model trained only with data from the light period (Radiation ≠ 0). The horizontal axis is the gene and the vertical axis is the 500 (gene)*108 (time point) matrix data of gene expression levels.
<br>
<br>


#### ex_p01_night(Robject : prediction.results)
Reference FIT model trained with only dark period (Radiation = 0) data. The horizontal axis is the gene and the vertical axis is the 500 (gene)*108 (time point) matrix data of gene expression levels.
<br>
<br>
#### ex_p03_tm20-30(Robject : prediction.results)
Reference FIT model trained with only 20~30°C data. The horizontal axis is genes and the vertical axis is 500 (genes)*108 (time points) matrix data of gene expression levels.

## Scripts
### runFIT.R
FIT models are created from gene expression levels and weather data.
<br>
<br>
### predict_by_FIT_for_02.R
Create a new FIT model (test FIT) based on the weather conditions entered into the reference FIT model and the output gene expression levels.
<br>
<br>
### predict_by_FIT.R
Input arbitrary weather conditions to the FIT model and output gene expression levels.
<br>
<br>
### PrepareDataset.ipynb
The gene expression levels of the TestFIT model and the reference FIT model are combined and the date, time, temperature, and solar radiation are assigned to each gene expression level.
UsedFile :data/EvaluationWeatherData , All_EvaluationWeatherData_1minInterval , ReferenceFIT_Geneexpression , SimulationSamplingConditon//**
<br>
OutputFile : df_all_fit_raw.csv / df_all_fit_filterd.csv
<br>
<br>

### Calculation_Corr_RMSE.ipynb
Calculate correlation coefficients and RMSE from gene expression levels of reference and test FIT models for each ALTC and gene
<br>
UsedFile : df_all_fit_filterd.csv
<br>
OutputFile : df_CorrRMSE.csv
<br>
<br>
### Calculation_PridictionSuccesDay.ipynb
For each ALTC and gene, the correlation coefficient and RMSE are calculated for each evaluation date (at 12 time points). The number of days with a correlation coefficient of 0.8 or higher and a correlation coefficient of less than 0.4 is then totaled.
<br>
UsedFile : df_all_fit_filterd.csv
<br>
OutputFile : df_CorrRMSE.csv
<br>
<br>
### Prepare_DayNightOnlydataset_0990Days.ipynb
From the csv (df_Pridiciton_Success_Day), in which the number of days of predicted success was calculated for each ALTC and gene, ALTCs and genes with 9 days of predicted success in the control condition and 0 days in the light/dark season only condition were extracted
<br>
UsedFile : df_Pridiciton_Success_Day.csv
<br>
OutputFile : DayNightOnlydataset_0990Days_PrdSucDay.csv
<br>
<br>
### Calc_GeneSD.ipynb
The residuals are calculated from the gene expression levels used to create the ReferenceFIT model and the predicted gene expression levels, and the SD is calculated from the residuals.
<br>
UsedFile : data\RefFIT_MeasurementValue.csv , data\RefFIT_PridictionValue.csv
OutputFile : SD.csv
<br>
<br>
### MeasurementResult/ConvertRobject_to_csv.ipynb
Read the prediciton file (Robject) in MeasurementResult/Samplesize xx and combine EvaluationWeatherData and All_EvaluationWeatherData_1minInterval.

UsedFile : Samplesizexx / *prediction , data/EvaluationWeatherData , All_EvaluationWeatherData_1minInterval
<br>
OutputFile : Measurement_alldata.csv
<br>
<br>
### MeasurementResult/Creat_CompareDataset.ipynb
Combine the results of the FIT model created from the simulation sampling conditions with the results of the FIT model created from the simulation sampling conditions with actual measurements
<br>
UsedFile : code/df_all_fit_filterd.csv , df_all_Measurement_raw.csv
<br>
OutputFile :df_all_Measurement_filter.csv , df_all_Measurement_raw.csv
<br>
<br>
### MeasurementResult/CorrRMSE_Calculaiton.ipynb
Correlation coefficients and RMSE are calculated from reference and measured FIT for each ALTC and gene.
<br>
UsedFile : MeasurementResult/df_all_Measurement_filter.csv
<br>
OutputFile : MeasurementResult/df_CorrRMSE_Measurement.csv
<br>
<br>
### Limited Train FIT Model Data/Load_LimitedTrainingData.ipynb
Read data from limited learning FIT model and combine at/wt data with gene expression levels from reference FIT model
<br>
UsedFile :Limited Train FIT Model Data/ex_p01_day , ex_p02_night , ex_p03_tm20-30  data/EvaluationWeatherData , All_EvaluationWeatherData_1minInterval  code / ReferenceFIT_Geneexpression , Tsukuba_Weather_DayNight.csv 
<br>
OutputFile : code/df_DayOnly.csv , df_NightOnly.csv , df_Temp20to30.csv
<br>
<br>
### Plotting_PaperFig.ipynb
Reproduction code for Figures drawn in the paper
