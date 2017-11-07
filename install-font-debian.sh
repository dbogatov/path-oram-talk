#!/usr/bin/env bash

apt update
apt install -y wget unzip 

wget https://github.com/carrois/Fira/archive/master.zip
unzip master.zip
mkdir -p /usr/share/fonts/opentype/fira_code
mkdir -p /usr/share/fonts/opentype/fira_mono
mkdir -p /usr/share/fonts/opentype/fira_sans
cp Fira-master/Fira_Code_3_2/Fonts/FiraCode_OTF_32/* /usr/share/fonts/opentype/fira_code
cp Fira-master/Fira_Mono_3_2/Fonts/FiraMono_OTF_32/* /usr/share/fonts/opentype/fira_mono
cp Fira-master/Fira_Sans_4_2/Fonts/FiraSans_OTF_4203/Normal/Roman/* /usr/share/fonts/opentype/fira_sans
cp Fira-master/Fira_Sans_4_2/Fonts/FiraSans_OTF_4203/Normal/Italic/* /usr/share/fonts/opentype/fira_sans
