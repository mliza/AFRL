#!/usr/local/bin/bash 

# Declaring paths, and making parseData folders   
declare -r pathM10='runsOut/runningM10' pathM15='runsOut/runningM15'; 
mkdir -p $pathM10/parseData;
mkdir -p $pathM15/parseData;

echo "Parsing M=10" 
./moparParser.py $pathM10/plate11Alt30/output $pathM10/parseData/xPlate11Alt30 2.25 2.25 0.0 0.35;   
./moparParser.py $pathM10/plate11Alt50/output $pathM10/parseData/xPlate11Alt50 2.25 2.25 0.0 0.35;   
./moparParser.py $pathM10/plate5Alt30/output $pathM10/parseData/xPlate5Alt30 2.25 2.25 0.0 0.35;   
./moparParser.py $pathM10/plate5Alt50/output $pathM10/parseData/xPlate5Alt50 2.25 2.25 0.0 0.35;   

# Search and replace x[m] for X and y[m] for Y
find $pathM10/parseData -name "*.dat" -exec sed -i '' 's/x\[m\]/X/g; s/y\[m\]/Y/g' {} \; 
echo -e "End parsing M=10\n"

echo "Parsing M=15" 
./moparParser.py $pathM15/plate11Alt30/output $pathM15/parseData/xPlate11Alt30 2.25 2.25 0.0 0.35;   
./moparParser.py $pathM15/plate11Alt50/output $pathM15/parseData/xPlate11Alt50 2.25 2.25 0.0 0.35;   
./moparParser.py $pathM15/plate5Alt30/output $pathM15/parseData/xPlate5Alt30 2.25 2.25 0.0 0.35;   
./moparParser.py $pathM15/plate5Alt50/output $pathM15/parseData/xPlate5Alt50 2.25 2.25 0.0 0.35;   
# Search and replace x[m] for X and y[m] for Y
find $pathM15/parseData -name "*.dat" -exec sed -i '' 's/x\[m\]/X/g; s/y\[m\]/Y/g' {} \; 
echo "End parsing M=15"
