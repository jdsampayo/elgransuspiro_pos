class ApplicationRecord < ActiveRecord::Base
  include Sincronizador

  self.abstract_class = true
  self.include_root_in_json = true
end
