class UsersController < ApplicationController
  enable :sessions
  use Rack::Flash

  # GET: /users
  get "/users" do
    @users = User.all
      erb :"/users/index"
  end

  # get '/myrecipes' do
  #   @user = User.find_by_slug(params[:slug])
  #   if logged_in?
  #     erb :'/users/myrecipe'
  #   else
  #     redirect '/login'
  #   end
  # end

  # GET: /users/new
  get "/signup" do
    if !logged_in?
      erb :"/users/create_user"
    else
      redirect '/users'
    end
  end

  # GET: /users/5
  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    #binding.pry
    erb :"/users/show"
  end

  # POST: /users
  post "/users" do
    #binding.pry
    if params[:user][:username] == "" || params[:user][:email] == "" || params[:user][:password] == ""
      redirect '/signup'
    else
      @user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
      session[:user_id] = @user.id
      flash[:message] = "You have successfully signed up."
      redirect '/users'
    end
  end



  # GET: /users/5/edit
  get "/users/:slug/edit" do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      if @user == current_user
      erb :"/users/edit"
      else
        flash[:message] = "You do not have permission to edit other users' profile."
      redirect '/users'
      end
    else
      redirect '/login'
    end
  end

  # PATCH: /users/5
  patch "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    @user.update(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
    flash[:message] = "You have seccussfully edited your profile."
    redirect "/users/#{@user.slug}"
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/users'
    end
  end

  post '/login' do
    #binding.pry
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect "/users"
    else
      #flash[:message] = "Please enter correct username and password, or sign up."
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect '/login'
    else
      redirect '/'
    end
  end
  # DELETE: /users/5/delete
  get "/users/:slug/delete" do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      if  @user == current_user
        @user.destroy
        #flash[:message] = "You have successfully deleted your account."
        redirect "/"
      else
        flash[:message] = "You do not have permission to delete another user's account."
        redirect '/users'
      end
    else
      #flash[:message] = "You need to be logged in to delete your account."
      redirect '/login'
    end
  end
end
