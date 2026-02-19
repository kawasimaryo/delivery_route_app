# frozen_string_literal: true

# MacのOpenSSL証明書パス問題の修正（ローカル開発環境のみ）
if Rails.env.development?
  require 'openssl'
  OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ca_file] = '/opt/homebrew/etc/openssl@3/cert.pem'
end
