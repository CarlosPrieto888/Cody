#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"

export DEBIAN_FRONTEND=noninteractive       #Lo que hace es desactivar interaciones de forma grafica con el usuario

trap ctrl_c INT             #Establece las teclas ctrl y c

function ctrl_c(){
    echo -e "\n ${greenColour}[*]exiting of program...${endColour}"
    exit 0
}

function helpi(){
  echo -e "\n ${redColour}[*]${endColour}${yellowColour}This program decode a file. Also is able to encrypte a file${endColour}\n"
  echo -e "\n ${redColour}[*]${endColour}${yellowColour} d You decode a file, example-> ./cody -d file${endColour}\n"
  echo -e "\n ${redColour}[*]${endColour}${yellowColour} e You encrypte a file, example-> ./cody -e file${endColour}\n"
  exit 0
}

function dependencies(){
  tput civis        #sirve para quitar el cursor añadir al final "tput cnorm" para volverlo añadir
  clear; echo -e "\n${redColour}[*]${endColour}${yellowColour}It is checking programs intalled...${endColour}"
  sleep 1; dependencies=(7z base64)

  #dependencies(aircrak-ng,macchanger)

  for programs in ${dependencies[@]}; do
    test -f /usr/bin/$programs
    
    if test "$(echo $?)" == "0"
        then
        echo -e "\n${greenColour}[V]${endColour}${yellowColour}$programs is installed${endColour}"
    else
        echo -e "\n${redColour}[X]${endColour}${yellowColour}it will be installed programs need...${endColour}"
        echo -e "\n${redColour}[X]${endColour}${yellowColour}You should be a user root${endColour}"
        sleep 1
        sudo apt-get remove $programs -y >/dev/null 2>&1
        sudo apt-get install $programs -y >/dev/null 2>&1
    fi
  done
}

function encrypte(){
    test -f /usr/bin/figlet
    if test "(echo$?)" == "0"
    then 
        filglet Cody
    fi
    
    dependencies
    
    echo -e "\n${redColour}[X]${endColour}${yellowColour}it start to encrypte file...${endColour}"
    echo $1
    file $1 | grep -q compressed        # Verifica si un archivo esta comprimido o no
    
    if test "$(echo $?)" == 0
    then
       echo -e "\n${redColour}[X]${endColour}${yellowColour}You file is compressed...${endColour}"
       echo -e "\n${redColour}[X]${endColour}${yellowColour}You file will be discompress...${endColour}"
    fi
    
    base64 $1 > Encripte                             
    
    for i in {1..100} 
    do
       7za a Encripte.7z encripte >/dev/null 2>&1
    done
	tput cnorm
 	exit 0
}

function decode(){
    test -f /usr/bin/figlet
    if test "(echo$?)" == "0"
    then 
        filglet Cody
    fi
    
    dependencies
    echo -e "\n${redColour}[X]${endColour}${yellowColour}it start to decode file...${endColour}"
    
    for i in {1..100} 
    do
       7za e Decode >/dev/null 2>&1
    done
	
	base64 -d $1 > Decode
	
	tput cnorm
    exit 0
}

  #Function Main
  if test "$#"-it"3"
    echo $*
    then

     if test "$1" = "e"
  	    then
  	    encrypte $2;
     elif test "$1" = "d"
  	    then
  	    decode $2;
     else
  	    helpi;
     fi
     
    else
        helpi;
  fi
