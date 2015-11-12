class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    ################################################################################
    # https://github.com/saasbook/hw-rails-intro#part-1-sort-the-list-of-movies-15-points
    #
    order = params[:sort] || session[:sort] || 'title' # Get information about which column is the sort key
    @movies = Movie.all.order(order) # Get a list of movies sorted by the given order
    
    # Provide a 'hilite' class for the column header of 
    # whichever column we are sorting on
    @hilite = Hash.new; @hilite[order] = 'hilite'
    
    ################################################################################
    # https://github.com/saasbook/hw-rails-intro#part-2-filter-the-list-of-movies-by-rating-15-points
    #
    @all_ratings = Movie.all_ratings
    @checked ||= params[:ratings] || @all_ratings
    if params[:ratings]
      params[:note] = 'At least one rating was checked'
      #@movies = Movie.all.order(order).select {|x| @checked.include? x.rating}
      @movies = @movies.select {|x| @checked.include? x.rating}
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
