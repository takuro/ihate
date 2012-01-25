class HateController < ApplicationController

  def index
    @hates = Hate.get_latest_hate
    History.clean
    @history = History.all
  end

  def sympathies
    @sympathies = Hate.get_hatest

    respond_to do |format|
      format.json { render :json => @sympathies }
    end
  end

  def send_data
    hate = params[:hate]

    if hate.blank? or hate.size > 30
      redirect_to "/"
      return
    end

    @hate = Hate.new(
      :hate => hate,
      :twitter_id => nil
    )
    @hate.save

    @sympathy = Sympathy.new(
      :hate_id => @hate.id,
    )
    @sympathy.save

    redirect_to "/"
  end

  def me_too
    id = params[:id]
    id = id.sub("me_too_", "").to_i
    sympathy = Sympathy.new(:hate_id => id)
    sympathy.save
    render :text => "OK"
  end

end
