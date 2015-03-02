require "time"
require "faraday"
require "json"
require "simple-graphite"

class Chartbeat
  API_KEY = ENV["APIKEY"]

  def self.data(query, version, options)
    Faraday.get("http://api.chartbeat.com" + "/" + query.to_s + "/#{version}/" + API_KEY + options)
  rescue Faraday::Error::ConnectionFailed => e
    puts "Error #{e}"
  end

  def self.top_pages(host)
    data = JSON.parse data("live/toppages/", "v3", "&host=#{host}&section=news&limit=30").body
    array = data["pages"]
    array.map { |k, _v| Hash["path", k["path"], "title", k["title"], "total", k["stats"]["people"]] }
  end

  def self.geo_location(host)
    data = JSON.parse data("live/top_geo/", "v1", "&host=#{host}&section=news").body
    data.map { |_k, v| v["countries"] }
  end

  def self.traffic(host)
    data = JSON.parse data("live/quickstats", "v4", "&all_platforms=1&section=news&host=#{host}").body
    data["data"]["stats"]["people"]
  end
end

class SendData
  def graphite
    g = Graphite.new
    g.host = ENV["INFLUX"]
    g.port = 2003
    g
  end

  def send_top(stat, host)
    stat.each do |metrics|
      graphite.push_to_graphite do |g|
        g.puts "chartbeat.top_pages.#{host}.pages.#{metrics['title'].gsub(/\s+/, '_')} #{metrics['total']} #{graphite.time}"
      end
    end
  end

  def send_geo(stat, host)
    stat.each do |metrics|
      metrics.each do |country, count|
        graphite.push_to_graphite do |g|
          g.puts "chartbeat.top_countries.#{host}.#{country} #{count} #{graphite.time}"
        end
      end
    end
  end

  def send_traffic(stat, host)
    graphite.push_to_graphite do |g|
      g.puts "chartbeat.concurrents.#{host} #{stat} #{graphite.time}"
    end
  end
end

class FetchData
  loop do
    begin
      SendData.new.send_geo(Chartbeat.geo_location("bbc.co.uk"), "desktop")
      SendData.new.send_top(Chartbeat.top_pages("bbc.co.uk"), "desktop")
      SendData.new.send_traffic(Chartbeat.traffic("bbc.co.uk"), "desktop")
      SendData.new.send_geo(Chartbeat.geo_location("m.bbc.co.uk"), "mobile")
      SendData.new.send_top(Chartbeat.top_pages("m.bbc.co.uk"), "mobile")
      SendData.new.send_traffic(Chartbeat.traffic("m.bbc.co.uk"), "mobile")
    rescue => e
      puts e
    end
    sleep 5
  end
end

FetchData.new
