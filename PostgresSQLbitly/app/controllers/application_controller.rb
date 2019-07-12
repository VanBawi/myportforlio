class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  configure do
  	set :views, "app/views"
    set :public_dir, "public"
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end

  # Renders the home or index page
  get '/' do
      erb :home
  end

  # Renders the sign up/registration page in app/views/registrations/signup.erb
  post '/registrations/signup' do
       erb :'/registrations/shortner'
  end

  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  # Handles the POST request when user submits the Sign Up form. Get user info from the params hash, creates a new user, signs them in, redirects them. 
  post '/registrations' do
      user = User.create(name: params["name"], email: params["email"])
      user.password = params["password"]
      user.save
      session[:user_id] = user.id
      redirect '/registrations/shortner'
  end
  
  # Renders the view page in app/views/sessions/login.erb
  get '/sessions/login' do
      erb :'/sessions/login'
  end

  get '/registrations/shortner' do
    erb :'/sessions/login'
  end
  # Handles the POST request when user submites the Log In form. Similar to above, but without the new user creation.
  post '/sessions' do
      user = User.find_by(email: params["email"])
      if user.password == params["password"]
        session[:user_id] = user.id
        redirect '/registrations/shortner'
      else
        redirect '/sessions/login'
      end
  end

  # Logs the user out by clearing the sessions hash. 
  get '/sessions/logout' do
      session.clear
      redirect '/'
  end

  # shortner web address sessions
    post '/Get_Short' do
         @base = "0123456789ABCDEFGHIGKLMNOPQRSTUVWXYZacbdefghigklmnopqrstuvwxyz"
         @base1 = @base.split("")
         @base58 = @base1.sample(5).join()
         @url = Url.create(original_url: params["original_url"])
         @url = @base58
         erb :show
    end

    # get '/show' do
    #   @url = Url.all
    #   erb :'/show'
    # end

end
