class UpdatePublicStatusForPhotos < ActiveRecord::Migration[5.2]
  def change
    Photo.all.each do |c|
      c.update(public: true)
    end
  end
end
