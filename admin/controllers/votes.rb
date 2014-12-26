Wovote::Admin.controllers :votes do
  get :index do
    @title = "Votes"
    @votes = Vote.all
    render 'votes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'vote')
    @vote = Vote.new
    render 'votes/new'
  end

  post :create do
    @vote = Vote.new(params[:vote])
    if @vote.save
      @title = pat(:create_title, :model => "vote #{@vote.id}")
      flash[:success] = pat(:create_success, :model => 'Vote')
      params[:save_and_continue] ? redirect(url(:votes, :index)) : redirect(url(:votes, :edit, :id => @vote.id))
    else
      @title = pat(:create_title, :model => 'vote')
      flash.now[:error] = pat(:create_error, :model => 'vote')
      render 'votes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "vote #{params[:id]}")
    @vote = Vote.find(params[:id])
    if @vote
      render 'votes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'vote', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "vote #{params[:id]}")
    @vote = Vote.find(params[:id])
    if @vote
      if @vote.update_attributes(params[:vote])
        flash[:success] = pat(:update_success, :model => 'Vote', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:votes, :index)) :
          redirect(url(:votes, :edit, :id => @vote.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'vote')
        render 'votes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'vote', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Votes"
    vote = Vote.find(params[:id])
    if vote
      if vote.destroy
        flash[:success] = pat(:delete_success, :model => 'Vote', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'vote')
      end
      redirect url(:votes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'vote', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Votes"
    unless params[:vote_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'vote')
      redirect(url(:votes, :index))
    end
    ids = params[:vote_ids].split(',').map(&:strip)
    votes = Vote.find(ids)
    
    if votes.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Votes', :ids => "#{ids.to_sentence}")
    end
    redirect url(:votes, :index)
  end
end
