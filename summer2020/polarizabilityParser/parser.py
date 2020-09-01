#!/usr/local/bin/python3.8
"""
   Date:    08/17/2020 
   Author:  Martin E. Liza 
   File:    parser.py 
   Def:     Parses data from alpha.dat, dstbolz.dat and Tresult-temp.dat. 
            Calculates the polarizability in units of A^3 as a function 
            of temperature and Boltzman Distributions. Saves the output files as 
            .dat file that can be open in tecplot. 
         
      

   Author             Date           Revision  
   ----------------------------------------------------------------------------
   Martin E. Liza     08/06/2020     Initial Version  
   Martin E. Liza     08/07/2020     Calculates polarizability as a function of 
                                     the Boltzman's distributions and save an 
                                     output file. 
   Martin E. Liza     08/17/2020     Removed the space step (zone) condition and 
                                     allowed user inputs. 
""" 
import pandas as pd 
import numpy as np 
import subprocess 
import os 

# User input 
outputFileName = 'polar'
alphaPath = 'xdisk/hanquist/mig2020/extra/hanquist/AFRL/data'
stsPath = 'location/whereSTS/outputData/Lives' 

# Parsing alpha.dat file, polarizability volume, units A^3 = 10E-24 cm^3 
alphaDF = pd.read_fwf(os.path.join(alphaPath, 'alpha.dat'), header=None, index_col=False) 
vibrationalNumMat = np.asarray(alphaDF[0])  
polarizabilityJ5  = np.asarray(alphaDF[1]) 
polarizabilityJ15 = np.asarray(alphaDF[2]) 
polarizabilityJ21 = np.asarray(alphaDF[3]) 

# Parsing Tresult-temp.dat 
tempDF = pd.read_fwf(os.path.join(stsPath,'Tresult-temp.dat'), header=None, index_col=False)
timeMicroSec   = np.asarray(tempDF[0])
translTempK    = np.asarray(tempDF[1])
theoryVibTempK = np.asarray(tempDF[2])
explVibTempK   = np.asarray(tempDF[3])

# Parsing dstboltz.dat 
# Removes the word zone from dstboltz.dat and creates a temp.dat file 
subprocess.call([f"sed '/zone/d' {stsPath}/dstboltz.dat > temp.dat"], shell=True)  

# Import temp.dat as a data frame and convert it to an array  
dstboltzDF = pd.read_fwf('temp.dat', header=None, index_col=False)
subprocess.call(["rm -rf temp.dat"], shell=True) 
dstboltzArray = np.asarray(dstboltzDF)  

# Inputs needed to reshape the array 
numColElem = len(dstboltzDF.columns)
numRowElem = len(dstboltzDF) 
numZones   = int(subprocess.check_output([f"grep zone {stsPath}/dstboltz.dat | wc -l"], shell=True)) 

# Reshape the array and creates 
dstboltzMultiArr  = dstboltzArray.reshape(numZones, int(numRowElem/numZones), numColElem)

# Calculate the polarizability for the nonBoltzmanDist and the boltzmanDist 
nonBoltzPolA = np.zeros(numZones) 
boltzPolA = np.zeros(numZones) 
for indxZone in range(0, numZones):  
    nonBoltzPolA[indxZone] = np.sum(polarizabilityJ5 * np.exp(dstboltzMultiArr[indxZone][:,1])) 
    boltzPolA[indxZone] = np.sum(polarizabilityJ5 * np.exp(dstboltzMultiArr[indxZone][:,2]))

# Create data frame for output data and storage the data in a tecPlot friendly way
dataOut = [ timeMicroSec, translTempK, theoryVibTempK, boltzPolA, nonBoltzPolA ]  
printOut = pd.DataFrame(np.transpose(dataOut))  
np.savetxt(f'{outputFileName}.dat', printOut, header = "VARIABLES =  \"time_microSec\" \"translationalTemp_K\" \"thVibrationalTemp_K\" \"polarizabilityBoltz_A\" \"polarizabilityNonBoltz_A\"")
#subprocess.call([f"sed -i '' 's/\#//' {outputFileName}.dat"], shell=True) 
subprocess.call([f"sed -i 's/\#//' {outputFileName}.dat"], shell=True) 

#from IPython import embed; embed() 
