##
# This module requieres Metasploit: htto://metasploit.com/download
##

require 'rex/proto/http'
require 'msf/core'
require 'thread'


class MetasploitModule < Msf::Auxiliary

	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Scanner
  	include Msf::Auxiliary::Report

	def initialize(info = {})											# Definición de variables del modulo en metasploit
	   super(
		 'Name' 	 => 'Robots.txt scanner',			
		 'Description'	 => %q{'Taking a connection to a http server
					tries to obtain all subpages thar are 
					described into robots.txt server file. 
					Once that file was found, 
					checks all subpages found'},
		 'License'	 => MSF_LICENSE,
		 'Author'	 => 'Roberto Rubio Marcos',
		)
		   
		register_options(												# Definición del puerto. El módulo lo solicita como opción
		 [															    # pero por defecto será el 80
			Opt::RPORT(80),

		 ], self.class)
	end
	
	def port
	  datastore['RPORT']
	end
	
	def run_host(ip)

	     subpagesFound=[]

	     res = send_request_raw({										# Monta y envía la primera petición al servidor cuya ip
      		'uri'                 => '/robots.txt',						# está contenida en la variable ip que se le pasa por parámetro
       		'method'      	      => 'GET',								# Petición solicitando el fichero robots.txt
       		'version'             => '1.1'
    	      }, 10)

             return if not res

	     tcode = res.code.to_i	
	     body = res.body
	     print_status("Código de la petición: #{tcode}")				# Muestra como estado el código devuelto por la respuesta

	     if (tcode >= 200) and (tcode < 300)							# Si el código es exitoso, comienza a intentar obtener las subpaginas
																		# que en el fichero están escritas
	  	print_good("#{ip}/robots.txt found")								
		counter = 0
		lastCounter = 0

		while counter < body.length

			if (body[counter] == "\n")
			   subpage = body[lastCounter...counter]

			   if subpage =~  /Disallow: \S\w*\S/						# Busca en el cuerpo de la respuesta, lineas que cumplan ese patron.
			      subpagesFound.push(subpage[10...subpage.length-1])	# De ellas extráe el contenido porque son las subpaginas que contiene
			      print_good("subpage found --> #{subpage}")			# el fichero
			   end
					
			   counter=counter+1
			   lastCounter=counter

			else
				counter=counter+1
		        end
		end

		subpagesFound.each do |subpage|									# Por cada subpagina encontrada, comprueba su disponibilidad

			print_status("Trying --> subpage: #{subpage}")

			res = send_request_raw({									# Monta la petición para la subpagina
               		   'uri'                 => '#{subpage}/',
                	   'method'              => 'GET',
                	   'version'             => '1.1'
             		}, 10)			

			if res
				
				if (res.code.to_i >= 200) and (res.code.to_i < 300)
				 	print_good("#{subpage} found and answering")		# Comprueba el código de la respuesta para saber si esta disponible
				else
					print_error("#{subpage} found but is not answering")
				end
			end
		end

	    elsif (tcode >= 300)

		print_error("#{ip} #{subpage}/ failed")
	    end
		
	end
end
