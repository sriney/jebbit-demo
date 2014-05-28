class SiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :author, :created_at, :img_url, :landing_url
end
