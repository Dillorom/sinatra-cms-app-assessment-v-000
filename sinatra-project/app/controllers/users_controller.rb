class UsersController < ApplicationController
  # GET: /users/5
  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    #binding.pry
    @user.save
    erb :"/users/show"
  end

  # GET: /users
  get "/users" do
    @users = User.all
      erb :"/users/index"
  end

  # GET: /users/new
  get "/signup" do
    if !logged_in?
      erb :"/users/create_user"
    else
      redirect '/users'
    end
  end

  # POST: /users
  post "/users" do
    #binding.pry
    if params[:user][:username] == "" || params[:user][:email] == "" || params[:user][:password] == ""
      redirect '/signup'
    else
      @user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
      session[:user_id] = @user.id
      redirect '/users'
    end
  end



  # GET: /users/5/edit
  get "/users/:slug/edit" do
    #binding.pry
    @user = User.find_by_slug(params[:slug])
    @user.save
    erb :"/users/edit"
  end

  # PATCH: /users/5
  post "/users/:slug" do
    #binding.pry
    @user = User.find_by_slug(params[:slug])
    @user.update(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
    redirect "/users/:slug"
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/users'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect "/users"
    else
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
  delete "/users/:slug/delete" do
    redirect "/users"
  end
end
