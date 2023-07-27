# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# ページネーションラベルの設定
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '←'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '→'
