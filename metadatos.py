# -*- encoding: utf-8 -*-
#
#Notas:
#La función "walk" es útil para recorrer todos los ficheros y directorios que se encuentran incluidos en un directorio concreto.
#

from PyPDF2 import PdfFileReader, PdfFileWriter #importamos modulo y librerias'''
import os #importamos modulo socket para ir a otras carpetas'''

def printMeta():
    flag = False
    path = raw_input ("Introduzca el directorio seleccionado: ")
    print ("\n")
    print ("Obteniendo información para %s ......" % path)
    for dirpath, dirnames, files in os.walk(path): #para el directorio seleccionado, busca todos los ficheros
        for name in files: #recorre el array de ficheros encontrados en el directorio
            ext = name.lower().rsplit('.', 1)[-1] #el nombre del fichero lo pone en minúsculas y separa el nombre de la extensión
            if ext in ['pdf']:
		flag = True
		print "\n"
                print "[+] Metadata for file: %s " %(dirpath+os.path.sep+name) #pintamos el titulo de metadata for file y el directorio y nombre del documento'''
		print "------------------------------------------------------"
                pdfFile = PdfFileReader(file(dirpath+os.path.sep+name, 'rb')) #abrimos el fichero
                docInfo = pdfFile.getDocumentInfo() #creamos un diccionario con la info recolectada
		#se muestra los metadatos del fichero
                print " - Author: %s\n" % docInfo.author
		print " - Creator: %s\n" % docInfo.creator
		print " - Title: %s\n" % docInfo.title
		print " - Producer: %s\n" % docInfo.producer
		print " - Subject: %s\n" % docInfo.subject
		print " - CreationDate: %s\n" % docInfo["/CreationDate"]
                print "\n"

    if  (flag == False):
	print ("No se han encontrado resultados para el directorio: %s" % path)

printMeta() #invocamos la funcion 
