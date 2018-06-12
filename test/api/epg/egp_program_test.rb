require 'test/unit'

class playlist_controller < Test::Unit::TestCase
  def setup
    @sample_data  = {
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

  def test_epg_import
    result = playlist_controller.fetch_schedule(@sample_data)
    assert_equal result, @expected_result
  end
end
