# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class VolumeUploader < CarrierWave::Uploader::Base

  storage :file
  def store_dir
    "../var/storage/"
  end

  def filename
    model.full_path
  end

end
