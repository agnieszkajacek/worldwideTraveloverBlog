# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( jssocials.css )
Rails.application.config.assets.precompile += %w( jssocials-theme-plain.css )
Rails.application.config.assets.precompile += %w( jssocials.min.js )
Rails.application.config.assets.precompile += %w( tui-editor.css )
Rails.application.config.assets.precompile += %w( tui-editor-contents.css )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
