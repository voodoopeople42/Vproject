from colorama import init
from colorama import Fore, Back, Style

# use Colorama to make Termcolor work on Windows too
init()

import pyowm

owm = pyowm.OWM('5c1e4eb39849b5315ae8376ba2a8a44e', language = "ru")

print( Fore.BLACK )
print( Back.GREEN )
place = input ( "Which city are you interested in?: ")

observation = owm.weather_at_place(place)
w = observation.get_weather()

temp = w.get_temperature('celsius')["temp"]

print( Fore.BLACK )
print( Back.YELLOW)
print( "В городе " + place + " сейчас " + w.get_detailed_status())

print( Fore.BLACK )
print( Back.CYAN)
print( "Температура за бортом держится на уровне в " + str(int (temp)) + " градуса по цельсию"  )

if temp < 10:
	print( Fore.WHITE )
	print( Back.BLUE)
	print( "Не желательно выходить с дома((")
elif temp <15:
	print( "Терпимо, но все равно такое")
elif temp < 5:
	print ("Сук как холодно ")
else:
	print("Ваще кайф!")
	
	input()