module Encryption
 
  # Added a re-usable encryption routine, shouldn't be an issue!
  def self.encrypt_sensitive_value(val="", auth_token=false)
     aes = OpenSSL::Cipher::Cipher.new(cipher_type)
     aes.encrypt
     aes.key = key
     aes.iv = iv(auth_token) if iv(auth_token) != nil
     new_val = aes.update("#{val}") + aes.final
     Base64.strict_encode64(new_val).encode('utf-8')
  end
  
  def self.decrypt_sensitive_value(val="", auth_token=false)
     aes = OpenSSL::Cipher::Cipher.new(cipher_type)
     aes.decrypt
     aes.key = key
     aes.iv = iv(auth_token) if iv(auth_token) != nil
     decoded = Base64.strict_decode64("#{val}")
     aes.update("#{decoded}") + aes.final
  end
  
  # Should be able to just re-use the same key we already have!
  def self.key
    raise "Key Missing" if !(KEY)
    KEY
  end
  
  def self.iv(auth_token)
    auth_token ? RGV_IV : RG_IV
  end
  
  def self.cipher_type
    'aes-256-cbc'
  end
 
end