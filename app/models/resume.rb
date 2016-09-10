class Resume < ApplicationRecord
  validates :file_name, :cards, :questions, :answers, :content, presence: true
end
