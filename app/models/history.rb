class History < ActiveRecord::Base

  def self.clean
    limit = Ihate::Application.config.histories
    time = Ihate::Application.config.push_history_time
    count = Ihate::Application.config.push_history_count

    sympathies = Hate.get_hatest(limit)
    unless sympathies.blank?
      sympathies.each do |s|

        history = Hate.where("created_at < '#{time.minutes.ago}'
                              and id = #{s[:id]}").destroy_all
        if !history.blank? and s[:count] > count
          History.new(
            :hate => history[0].hate,
            :sympathy => s[:count]
          ).save
        end

      end
    end

  end

end
