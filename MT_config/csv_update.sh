#!/bin/bash   
# script to copy MatLab.csv files to .mt4/GitFiles/FX
# and update #.csv and experts files for all terminals
source $HOME/.bashrc
cd $GitFiles/FX && echo 'Download csv files from GitHub to .mt4/GitFiles/FX'
git pull origin main --no-commit # забрать изменения
cd $GitFiles/Fast20 && echo 'Download experts files from GitHub to .mt4/GitFiles/Fast20'
git pull origin main --no-commit # забрать изменения

TERMINAL_LIST=($SYMBOLS) # названия папок/ярлыков   
for index in ${!TERMINAL_LIST[*]}
do
SYM=${TERMINAL_LIST[$index]}
# копирование настроек
cp $MT$SYM/MQL4/Files/MatLab* $GitFiles/FX/MatLab$SYM".csv" && echo 'Download MatLab'$SYM'.csv to .mt4/GitFiles/FX'
cp $GitFiles/FX/'#.csv' $MT$SYM/MQL4/Files && echo 'Download #.csv from .mt4/GitFiles to ..'$SYM'/MQL4/Files'
cp -r $GitFiles/Fast20 $MT$SYM/MQL4 && echo 'Download experts files from .mt4/GitFiles to ..'$SYM'/MQL4/Experts'
done
cd $GitFiles/FX
