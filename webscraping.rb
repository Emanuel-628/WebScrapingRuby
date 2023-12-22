require 'nokogiri'
require 'open-uri'
require 'net/http'

#Conectarse al sitio web
url = 'https://cienciasdelsur.com/'
uri = URI.parse(url)
response = Net::HTTP.get_response(uri)
html = response.body

doc = Nokogiri::HTML.parse(html)
links = doc.css("a.#{'td-image-wrap'}") #busco todos los enlaces de esa clase en especifica
enlaces = [] #creo una lista para guardar los enlaces
links.each do |i|
  enlaces << i['href']
end

# #Scraping de todos los enlaces
texto = "" #en esta variable voy a guardar todo el documento que ira exportado a un archivo
i=4 #el contador empieza en 4, porque ahi esta el primer enlace
File.open('EXTRACCION_TEXTOS.txt', 'w', :encoding => 'utf-8') do |f| #se crea el archivo y se guarda la informacion
  f.write(texto)
end

while i<enlaces.length do #con este while recorre mi lista de enlace para scrapear todos los enlaces
  url = enlaces[i]
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)
  html = response.body
  doc = Nokogiri::HTML.parse(html)
  titulo = doc.css('h1.entry-title').text #se extrae el titulo del articulo
  texto += titulo #se guarda el titulo para luego concatenar con el articulo
  articulo = doc.css('div.td-post-content.tagdiv-type').text  # #extraigo todo el contenido del articulo
  texto += articulo  # concateno el título del artículo con el contenido
  File.open('EXTRACCION_TEXTOS.txt', 'a', :encoding => 'utf-8') do |f| #se crea el archivo y se guarda la informacion
    f.write(texto)
  end
  i+=1 #se pasa al siguente enlace
  texto ="" #se reinicia la variable
end

file_content = File.read("EXTRACCION_TEXTOS.txt", :encoding => 'utf-8') #se lee el archivo
word_array = file_content.downcase.scan(/\b[\p{L}\p{N}]+\b/) #se crea una lista con las palabras basados en la siguente expresion regular y convertidas a minuscula

word_frequency = Hash.new(0) #se crea un hash para guardar las palabras y sus frecuencias

#se crea una lista de palabras a excluir
no_deseadas = ["qué", "fue", "que", "de", "la", "n", "a", "en", "y", "el", "del", "las",
            "los", "se", "una", "s", "para", "es", "por", "un", "m", "con","actualmente",
            "no", "cient", "como", "o", "al", "su", "este", "l","author","lo","com","son","https","cienciasdelsur",
            "sobre","sus","e","desde","esta","puede","entre","si","sin","ser","myradio","esto","uno","alejandra",
            "pero","otros","foto","m-a-box-tab-active","id","ciencia-del-sur","debe","5","forma","hay","parte","ha",
            "nos","1","tiene","ejemplo","Alejandra","te","ya","sosa","todo","the","hasta","gran","donde","muy","otra","tienen",
            "estas","falta","compartir","mabid","cuando","label","estos","queryselector","acceso","document","classlist","vez",
            "related","sea","hace","pueden","le","4","about","cada","cual","i","dos","ni","sino","existe","www","solo","min","otras",
            "posts","tener","embargo","p","ese","nuestro","muchas","porque","cantidad","galeano","2022","más","también","así",
            "https://cienciasdelsur.com/author/ciencia-del-sur","cómo","través","document.queryselector","benítez","según","está","además",
            "https://cienciasdelsur.com/author/glkuwssnkcrhomwm","https://cienciasdelsur.com/author/fabrizio-pomata","r","tarski","toda",
            "of","r","aine","logic","aunque","luego","verdad","sebastián","alberto","adriana","alvarenga","cualquier","deben","university",
            "press","algunas","uso","r","fbf","dentro","pues","graw-hill","significa","definir","box","tab","active","personas"]

#se carga el hash
word_array.each do |word|
  if !no_deseadas.include?(word)
    word_frequency[word] += 1
  end
end

top_words = word_frequency.sort_by { |word, frequency| -frequency }.first(50) #se ordena el hash y se tiene en cuenta solo los primeros 50

top_words.each do |word, frequency| #se imprimen las 50 palabras con sus apariciones
  puts "#{word}: #{frequency}"
end

File.open("FRECUENCIA_PALABRAS.txt", "w", :encoding => 'utf-8') do |file| #se guardan las palabras y sus apariciones en un archivo nuevo
  top_words.each do |word, frequency|
     file.write("#{word}: #{frequency}\n")
   end
end

#Item 2
#Conectarse al sitio web
url = 'https://cienciasdelsur.com/'
uri = URI.parse(url)
response = Net::HTTP.get_response(uri)
html = response.body

doc = Nokogiri::HTML.parse(html)
links = doc.css("a.#{'td-image-wrap'}") #busco todos los enlaces de esa clase en especifica
enlaces = [] #creo una lista para guardar los enlaces
links.each do |i|
  enlaces << i['href']
end

print "Ingrese su palabra compuesta: "
palabra_compuesta = gets.chomp
apariciones = 0 # variable para guardar la cantidad de apariciones de la palabra compuesta

#Scraping de todos los enlaces
i = 4 #el contador empieza en 4, porque ahi esta el primer enlace

while i < enlaces.length # Este while es basicamente igual al primero
  uri = URI.parse(enlaces[i])
  response = Net::HTTP.get_response(uri)
  html = response.body
  doc = Nokogiri::HTML.parse(html)
  text = doc.text
  if text.include?(palabra_compuesta) #verifica si encuentra la palabra compuesta en el texto
    apariciones+=1
  end
  i += 1 #paso al siguente enlace
end

#Se muestra la palabra y sus apariciones si se encontro
if apariciones > 0
  puts "Se encontraron #{apariciones} apariciones de la palabra compuesta: #{palabra_compuesta}"
else
  puts 'No se encontraron apariciones de la palabra compuesta.'
end
