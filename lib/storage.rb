class Storage
  def connection
    Fog::Storage.new({
      provider: "Google",
      google_project: "icco-natwelch",
      google_client_email: "squirrel-supply@icco-natwelch.iam.gserviceaccount.com",
      google_json_key_string: ENV["GOOGLE_JSON_STRING"],
    })
  end

  def bucket
    connection.directories.get(bucket_name)
  end

  def files
    bucket.files
  end

  def bucket_name
    "icco-music"
  end

  def upload file_name, blob
    connection.put_object(bucket_name, file_name, blob)
  end
end
