class RecipesController < ApplicationController

  get "/recipes/new" do
    if logged_in?
      erb :"/recipes/new"
    else
      redirect '/login'
    end
  end

  get '/users/:slug/recipes' do
  @user = User.find_by_slug(params[:slug])
  erb :'/users/myrecipes'
  end

  get "/recipes" do
    @recipes = Recipe.all
    erb :"/recipes/index"
  end

  post "/recipes" do
    if logged_in?
      if params[:recipe][:name] == "" || params[:recipe][:cook_time] == "" ||params[:recipe][:description] == ""
        flash[:message] = "Please, fill in all the boxes."
        redirect '/recipes/new'
      elsif
        @recipe
        redirect '/recipes/new'
      else
        @recipe = current_user.recipes.build(name: params[:recipe][:name], cook_time: params[:recipe][:cook_time], description: params[:recipe][:description])
#binding.pry
          if @recipe.save
            flash[:message] = "You have successfully added a recipe."
            redirect "/recipes/#{@recipe.slug}"
          else
            flash[:message] = "Recipe name already exists. Please, choose a different name."
            redirect '/recipes/new'
          end
        end
      else
        redirect "/login"
      end
  end

  get "/recipes/:slug" do
    @recipe = Recipe.find_by_slug(params[:slug])
    @user = @recipe.user
    erb :"/recipes/show"
  end

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
