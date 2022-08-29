require 'rest-client'
require 'json'
require 'base64'

#Es una expresión regular para ayudar en el método convert. Como es una variable constante no se puede definir dentro de métodos
REGEXP = /\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/m

def logIn
    begin
        puts "Digite su nombre de usuario"
        us = gets.chomp
        puts "Digite su contraseña"
        pas = gets.chomp
        response = RestClient.post "https://codeqr-generate.herokuapp.com/api/auth/login", {'username' => us , 'password' => pas }.to_json, {content_type: :json, accept: :json}
        temp = JSON.parse(response)
        #variable global para guardar el id del usuario que inició sesión con el fin de usarlo por ej en generar codigo qr se necesita el id del usuario
        $id_usuario = temp['usuario']['id_usuario']
        response.code == 200
    rescue => e
        puts e
    end
end

def signUp
    begin
        puts "--Registrar--"
        puts "Digite un nombre de usuario"
        us = gets.chomp
        puts "Digite una contraseña"
        pas = gets.chomp
        puts "Digite su nombre"
        na = gets.chomp
        puts "Digite su email"
        em = gets.chomp
        response = RestClient.post "https://codeqr-generate.herokuapp.com/api/auth/register", {'username' => us , 'password' => pas , 'email' => em , 'name' => na }.to_json, {content_type: :json, accept: :json}
        response.code == 200
    rescue => e
        puts e
    end
end

def generarQR
    begin
        puts "--Generar código QR--"
        puts "Digite la url"
        u = gets.chomp
        response = RestClient.post "https://codeqr-generate.herokuapp.com/api/code/", {'url' => u , 'user' => $id_usuario }.to_json, {content_type: :json, accept: :json}
        temp = JSON.parse(response)
        qr = temp['qr_code']['url_code'] #la peticion post me retorna un json con varios valores el cual solo interesa la llave url_code cuyo  valor es un codigo base64  que se generó a partir de la url el cual hay que convertir a imagen
        convert(qr)
    rescue => e
        puts e , 'URL incorrecta'
    end

end

def convert(qr)
        qr_code = qr.match(REGEXP) || [] #comparar el codigo base64 con la expresión regular de la variable constante REGEXP
        extension = MIME::Types[qr_code[1]].first.preferred_extension
        file_name = "myfilename.#{extension}"
        File.open(file_name, 'wb') do |file|
            file.write(Base64.decode64(qr_code[2])) #crear un archivo tipo imagen y escribirle dentro la decodificación del base64
        end
end

def consultarHistorial
    begin
        puts "--Historial--"
        response = RestClient.post "https://codeqr-generate.herokuapp.com/api/code/historial", {'user' => $id_usuario}.to_json, {content_type: :json, accept: :json}
        temp = JSON.parse(response) #para convertirlo a hash ruby y poder manipularlo
        temp['codes'].each do |key| #la peticion post me retorna un json con varios valores el cual interesa la llave codes que es un arreglo donde se encuentran todos los QR generados y se recorren todos los elementos donde se escogen solo los valores id, url y url_code que son los que interesa mostrarle al usuario
            puts "ID: #{key['id_code']} URL: #{key['url']} CODE_QR: #{key['url_code']}  \n*************************************************************************"  
        end
    rescue => e
        puts e , 'URL incorrecta'
    end
end

def funcionalidades
    loop do
        puts  "************Menú***************** \n" + "    1. Generar QR \n" + "    2. Consultar historial \n"  + "    3. Cerrar sesión \n" + "******************************** \n"
        puts "Ingresa el número de la opción"
        option = gets.chomp.to_i

        if option == 1

            generarQR()

        elsif option == 2

            consultarHistorial()
        
        elsif option == 3

            puts "Cerrando sesión..."
        
        else 

            puts "Número digitado erroneo"
        end

    break if option == 3
    end
end



#****************************************** MAIN ********************************************************************************************************************************************************

begin
    loop do
        puts  "************Menú***************** \n" + "    1. Iniciar sesión \n" + "    2. Registrar nuevo usuario \n"  + "    3. Salir \n" + "******************************** \n"
        puts "Ingresa el número de la opción"
        options = gets.chomp.to_i

        if options == 1

            if logIn()
                puts "---Bienvenido---"
                funcionalidades()
            else 
                puts "Usuario o contraseña incorrecta"
            end

        elsif options == 2 

            if signUp() 
                puts "Usuario Registrado"
            else 
                puts "Usuario no registrado"
            end

        elsif options == 3

            puts "Gracias por participar :)"

        else 
            puts "Número digitado erroneo"
        end

    break if options == 3
    end

rescue => e
    puts  e
end