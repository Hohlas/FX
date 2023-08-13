#!/bin/bash   
# script to copy MatLab.csv files to .mt4/GitFiles/FX
# and update #.csv and experts files for all terminals

source $HOME/.bashrc
cd $GitFiles/FX && echo 'Download csv files from GitHub to .mt4/GitFiles/FX'
git pull origin main --no-commit # забрать изменения
cd $GitFiles/Fast20 && echo 'Download experts files from GitHub to .mt4/GitFiles/Fast20'
git pull origin main --no-commit # забрать изменения
echo 'copy MatLab.csv files to .mt4/GitFiles/FX and update #.csv and experts files for all terminals'
TERMINAL_LIST=($SYMBOLS) # названия папок/ярлыков   
for index in ${!TERMINAL_LIST[*]}
do
SYM=${TERMINAL_LIST[$index]}
# копирование настроек
cp $MT$SYM/MQL4/Files/MatLab* $GitFiles/FX/MatLab$SYM".csv"
cp $GitFiles/FX/'#.csv' $MT$SYM/MQL4/Files
cp -r $GitFiles/Fast20 $MT$SYM/MQL4 
echo 'Download MatLab'$SYM'.csv to .mt4/GitFiles/FX, and upload #.csv, experts to ..'$SYM'/MQL4/Experts'
done
cd $GitFiles/FX
#git add MatLabUSD.csv
#git commit -m "Upload MatLab files" #	создание коммита
#git push origin	main	# отправить ветку MAIN на github
