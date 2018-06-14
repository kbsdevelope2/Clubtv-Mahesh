require 'test/unit'
require "date"

class PlaylistControllerTest < Test::Unit::TestCase
  def setup
    @data  = {
      playlist: {
       schedule: [
         {
           id: "5b1151b31d0a7e3c47977be3",
           title: "KSW 43: Das komplette Event",
           starts_at: "2018-06-11T02:51:14Z",
           ends_at: "2018-06-11T07:45:28Z",
           asset: "f09ea5c0327901364a40543d7edaf0a0",
           source: "5b06d7791d0a7e4273aa1aeb"
         },
       ],
       sources: [
         {
           id: "5b06d7791d0a7e4273aa1aeb",
           url: "http://origin.vidibus.net/videos/5aec71f2d902083e77000030.smil",
           available: true
         },
       ]
      }
    }
    @expected_result = [
      {
        title: "KSW 43: Das komplette Event",
        starts_at: "2018-06-11T02:51:14Z",
        ends_at: "2018-06-11T07:45:28Z",
        url: "http://origin.vidibus.net/videos/5aec71f2d902083e77000030.smil",
      }
    ]
  end

  def epg_test
    res = get_data(@data)
    assert_equal res, @expected_output
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
