module Geo

	def self.getDistance(team1, team2)
		Geo.getDistanceFromLatLonInKm(team1.latitude, team1.longitude, team2.latitude, team2.longitude)
	end

	def self.getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2)
		r = 6371
		dLat = Geo.deg2rad(lat2-lat1)
		dLon = Geo.deg2rad(lon2-lon1)
		a =  Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2)
		c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
		d = r * c
		return d
	end

	def self.deg2rad(deg)
		return deg * (Math::PI/180)
	end

end