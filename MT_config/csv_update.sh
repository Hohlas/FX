#!/bin/bash   
# csv_update.sh  script to download #.csv files to all terminals
source $HOME/.bashrc
cd $GitFiles/FX && echo 'Download files from GitHub'
git pull origin main --no-commit # забрать изменения
SYMBOLS=(USDx DARW EUR USD) # названия папок/ярлыков   
for index in ${!SYMBOLS[*]}
do
SYM=${SYMBOLS[$index]}
# копирование настроек
cp $MT$SYM/MQL4/Files/MatLab* $GitFiles/FX/MatLab$SYM".csv"
cp $GitFiles/FX/'#.csv' $MT$SYM/MQL4/Files
done
cd $GitFiles/FX
