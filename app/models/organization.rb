class Organization < ActiveRecord::Base
  resourcify # Allows user roles to be scoped per Organization (using gem rolify)

  has_many :api_keys, dependent: :destroy, autosave: true

  has_many :repositories do
    def search_indices
      map(&:search_index)
    end
  end

  has_many :roles, as: :resource

  def create_api_key(role_name: :admin)
    api_key = api_keys.build
    api_key.generate_key
    api_key.roles = [Role.where(name: role_name).first_or_initialize]
    api_key
  end

  def search(options={})
    @search ||= Search::DocumentSearch.new(*repositories.map(&:search_index))
    @search.search(options)
  end
end
