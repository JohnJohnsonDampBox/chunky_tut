class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_image
  require 'oily_png'

  def crop_image
    #include ChunkyPNG::Canvas
    img = ChunkyPNG::Image.from_file(self.avatar.current_path)
    if self.crop_x.present?
      x = self.crop_x.to_i
      y = self.crop_y.to_i
      w = self.crop_w.to_i
      h = self.crop_h.to_i
      img.crop!(x, y, w, h).save(self.avatar.current_path)
      greyscale if self.grayscale
    end
  end

  def greyscale
    img = ChunkyPNG::Image.from_file(self.avatar.current_path)
    img.grayscale!.save(self.avatar.current_path)
  end
end
