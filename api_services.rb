require_relative 'environment.rb'

def check_connection
    base_url_api = "https://codeqr-generate2.herokuapp.com"
    response = Faraday.get base_url_api
    return response.status == 200 ? true : false
end


def register_user(username, password, email, name)
    base_url_api = "https://codeqr-generate2.herokuapp.com"
    url = base_url_api+"/api/auth/register"

    form_data = {
        "username": username,
        "password": password,
        "email": email,
        "name": name
    }.to_json

    headers = {"Content-Type": 'application/json'}

    return Faraday.post(url, form_data, headers).body
end # end registerUser

def login_user(username, password)
    base_url_api = "https://codeqr-generate2.herokuapp.com"
    url = base_url_api+"/api/auth/login"

    form_data = {
        "username": username,
        "password": password
    }.to_json

    headers = {"Content-Type": 'application/json'}

    return Faraday.post(url, form_data, headers).body

end # end loginUser 

def generate_qr(web_url, user_id)
    base_url_api = "https://codeqr-generate2.herokuapp.com"
    url = "#{base_url_api}/api/code/"

    form_data = {
        "url": web_url,
        "user": user_id
    }.to_json

    headers = {"Content-Type": 'application/json'}

    return Faraday.post(url, form_data, headers).body
end 

def historical_qr(id_user)
    base_url_api = "https://codeqr-generate2.herokuapp.com"
    url = "#{base_url_api}/api/code/historial"

    form_data = {
        "user": id_user
    }.to_json

    headers = {"Content-Type": 'application/json'}

    return Faraday.post(url, form_data, headers).body
end # end historicalQr