class Hate < ActiveRecord::Base

  has_many :sympathy, :dependent => :destroy
  validates :hate, :presence => true

  def self.get_latest_hate
    recently_time = Ihate::Application.config.recently_time
    limit = Ihate::Application.config.display_count.to_i

    @latest_hate = Array.new
    latest_hate = 
      Hate.select("id, hate, created_at")
          .where("created_at > '#{recently_time.minutes.ago}'")

    unless latest_hate.blank?
      latest_hate.each do |l|
        @latest_hate << l
      end
      limit -= latest_hate.size.to_i
    end

    sympathies = get_hatest

    low_rank = Array.new
    unless sympathies.blank?
      low = sympathies[0][:count].to_i / 10
      sympathies.each do |sympathy|
        if sympathy[:count].to_i <= low
          low_rank << sympathy[:id]
        end
      end
    end

    unless low_rank.blank?
      Hate.where("created_at < '#{recently_time.minutes.ago}'
                  and (id = #{low_rank.join(" or id = ")})").destroy_all
    end

    hatest = nil
    id = Array.new
    if limit > 0
      sympathies = get_hatest(limit)
      unless sympathies.blank?
        sympathies.each do |sympathy|
          id << sympathy[:id]
        end

        hatest = Hate.where("created_at <= '#{recently_time.minutes.ago}'
                             and (id = #{id.join(" or id = ")})")
      end
    end

    unless hatest.blank?
      hatest.each do |h|
        @latest_hate << h
      end
    end

    return @latest_hate
  end

  def self.get_hatest(limit=nil, order="DESC")
    limit = Ihate::Application.config.display_count if limit.blank?
    hatest = 
      Sympathy.select("hate_id, count(hate_id) as count")
              .group(:hate_id)
              .order("count #{order}")
              .limit(limit)

    sympathies = Array.new
    hatest.each do |h|
      unless h.hate_id.blank?
        sympathies << {
          :id => h.hate_id,
          :count => h.count
        }
      end
    end

    return sympathies
  end
end
