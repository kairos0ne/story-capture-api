class AuthSerializer < ActiveModel::Serializer
  attributes :id, :client_id, :client_secret, :redirect_uri
end
