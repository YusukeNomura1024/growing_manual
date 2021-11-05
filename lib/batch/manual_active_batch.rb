class Batch::ManualActiveBatch
  def self.manualactive
    puts '--- 公開予定日を過ぎたマニュアルを公開しました ---'

    @target_manuals = Manual.where.not(release_date: nil)
    @target_manuals.each do |target_manual|
      if target_manual.release_date < Time.current
        target_manual.update(status: true, release_date: nil)
      end
    end
  end
end
