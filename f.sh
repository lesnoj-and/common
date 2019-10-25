#!/bin/bash
#f.sh 2>/dev/null | sort -nk1

# Максимальное время выполнения скрипта по всем роверам
slp=300

#Список роверов
 
rovers="walter
wanathon
foss
roe
hanaryo
ehawee
akane
scott
doshin
chris
takoda
manu
bryan
lester
albert
armistice
stubbs
yoriki
rebus
charlotte
akecheta
holden
bart
etu
tommy
tenderloin
donald
marshal"

rm /tmp/fuel_new
rm /tmp/fuel_all
rm /tmp/fuel_rec

echo -n "Время запуска "
date


awwk="'{printf \"%d\n\", \"0x\"\$4;}'"
counter ()
{
  
  fuel()
  {
  echo $1 >> /tmp/fuel_all
#-T 1000 -n 1000000
  ssh $1.ssh.sdc.yandex.net "candump can1 | grep 7F4 -m 24 | awk ${awwk} " | awk 'BEGIN {sum = 0.0; num = 0} {sum += $1 ; num += 1;} END {print int (sum / num /2) }'
  
  }

#sd="$(fuel $1)" && let "l=$sd*100/45*100/100" && echo $1 >> /tmp/fuel_new && echo -e "$l %\t$1 ($sd l)" &

sd="$(fuel $1)" && let "l=$sd*100/45*100/100" && echo $1 >> /tmp/fuel_new && echo -e "$l %\t$1 ($sd l)" >> /tmp/fuel_rec &

} 

for i in $rovers
    do
     	let n_rover=$n_rover+1
	counter $i
     	#echo Запросов: $n_rover 
    done


let spl=$slp/100

for ((i=0; i < 101; i=i+1))
    do
	sleep $spl
	echo -en "\rВыполнено $i % "
	
    done

echo -n Запросов: $n_rover " "
#e_rover="$(cat /tmp/fuel_new | wc -l)"

e_rover="$(wc -w /tmp/fuel_new | awk '{printf $1}')"

echo -n Ответов: $e_rover " "
let "s_rover=$n_rover - $e_rover"
echo Нет данных: $s_rover
sort -o /tmp/fuel_all /tmp/fuel_all
sort -o /tmp/fuel_new /tmp/fuel_new
diff /tmp/fuel_all /tmp/fuel_new | grep \<
#sort -o /tmp/fuel_rec /tmp/fuel_rec
cat /tmp/fuel_rec | sort -nk1


#wait
