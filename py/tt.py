
from colorama import init
from colorama import Fore, Back, Style

# use Colorama to make Termcolor work on Windows too
init()

print( Fore.BLACK)
print( Back.GREEN )

what = input ( "what u want? (+,-): " )

print( Fore.BLACK)
print( Back.CYAN )

a = float ( input ( "first number: ") )

print( Fore.BLACK)
print( Back.MAGENTA )

b = float ( input ("second number: ") )


print( Fore.BLACK)
print( Back.YELLOW )

if what == "+":
	c = a + b
	print ("result :" + str(c))
elif what == "-":
	c = a - b
	print("result :" + str(c))
else: 
	print( " BTW, nice try ")

input()