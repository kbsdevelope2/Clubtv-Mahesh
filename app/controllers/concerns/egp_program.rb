require 'active_support/concern'
require "date"
module EpgProgram
extend ActiveSupport::Concern

 def self.get_data(data_to_be_filter)
    datarange = ((DateTime.now-100.days).to_date..(DateTime.now + 5.days).to_date)
    schedules = data_to_be_filter["playlist"]["schedule"]
    assets = data_to_be_filter["playlist"]["sources"]
    filtered_schedules = schedules.select{ | s | (datarange).include? (DateTime.strptime(s["starts_at"], '%Y-%m-%d T%H:%M:%S%z').to_date)}
    filtered_schedules.each do |schedule|
      schedule["url"] = schedule["source"]? assets.select{|a|  a["id"] == schedule["source"]}[0]["url"] :nil
      schedule.delete("id")
      schedule.delete("asset")
      schedule.delete("source")
    end
  end
end