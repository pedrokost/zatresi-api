class KlubSerializer < ActiveModel::Serializer
  cache
  attributes :id, :name, :address, :email, :latitude, :longitude, :phone, :town, :website, :slug, :facebook_url, :categories

end
