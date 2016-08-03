class Auth
  # This checks if the passed in password exists in the env variable
  # SQUIRREL_PASSWORD_HASH. That var should be filled by using
  # BCrypt::Password.create("my password")
  def self.check passed_in
    if ENV["SQUIRREL_PASSWORD_HASH"].nil?
      raise "SQUIRREL_PASSWORD_HASH is not set in the env!"
    end

    password = BCrypt::Password.new(ENV["SQUIRREL_PASSWORD_HASH"])
    return password == passed_in
  end
end
