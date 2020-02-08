module OmniauthMacros
  def mock_auth_hash(provider, uid: '123456', email: 'test@gmail.com')
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: uid,
      info: { email: email }
    )
  end
end
