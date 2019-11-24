import math  

what = input ( "what u want? (+, -, /, *): " )
a = float (input("first number: "))
b = float (input("second number: "))

if what == "+":
	c = a + b
	print ("result: " + str(c))
elif what == "-":
	c = a - b
	print("result: " + str(c))
elif what == "/":
	c = a / b
	print("result: " + str(c))
elif what == "*":
	c = a * b
	print("result: " + str(c))

input()