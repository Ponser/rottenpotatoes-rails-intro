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
    @order = params[:sort] || session[:sort] || 'title' # Get information about which column is the sort key
    @movies = Movie.all.order(@order) # Get a list of movies sorted by the given order
    
    # Provide a 'hilite' class for the column header of 
    # whichever column we are sorting on
    @hilite = Hash.new; @hilite[@order] = 'hilite'
    
    ################################################################################
    # https://github.com/saasbook/hw-rails-intro#part-2-filter-the-list-of-movies-by-rating-15-points
    #
    @all_ratings = Movie.all_ratings
    params[:note] = nil
    new_ratings = params[:ratings] # Only when the user clicks 'Refresh'
    if new_ratings
      @checked = new_ratings.keys
      session['checked'] = @checked
      params[:note] = 'new ratings'
    else
      @checked = session['checked'] || @all_ratings
    end
    
    # subset the list of movies based on the ratings checkboxes
    @movies = @movies.select {|x| @checked.include? x.rating}

    remember_state
    
    # if the params do NOT have a key and the session DOES, or there are new ratings, then redirect
 #   if !params['sort'] && session['sort']
    if !params[:sort] && session[:sort]
      redirect_to(movies_path + @state)
      return
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
  
  def remember_state
    chex = session['checked'] || params['checked'] || @all_ratings
    sort = @order
    flash[:notice] = 'chex ' + chex.to_s + ', sort ' + sort.to_s
    divider = '?'
    @state = divider
    if sort
      @state << "sort=#{sort}&"
      divider = '&'
    end
    if chex
      chex.each {|x| @state << "ratings[#{x}]=1&"}
      divider = '&'
    end
    @state.chomp! divider
  end

end
