class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.include_root_in_json = true
end
