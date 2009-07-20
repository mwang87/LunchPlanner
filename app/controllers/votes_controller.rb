class VotesController < ApplicationController
before_filter :login_required
  # GET /votes
  # GET /votes.xml
  def index
    @votes = current_user.votes
    @current_user = current_user
    @restaurant_id = params[:restaurant_id]

    
    if(not @restaurant_id.nil?)
        @votes = Restaurant.find(@restaurant_id).votes
    end

    @votes = Vote.deleteOldVotes(@votes)


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.xml
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.xml
  def new
    @vote = Vote.new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.xml
  def create
    @existingVotes = current_user.votes

    @existingVotes.each do |existingVote|
        isToday = Vote.isToday(existingVote)
        if(isToday)
           existingVote.destroy
        end
    end

    @vote = Vote.new(params[:vote])
    @restaurant = Restaurant.find(params[:restaurant_id])
    @vote.restaurant = @restaurant
    @vote.user_id = current_user.id
    
    respond_to do |format|
      if @vote.save
        flash[:notice] = 'Vote was successfully created.'
        format.html { redirect_to("/") }
        format.xml  { render :xml => @vote, :status => :created, :location => @vote }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.xml
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        flash[:notice] = 'Vote was successfully updated.'
        format.html { redirect_to(@vote) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.xml
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to(votes_url) }
      format.xml  { head :ok }
    end
  end
end
