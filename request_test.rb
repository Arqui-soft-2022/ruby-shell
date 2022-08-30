require_relative 'environment.rb'

start   
prompt = TTY::Prompt.new(symbols: {marker: ">"}, active_color: :cyan)

get_user = -1 
while true 

    if !check_connection()
        puts "*******************"
        puts "* No hay conexion *"
        puts "*******************"
        break
    end

    rows = []
    rows << ['Registrarse']
    rows << ['Iniciar sesion']
    rows << ['Generar QR']
    rows << ['Historial']
    rows << ['Salir']
    table = Terminal::Table.new :title => "MENU", :headings => ['Descripcion'], :rows => rows
    table.style = {:all_separators => true, border: :unicode, :width => 40, :alignment => :center}

    puts table

    options = prompt.select("Escoja opcion: ") do |menu|
        menu.choice name: "Registrarse",  value: 1
        menu.choice name: "Iniciar sesion", value: 2
        menu.choice name: "Generar QR", value: 3
        menu.choice name: "Historial", value: 4
        menu.choice name: "Salir",  value: 5
    end

    case
    when options == 1
        username = prompt.ask("usuario:", required: true)
        password = prompt.mask("contraseña:" , required: true)
        email = prompt.ask("email:", required: true) do |q|
            q.modify :strip, :down, :remove
            q.validate(/\A\w+@\w+\.\w+\Z/, "Correo no valido")
        end
        name = prompt.ask("nombre:", required: true) 
        response = register_user(username, password, email, name)

    when options == 2
        username = options = prompt.ask("usuario:" , required: true)
        password = prompt.mask("contraseña:" , required: true)

        response = login_user(username, password)
        response = JSON.parse(response)
        
        if response.has_key?("errors")
            puts "El usuario no existe"
        elsif response.has_key?("msg") 
            puts "Usuario o contraseña incorrectos"
        else
            puts "Bienvenido #{response['usuario']['username']}"
            get_user = response['usuario']['id_usuario']
        end

    when options == 3
        if get_user == -1
            puts "\n*************************"
            puts "* No ha iniciado sesion *"
            puts "*************************\n"
            next
        end
        url = prompt.ask("url:", required: true) do |q|
            q.modify :strip, :down, :remove
        end
        if !(url =~ URI::regexp)
            puts "URL no valida"
            url = ""
        end

        response = generate_qr(url, get_user)
        response = JSON.parse(response)

        puts "**********************"
        puts response['msg']
        puts "**********************"

        qr_url = response['qr_code']['url']
        qr_base64 = response['qr_code']['url_code']
        qr_tipo = response['qr_code']['type']
        
        qr_base64 = qr_base64.split(",")[1]

        directory_name = "icon"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        # create_qr(directory_name, qr_base64)
        File.open("#{directory_name}/qr.png", "wb") do |file|
            f.write(Base64.decode64(qr_base64))
        end


    when options == 4

        if get_user == -1
            puts "\n*************************"
            puts "* No ha iniciado sesion *"
            puts "*************************\n"
            next
        end

        response = historical_qr(get_user)
        response = JSON.parse(response)

        if response.has_key?("errors")
            puts "\n*************************"
            puts "* Usuario no existe     *"
            puts "*************************\n"
            next
        end

        rows = []
        response['codes'].each do |child|
            rows << [child['id_code'], child['type'], child['url'][8..], child['url_code'][0..30]]
        end

        #if !prompt.yes?("Desea exportar un qr?")


        historico = Terminal::Table.new :title => "HISTORIAL", :headings => ['ID' ,'Tipo', 'URL' ,'Qr Code'], :rows => rows
        historico.style = {:all_separators => true, border: :unicode, :width => 130, :alignment => :center}
        puts historico 
    else
        break
    end

end    


say_bye



