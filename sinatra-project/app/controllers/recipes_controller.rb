class RecipesController < ApplicationController

  # GET: /recipes
  get "/recipes" do
    @recipes = Recipe.all
    erb :"/recipes/index"
  end

  # GET: /recipes/new
  get "/recipes/new" do
    erb :"/recipes/new"
  end

  # POST: /recipes
  post "/recipes" do
    #binding.pry
    @recipe = Recipe.create(params[:recipe])
    @recipe.save
    redirect "/recipes"
  end

  # GET: /recipes/5
  get "/recipes/:slug" do
    @recipe = Recipe.find_by_slug(params[:slug])
    erb :"/recipes/show"
  end

  # GET: /recipes/5/edit
  get "/recipes/:slug/edit" do
    @recipe = Recipe.find_by_slug(params[:slug])
    erb :"/recipes/edit"
  end

  # PATCH: /recipes/5
  post "/recipes/:slug" do
    binding.pry
    @recipe = Recipe.find_by_slug(params[:slug])
    @recipe.update(name: params[:recipe][:name], cook_time: params[:recipe][:cook_time], description: params[:recipe][:description])
    redirect "/recipes/:slug"
  end

  # DELETE: /recipes/5/delete
  delete "/recipes/:slug/delete" do
    @recipe = Recipe.find_by_slug(params[:slug])
    @recipe.destroy
    redirect "/recipes"
  end
end
