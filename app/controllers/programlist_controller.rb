class ProgramlistController < ApplicationController
  require "net/http"
  require "date"
   # GET /users
  def index
    url = "http://..."
    response = Net::HTTP.get_response(URI.parse("http://a98952108bd50135ea8c543d7edaf0a0.scheduler.vidibus.net/api/channels/5aa6722c1d0a7e7578e21c1d/playlist.json"))
    accessible_data = JSON.parse(response.body)
      #filtered_schedules = EpgProgram.fetch_schedule(data)
      data_after_filtered = get_data(accessible_data)
      if data_after_filtered.empty?
        render json: { status:"success",message: "No data found" }
      else
        render json: { status:"success",data:data_after_filtered}
      end
    end

   private
    def get_data(data_to_be_filter)
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
