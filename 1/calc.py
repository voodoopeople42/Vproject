import math  

what = input ( "what u want? (+, -, /, *, cos, sin, log, sqrt): " )


if what == "+":
	a = float (input("first number: "))
	b = float (input("second number: "))
	c = a + b
	print ("result: " + str(c))
elif what == "-":
	a = float (input("first number: "))
	b = float (input("second number: "))
	c = a - b
	print("result: " + str(c))
elif what == "/":
	a = float (input("first number: "))
	b = float (input("second number: "))
	c = a / b
	print("result: " + str(c))
elif what == "*":
	a = float (input("first number: "))
	b = float (input("second number: "))
	c = a * b
	print("result: " + str(c))
elif what == "cos":
	a = float (input("Input a number: "))
	a = math.cos (a)
	print ("result: " + str(a))
elif what == "sin":
	a = float (input("Input a number: "))
	a = math.sin (a)
	print ("result: " + str(a))
elif what == "log":
	a = float (input("Input a number: "))
	a = math.log (a)
	print("result: " + str(a))
elif what == "sqrt":
	a = float (input("Input a number: "))
	c = math.sqrt (a)
	print("result: " + str(a))

print("Thx for using myCalc" )