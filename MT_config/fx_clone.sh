echo 'update from GitHub ~/FX and ~/Fast20'
cd ~/Fast20; git fetch origin; git reset --hard origin/main
cd ~/FX; git fetch origin; git reset --hard origin/main
chmod +x ~/FX/MT_config/*.sh


TERMINAL_LIST=($SYMBOLS) # названия папок/ярлыков   
for index in ${!TERMINAL_LIST[*]}
do
SYM=${TERMINAL_LIST[$index]}
# копирование настроек
cp $MT$SYM/MQL4/Files/MatLab* ~/FX/Portfolio/MatLab$SYM".csv"
cp ~/FX/Portfolio/'#.csv' $MT$SYM/MQL4/Files
rm -r $MT$SYM/MQL4/Experts
rm -r $MT$SYM/MQL4/Include
rm -r $MT$SYM/MQL4/Indicators
cp -r ~/Fast20/* $MT$SYM/MQL4
echo 'Download MatLab'$SYM'.csv to ~/FX/Portfolio, and upload #.csv, experts to ..'$SYM'/MQL4/Experts'
done
cp ~/FX/Portfolio/'#demo.csv' $MT/DEMO/MQL4/Files/'#.csv'
cd ~/FX

