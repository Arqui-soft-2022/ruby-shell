require 'rest-client'
require 'json'

def logIn
    begin
        puts "Digite su nombre de usuario"
        us = gets.chomp
        puts "Digite su contraseña"
        pas = gets.chomp
        response = RestClient.post "https://codeqr-generate.herokuapp.com/api/auth/login", {'username' => us , 'password' => pas }.to_json, {content_type: :json, accept: :json}
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