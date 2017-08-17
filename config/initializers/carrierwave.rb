require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     "AKIAJR2SPHMRDIMT3USA",                     # required
    aws_secret_access_key: "snKEa7nDGLiXDg80Bix9Fh/eE6I3mR0DK5+j/x7PV",                         # required
    region:                'ap-northeast-2',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'weathercloset'                          # required
end