#!/usr/bin/python
#-*- coding: utf-8 -*-

import dns
import dns.resolver
import dns.query
import dns.zone
import pythonwhois
import sys

# vars definitions
defTargetsNumber = 2
n = 0
targetNumber = 0
targetList = []
userAnswer = False
Yes="S"
No="N"

while userAnswer == False:
# asking user to write the targets
	while n < defTargetsNumber:
		name = raw_input("Introduzca el objetivo %d: " % (n+1))
		targetList.append(name)
		n = (n+1)

# showing user targets introduced
	for n in targetList:
		print("El objetivo %d es: %s" % ((targetNumber+1), n))
		targetNumber = (targetNumber+1)

# asking user confirmation. If there are the targets, user must answer S
# If there are any mistakes, user must answer N. Other not recognize option
# it asks again
	while 1:
		answer = raw_input("¿Son estos los objetivos correctos [S/N]?: ")

		if answer == Yes:
			userAnswer = True
			break
		elif  answer == No:
			targetList = []
			n = 0
			break
		else:
			print("No es una opción válida [S/N]")


# After user has answered about targets, it obtains DNS and WHOIS information
print("-------------- Obteniendo información de los objetivos -------------")
print("--------------------------------------------------------------------")

for target in targetList:

	print (" ====================")
	print (" OBJETIVO %s" % target.upper())
	print (" ====================")

	#A registers
	print ("-------------- A ---------------")
	try:
		answerA = dns.resolver.query(target, 'A')
		print answerA.response.to_text()
	except:
		print ("No se han registros A para el objetivo %s" % target)

	#MX registers
	print ("------------- MX --------------")
	try:
		answerMX = dns.resolver.query(target, 'MX')
		print answerMX.response.to_text()

	except:
		print ("No se han encontrado registros MX para el objetivo: %s" % target)

	#NS registers
	print ("------------- NS -------------")
	try:
		answerNS = dns.resolver.query(target, 'NS')
		print answerNS.response.to_text()
	except:
		print ("No se han encontrado registros NS para el objetivo: %s" % target)

	#IPV6 registers
	print ("----------- IPV6 ------------")
	try:
		answerAAAA = dns.resolver.query(target, 'AAAA')
		print answerAAAA.response.to_text()
	except:
		print ("No se han encontrado resgistros IPV6 para el objetivo: %s" % target)

	#WHO IS
	print ("--------- WHO IS -----------")
	try:
		whois = pythonwhois.get_whois(target)
		for key in whois.keys():
			print("%s : %s" % (key, whois[key]))
	except:
		print("No se ha podido recuperar informacion de whois  para el objetivo: %s" % target)

	print("")
