class RecipesController < ApplicationController
  enable :sessions
  use Rack::Flash

  get "/recipes/new" do
    if logged_in?
      erb :"/recipes/new"
    else
      redirect '/login'
    end
  end
get '/users/:slug/recipes' do
  #binding.pry
  @user = User.find_by_slug(params[:slug])
  erb :'/users/myrecipes'

end
  # GET: /recipes
  get "/recipes" do
    @recipes = Recipe.all
    # @recipe = Recipe.find_by_slug(params[:recipe][:name])
    # @user = @recipe.user
    erb :"/recipes/index"
  end

  # GET: /recipes/new


  # POST: /recipes
  post "/recipes" do
    if logged_in?
      if params[:recipe][:name] == "" || params[:recipe][:cook_time] == "" ||params[:recipe][:description] == ""
        redirect '/recipes/new'
      elsif
        @recipe
        redirect '/recipes/new'
      else

        @recipe = current_user.recipes.build(name: params[:recipe][:name], cook_time: params[:recipe][:cook_time], description: params[:description])
          if @recipe.save
            flash[:message] = "You have successfully added a recipe."
          redirect "/recipes/#{@recipe.slug}"
        else
          redirect '/recipes/new'
        end
      end
    else
    redirect "/login"
  end
end

  # GET: /recipes/5
  get "/recipes/:slug" do
    @recipe = Recipe.find_by_slug(params[:slug])
    #binding.pry
    @user = @recipe.user
    erb :"/recipes/show"
  end

  # GET: /recipes/5/edit
  get "/recipes/:slug/edit" do
    if logged_in?
      @recipe = Recipe.find_by_slug(params[:slug])
      if @recipe && @recipe.user == current_user
        erb :"/recipes/edit"
      else
        redirect '/recipes'
      end
    else
      redirect '/login'
    end
  end

  # PATCH: /recipes/5
  patch "/recipes/:slug" do
    if logged_in?
      if params[:recipe][:name] == "" || params[:recipe][:cook_time] == "" ||params[:recipe][:description] == ""
        redirect "/recipes/#{params[:slug]}/edit"
      else
        @recipe = Recipe.find_by_slug(params[:slug])
        if @recipe && @recipe.user == current_user
          if @recipe.update(name: params[:recipe][:name], cook_time: params[:recipe][:cook_time], description: params[:recipe][:description])
            flash[:message] = "You have successfully edited your recipe."
            redirect "/recipes/#{@recipe.slug}"
          else
            redirect "/recipes/#{@recipe.slug}/edit"
          end
        else
          redirect '/recipes'
        end
      end
    else
      flash[:message] = "That recipe name already exists, choose a different name."
      redirect "/login"
    end
  end

  # DELETE: /recipes/5/delete
  get "/recipes/:slug/delete" do
    if logged_in?
      @recipe = Recipe.find_by_slug(params[:slug])
      if @recipe && @recipe.user == current_user
        @recipe.destroy
        flash[:message] = "You have successfully deleted your recipe."
      end
    redirect "/recipes"
    else
      flash[:message] = "You cannot delete other user's recipe."
      redirect '/login'
    end
  end
end
