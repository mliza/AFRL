#!/usr/local/bin/bash 
mkdir -p gridData/plots; 
echo "Starting the parsing's portion"
./lemansParser.py 'runsOut/irv11Lemans/output' 'gridData/irv11Lemans' 0.08 0.08 0.045 0.03;
./lemansParser.py 'runsOut/irv5Lemans/output' 'gridData/irv5Lemans' 0.08 0.08 0.045 0.03
./lemansParser.py 'runsOut/plate11Lemans/output' 'gridData/plate11Lemans' 0.5 2.5 0.1 0.1;
./lemansParser.py 'runsOut/plate5Lemans/output' 'gridData/plate5Lemans' 0.5 2.5 0.1 0.1;

./moparParser.py 'runsOut/irv11Mopar/output' 'gridData/irv11Mopar' 0.08 0.08 0.045 0.03;
./moparParser.py 'runsOut/irv5Mopar/output' 'gridData/irv5Mopar' 0.08 0.08 0.045 0.03;
./moparParser.py 'runsOut/plate11Mopar/output' 'gridData/plate11Mopar' 0.5 2.5 0.1 0.1;
./moparParser.py 'runsOut/plate5Mopar/output' 'gridData/plate5Mopar' 0.5 2.5 0.1 0.1;

sed -i '' 's/y\[m\]/Y/g' gridData/irv5Mopar.dat; 
sed -i '' 's/x\[m\]/X/g' gridData/irv5Mopar.dat; 
sed -i '' 's/y\[m\]/Y/g' gridData/irv11Mopar.dat; 
sed -i '' 's/x\[m\]/X/g' gridData/irv11Mopar.dat; 
sed -i '' 's/y\[m\]/Y/g' gridData/plate5Mopar.dat; 
sed -i '' 's/x\[m\]/X/g' gridData/plate5Mopar.dat; 
sed -i '' 's/y\[m\]/Y/g' gridData/plate11Mopar.dat; 
sed -i '' 's/x\[m\]/X/g' gridData/plate11Mopar.dat; 

echo "Finished the parsing's portion"

matlab -nodesktop -nosplash -r "allOPL; exit" 
mv gridData runsOut; 
