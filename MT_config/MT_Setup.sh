cd && rm -r Music Videos Pictures Public 
echo 'export MT4=$HOME/.mt4/dosdevices/c:/Program\ Files/MetaTrader\ 4' >> $HOME/.bashrc
echo 'export MT=$HOME/.mt4/dosdevices/c:/' >> $HOME/.bashrc
echo 'export GitFiles=$HOME/.mt4/GitFiles' >> $HOME/.bashrc
echo 'export GitFx=https://raw.githubusercontent.com/Hohlas/FX/raw/main' >> $HOME/.bashrc 
source $HOME/.bashrc
mkdir -p $GitFiles; echo 'create GitFiles folder' ; 
cd $GitFiles
# curl $GitFx/MT_config/config/accounts.ini > ~/Desktop/tmp/accounts.ini
echo 'copy files from GIT to GitFiles folder'
cd $GitFiles && git clone https://github.com/Hohlas/FX.git
# git pull origin	main # забрать изменения
cd $GitFiles &&  git clone https://github.com/Hohlas/Fast20.git


# copy 'config' to MetaTrader4 dir
cp -r $HOME/FX/MT_config/config/* "$MT4"/config/ 
rm -r "$MT4"/profiles/*
cp -r $HOME/FX/MT_config/profiles/* "$MT4"/profiles/ 
# copy expetrs to MetaTrader4 dir
rm -r "$MT4"/MQL4/Experts
rm -r "$MT4"/MQL4/Include
rm -r "$MT4"/MQL4/Indicators
cp -r $HOME/Fast20/Experts "$MT4"/MQL4/
cp -r $HOME/Fast20/include "$MT4"/MQL4/
cp -r $HOME/Fast20/indicators "$MT4"/MQL4/
# copy 'MetaTrader4' dir to 'USD,EUR...' dirs
SYMBOLS=(USD2 DARW EUR USD) # названия папок/ярлыков   
for index in ${!SYMBOLS[*]}
do
SYM=${SYMBOLS[$index]}

if [ ! -d $MT$SYM ]; then 
mkdir -p $MT$SYM; echo 'create folder ' $SYM ; 
fi
# копирование папок с терминалом
# cp -r $HOME/.mt4/dosdevices/c:/Program\ Files/MetaTrader\ 4/* $MT$SYM

# Создание ярлыков запуска терминалов на рабочем столе
cat > $HOME/Desktop/$SYM.desktop <<EOF
[Desktop Entry]
Name=$SYM
Exec=env WINEPREFIX="$HOME/.mt4" wine-stable C:\\\\\\\\windows\\\\\\\\command\\\\\\\\start.exe /Unix $MT$SYM/terminal.exe
Type=Application
StartupNotify=true
Path=$MT$SYM
Icon=56C0_terminal.0
StartupWMClass=terminal.exe
EOF
# Создание ярлыков на папки терминалов
ln -s $MT$SYM $HOME/Desktop
 echo 'create desktop link ' $SYM ; 
done
