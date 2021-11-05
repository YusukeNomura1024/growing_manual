class Batch::TagDeleteBatch
  def self.tagdelete
    puts '--- 未使用のタグを削除しました ---'
    @target_tags = Tag.preload(:tag_maps).all
    @target_tags.each do |target_tag|
      if target_tag.tag_maps.size == 0
        target_tag.destroy
      end
    end
  end
end
