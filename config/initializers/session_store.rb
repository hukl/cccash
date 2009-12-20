# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cccash_session',
  :secret      => '0fd6bf6c21acef340b68a44012f95445a5fc1fbe65764e81ceb330188d13a9ceb2338200dd903149aa3b64c615a0b14cad872de9576770a9ff7b130564a28651'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
