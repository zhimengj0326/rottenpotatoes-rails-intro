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
    @all_ratings = Movie.all_ratings
    # Get current setting from params or session
    sort = params[:sort] || session[:sort]
    @checked_ratings = params[:ratings] || session[:ratings] \
      || Hash[@all_ratings.map { |r| [r, 1] }]

    if !params[:commit].nil? || params[:ratings].nil? || (params[:sort].nil? && !session[:sort].nil?)
      flash.keep
      redirect_to movies_path :sort => sort, :ratings => @checked_ratings
    end

    # define toggled column
    case sort
    when 'title'
      @title_cls = 'hilite'
    when 'release_date'
      @release_cls = 'hilite'
    end
    
    @movies = Movie.with_ratings(@checked_ratings.keys).order(sort)

    # Save current setting to session
    session[:sort] = sort
    session[:ratings] = @checked_ratings
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
