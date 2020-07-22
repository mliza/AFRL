#!/usr/local/bin/python3.8
import tecplot as tp
import sys
from tecplot.exception import *
from tecplot.constant import *

# Uncomment the following line to connect to a running instance of Tecplot 360:
#tp.session.connect()

# runint ./tecParser.py 'inFile' 'outFile' dx1 dx2 dy1 dy2
argIn   = sys.argv 
pltIn   = argIn[1] 
dataOut = argIn[2] 
dx1     = argIn[3]
dx2     = argIn[4] 
dy1     = argIn[5]
dy2     = argIn[6]

tp.macro.execute_command(f"""$!ReadDataSet '\"{pltIn}.plt\"'
  ReadDataOption = New
  ResetStyle = No
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '\"X\"\"Y\"\"rho_N2\"\"rho_O2\" \"rho_NO\" \"rho_N\" \"rho_O\" \"rho_NOp\" \"rho_N2p\" \"rho_O2p\" \"rho_Np\" \"rho_Op\" \"rho_e\" \"U\" \"V\" \"T\" \"Tv\" \"rho\" \"P\" \"H\" \"tau\"'""")
tp.macro.execute_command('''$!Pick AddAtPosition
  X = 1.05909090909
  Y = 1.23181818182
  ConsiderStyle = Yes''')
tp.macro.execute_command('''$!FrameControl ActivateByNumber
  Frame = 1''')
tp.macro.execute_extended_command(command_processor_id='Extract Precise Line',
    command=f"XSTART = {dx1} YSTART = {dy1} ZSTART = 0 XEND = {dx2} YEND = {dy2} ZEND = 0 NUMPTS = 1000 EXTRACTTHROUGHVOLUME = F EXTRACTTOFILE = T EXTRACTFILENAME = '{dataOut}.dat' ")
# End Macro.

