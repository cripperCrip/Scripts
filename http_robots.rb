require 'socket'
require 'uri'

subpages=[]

print "Enter a domain: (default is 'as.com'):" 				  # Solicita al usuario un dominio

input = gets.chomp
url = URI.parse("http://#{input.empty? ? 'as.com' : input}/") # Obtiene el dominio que el usuario ha introducido.
puts "Downloading #{url.to_s} =="							  # Si el dominio está en blanco, toma por defecto as.com

connection = TCPSocket.new url.host, 80						  # Monta y envia la petición al servidor al puerto 80
connection.puts "GET /robots.txt HTTP/1.1"					  # solicitándole el contenido del fichero "robots.txt"
connection.puts "Host: #{url.host}"								
connection.puts "Connection: close" 						  # El servidor se desconecta cuando complete la petición						  
connection.puts "\n"                 						  # Cadena para indicar al servidor el final de la petición
                                     

while line = connection.gets								  # Por cada línea de la respuesta hace:

  if line =~ /HTTP(\W\d){2}\s\d{3}\s\w*/ 					  # Analiza si la linea es el resultado de la operación y si es:
	http_version = line[0,8]								  # Obtiene la versión de la petición
	http_result = line[9,3].to_i							  # El resultado de la petición (200, 300, 404 ...)
	http_result_detail = line[13...line.length]				  # Detalles de la petición
															  # Analiza el resultado de la petición
	if (http_result >= 200) and (http_result < 300)			  # Si es correcta (code entre 200 y 300), imprime "Request OK"
	   puts "Request OK"
	elsif (http_result >= 300)								  # Si es errónea (code mayor de 300). Error de servidor, de petición..
	  puts "Page not found"									  # Imprime página no encontrada
	  break													  # Si no es ningún caso de los anteriores, imprime ERROR
	else
	  puts "Error"
	  break
	end	
  elsif line =~ /Disallow: \S\w*\S/							  # Si la petición ha sido correcta, analiza donde comienza a 
	subpage = line[10...line.length-1]						  # pintar las subpaginas que contiene el fichero que comenzarán
	subpages.push(subpage)									  # con la palabra Disallow y que obedecen a esa expresión regular.
															  # Si encuentra una pagina, la "mete" en un array como pagina encontrada
  end

end

connection.close											  # Cierra la conexión.
															  # Una vez obtenidas las paginas del fichero, por cada una intenta
															  # conectar. Analiza el resultado
subpages.each do |subpage|

	connection = TCPSocket.new url.host, 80					  # Monta la petición igual que antes solamente que la monta
	connection.puts "GET #{subpage} HTTP/1.1"				  # en busca de la página encontrada en el fichero robots.txt
	connection.puts "Host: #{url.host}"
	connection.puts "Connection: close" 
	connection.puts "\n"                
	                                    
	while line = connection.gets							  # Analiza cada una de las lineas obtenidas
		if line =~ /HTTP(\W\d){2}\s\d{3}\s\w*/ 				  # Mismo procedimiento que antes. Busca la linea HTTP ..
	       		http_version = line[0,8]					  # Guarda el resultado
	        	http_result = line[9,3].to_i
	        	http_result_detail = line[13...line.length]

        		if (http_result >= 200) and (http_result < 300) # Analiza el resultado y muesta por pantalla
	           		puts "Request OK - #{subpage}"
        		elsif (http_result >= 300)
	          		puts "Page not found - #{subpage}"
	          		break
        		else
	          		puts "Error"
        	  		break
	        	end
		end
	end
	
	connection.close										 # Cierra conexión
end

puts "Done downloading #{url.to_s}"
											
