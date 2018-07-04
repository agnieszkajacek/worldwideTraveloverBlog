require "shrine"
require "shrine/storage/s3"
require "shrine/storage/file_system"


s3_options = {
  region: ENV['AWS_REGION'],
  bucket: ENV['AWS_BUCKET'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_KEY_ID']
}

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
  #cache: Shrine::Storage::S3.new(prefix: "cache", upload_options: { acl: 'public-read' }, **s3_options),
  store: Shrine::Storage::S3.new(prefix: "store", upload_options: { acl: 'public-read' }, **s3_options),
}

Shrine.plugin :activerecord
