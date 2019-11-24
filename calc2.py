import math  

what = input ( "what u want? (cos, sin, log, sqrt): " )
a = int(input("Input a number: "))

if what == "cos":
	a = math.cos (a)
	print ("result: " + str(a))
elif what == "sin":
	a = math.sin (a)
	print ("result: " + str(a))
elif what == "log":
	a = math.log (a)
	print("result: " + str(a))
elif what == "sqrt":
	c = math.sqrt (a)
	print("result: " + str(a))

print("Thx for using myCalc" )