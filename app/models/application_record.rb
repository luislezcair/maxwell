# frozen_string_literal: true

# Clase padre de los modelos para Rails 5.
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
