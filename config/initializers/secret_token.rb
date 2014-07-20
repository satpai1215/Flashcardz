# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

#Yogaexpress::Application.config.secret_key_base = 'c286adfe32a85f00f7b1b8394ec01409313bcec4333c752a173078aa18092a69e0246f61b3072072d9bda6e465e667b88eeec31101c49e2ef007a5a70c29a8fe'


require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

Flashcards::Application.config.secret_key_base = secure_token