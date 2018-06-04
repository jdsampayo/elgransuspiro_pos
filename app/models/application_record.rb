class ApplicationRecord < ActiveRecord::Base
  include Syncronize

  self.abstract_class = true
  self.include_root_in_json = true
end
