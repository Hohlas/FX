#!/bin/bash
SYMBOLS='USDx DARW EUR USD ROBO DEMO'
echo "export SYMBOLS='"$SYMBOLS"'" >> $HOME/.bashrc
echo 'export MT4="$HOME/.mt4/drive_c/Program Files (x86)/MetaTrader 4"' >> $HOME/.bashrc
echo 'export MT=$HOME/.mt4/drive_c/' >> $HOME/.bashrc
echo 'alias fx_clone=~/FX/MT_config/csv_update.sh' >> $HOME/.bashrc

if [ ! -d ~/Fast20 ]; then git clone https://github.com/Hohlas/Fast20.git ~/Fast20
else 
cd ~/Fast20; 
git fetch origin; # get last updates from git
git reset --hard origin/main # сбросить локальную ветку до последнего коммита из git
fi 

source $HOME/.bashrc

rm -r "$MT4"/config/*
rm -r "$MT4"/profiles/*
cp -r ~/FX/MT_config/config/* "$MT4"/config/ && echo 'copy config files to '$MT4
cp -r ~/FX/MT_config/profiles/* "$MT4"/profiles/ && echo 'copy profiles files to '$MT4
# copy expetrs to MetaTrader4 dir
rm -r "$MT4"/MQL4/Experts
rm -r "$MT4"/MQL4/Include
rm -r "$MT4"/MQL4/Indicators
rm -r "$MT4"/MQL4/include
rm -r "$MT4"/MQL4/indicators
cp -r ~/Fast20/Experts "$MT4"/MQL4/
cp -r ~/Fast20/Include "$MT4"/MQL4/
cp -r ~/Fast20/Indicators "$MT4"/MQL4/
