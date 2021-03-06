class StaticPagesController < ApplicationController
  def index
    if params[:id]
      #get photos for specific user
      begin
        @urls = get_public_photos(params[:id])
        @user = get_user(params[:id])
      rescue
        flash[:notice] = "User not found"
        redirect_to root_path
      end
    else
      #get recent public photos and their respective user_ids
      @urls_and_users = get_public_photos_with_user(4)
    end
  end

  private

  def get_flickr
    Flickr.cache = '/tmp/flickr-api.yml'
    Flickr.new(ENV['flickr_api_key'], ENV['flickr_api_secret'])
  end

  def get_public_photos(id)
    flickr = get_flickr
    photos = flickr.people.getPublicPhotos( :user_id => id )
    photos.map{ |photo| Flickr.url_n(photo) }
  end

  def get_user(id)
    flickr = get_flickr
    flickr.people.getInfo( :user_id => id ) 
  end

  def get_public_photos_with_user(count)
    flickr = get_flickr
    photos = flickr.photos.getRecent(:per_page => count)
    user_ids = photos.map{ |photo| photo.owner }
    photos = photos.map{ |photo| Flickr.url_m(photo) }
    photos.zip(user_ids).to_h
  end
end
