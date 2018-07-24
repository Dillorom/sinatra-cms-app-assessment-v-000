class UsersController < ApplicationController
  get "/users" do
    if logged_in?
      @users = User.all
      erb :"/users/index"
    else
      flash[:message] = "You need to login to view users."
      redirect '/'
    end
  end

  get "/signup" do
    if !logged_in?
      erb :"/users/create_user"
    else
      redirect '/users'
    end
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    erb :"/users/show"
  end

  post "/users" do
    if params[:user][:username] == "" || params[:user][:email] == "" || params[:user][:password] == ""
      flash[:message] = "Please, fill in all the boxes."
      redirect '/signup'
    else
      @user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
      session[:user_id] = @user.id
      flash[:message] = "You have successfully signed up."
      redirect '/users'
    end
  end

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
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
    else
      flash[:message] = "Please enter correct username and password, or sign up."
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

  get "/users/:slug/delete" do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      if  @user == current_user
        @user.destroy
        session.clear
        flash[:message] = "You have successfully deleted your account."
        redirect "/"
      else
        flash[:message] = "You do not have permission to delete another user's account."
        redirect '/users'
      end
    else
      flash[:message] = "You need to be logged in to delete your account."
      redirect '/login'
    end
  end
end
