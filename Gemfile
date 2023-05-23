source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.7'
gem 'sqlite3'
gem 'devise' # LINEログイン用Gemを導入。
gem 'omniauth-line' # LINEログイン用の認証Gemを導入。
gem 'omniauth-rails_csrf_protection' # LINEログイン用の保護Gemを導入。
gem 'dotenv-rails' # LINEログイン用の環境変数設定Gemを導入。
gem 'rails-i18n' # 日本語化用Gemを導入。
gem 'faker' # サンプルユーザー生成用Gemを導入。
gem 'bootstrap-sass' # BootstrapフレームワークのCSSスタイル用Gemを導入。
gem 'will_paginate' # ページネーション用Gemを導入。
gem 'bootstrap-will_paginate' # ページネーションのBootstrapスタイル用Gemを導入。
gem 'jquery-rails' # jQuery JavaScriptライブラリ用Gemを導入。
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2' # 開発効率向上＆自動化Gemを導入（開発環境下）。
  gem 'spring' # アプリ起動時間の短縮Gemを導入（開発環境下）。
  gem 'spring-watcher-listen', '~> 2.0.0' # ファイル変更の追跡＆反映Gemを導入（開発環境下）。
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
