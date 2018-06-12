class PlaylistController < ApplicationController
  require "net/http"
  require "date"
   # GET /users
  def index
    url = "http://..."
    resp = Net::HTTP.get_response(URI.parse("http://a98952108bd50135ea8c543d7edaf0a0.scheduler.vidibus.net/api/channels/5aa6722c1d0a7e7578e21c1d/playlist.json"))
    data = JSON.parse(resp.body)
      #filtered_schedules = EpgProgram.fetch_schedule(data)
      filtered_schedules = dataval(data)
      if filtered_schedules.empty?
        render json: { status:"success",message: "No data found" }
      else
        render json: { status:"success",data:filtered_schedules}
      end
    end

   private
    def dataval(data)
      range = ((DateTime.now-100.days).to_date..(DateTime.now + 5.days).to_date)
      schedules = data["playlist"]["schedule"]
      assets = data["playlist"]["sources"]
      filtered_schedules = schedules.select{ | s | (range).include? (DateTime.strptime(s["starts_at"], '%Y-%m-%d T%H:%M:%S%z').to_date)}
      filtered_schedules.each do |child|
        child["url"] = child["source"]? assets.select{|a|  a["id"] == child["source"]}[0]["url"] :nil
        child.delete("id")
        child.delete("assets")
        child.delete("source")
      end
    end

end
