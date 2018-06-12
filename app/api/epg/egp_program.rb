class EpgProgram
  def self.fetch_schedule(data,start_date,end_date)
    srange = ((DateTime.now-100.days).to_date..(DateTime.now + 5.days).to_date)
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
