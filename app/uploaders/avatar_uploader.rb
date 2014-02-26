# encoding: utf-8
require 'chunky_png'

class AvatarUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(png)
  end

  def crop_image
    include ChunkyPNG::Canvas
    img = ChunkyPNG::Image.from_file(@user.avatar.url)
    if model.crop_x.present?
      x = model.crop_x.to_i
      y = model.crop_y.to_i
      w = model.crop_w.to_i
      h = model.crop_h.to_i
      img.crop!(x, y, w, h).save(@user.avatar.identifier)
    end
  end
end


