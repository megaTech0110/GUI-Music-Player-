require 'rubygems'
require 'gosu'
require './input_functions'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Hip-hop', 'Rock', 'Jazz']

class ArtWork
	attr_accessor :bmp
	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

class Track
  attr_accessor :tra_key, :name, :location
    def initialize (tra_key, name, location)
      @tra_key = tra_key
      @name = name
      @location = location
     end
end

class Album
  attr_accessor :pri_key, :title, :artist,:artwork, :genre, :tracks
  def initialize (pri_key, title, artist,artwork, genre, tracks)
    @pri_key = pri_key
    @artist = artist
    @title = title
	@artwork = artwork
    @genre = genre
    @tracks = tracks
	
   end
end

class Song
	attr_accessor :song
	def initialize (file)
		@song = Gosu::Song.new(file)
	end
end

class MusicPlayerMain < Gosu::Window
	def initialize
	    super 1800, 1000
			self.caption = "Music Player"
			@font = Gosu::Font.new(30)
			@alb = 1
			@trk = 0
	end

	def load_album()
			def read_track (music_file, i)
				track_key = i
				track_name = music_file.gets
				track_location = music_file.gets.chomp
				track = Track.new(track_key, track_name, track_location)
				return track
			end

			def read_tracks music_file
				count = music_file.gets.to_i
				tracks = Array.new()
				index = 0
				while index < count
					track = read_track(music_file, index+1)
					tracks << track
					index +=1
				end
				tracks
			end

			def read_album(music_file, i)
				album_pri_key = i
				album_title = music_file.gets.chomp
				album_artist = music_file.gets
				album_artwork = music_file.gets.chomp
				album_genre = music_file.gets.to_i
				album_tracks = read_tracks(music_file)
				album = Album.new(album_pri_key, album_title, album_artist,album_artwork, album_genre, album_tracks)
				return album
			end

            def search_for_track_name(tracks, search_string)
                found_index = -1
                i = 0
                    while (i < tracks.length)
                            if (tracks[i].name.chomp == search_string)
                                found_index = i
                            end
                            i += 1
                        end
                    return found_index
            end

			def read_albums(music_file)
				count = music_file.gets.to_i
				albums = Array.new()
				i = 0
					while i < count
						album = read_album(music_file, i+1)
						albums << album

						i = i + 1
					end
				return albums
			end

			music_file = File.new("file.txt", "r")
			albums = read_albums(music_file)
			return albums
		end

	def needs_cursor?; true; end

#code to display album pics using arrays for first page 
		def draw_albums(albums)
			@bmp = Gosu::Image.new(albums[0].artwork)
			@bmp.draw(200, 200 , z = ZOrder::PLAYER)

			@bmp = Gosu::Image.new(albums[1].artwork)
			@bmp.draw(200, 550, z = ZOrder::PLAYER)

			@bmp = Gosu::Image.new(albums[2].artwork)
			@bmp.draw(600, 200 , z = ZOrder::PLAYER)

			@bmp = Gosu::Image.new(albums[3].artwork)
			@bmp.draw(600, 550, z = ZOrder::PLAYER)
		end 
			
	#code to display buttons 
	def draw_button()

		@bmp = Gosu::Image.new("image/back_page.png")
		@bmp.draw(50, 450, z = ZOrder::UI)

		@bmp = Gosu::Image.new("image/play.png")
		@bmp.draw(700, 850, z = ZOrder::UI)

		@bmp = Gosu::Image.new("image/pause.png")
		@bmp.draw(790, 850, z = ZOrder::UI)

		@bmp = Gosu::Image.new("image/stop.png")
		@bmp.draw(880, 850, z = ZOrder::UI)

		@bmp = Gosu::Image.new("image/next.png")
		@bmp.draw(970, 850, z = ZOrder::UI)

		@bmp = Gosu::Image.new("image/next_page.png")
		@bmp.draw(970, 450, z = ZOrder::UI)

	end

	def draw_background()
		draw_quad(0,0, TOP_COLOR, 0, 1000, TOP_COLOR, 1800, 0, BOTTOM_COLOR, 1800, 1000, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
    end


	def draw
		albums = load_album() #prints out the albums cover 
		i = 0

		#cordinates used to map the tracks and stuff 
		x = 1100
		y = 50
		draw_albums(albums)
		draw_button()
		draw_background()

		#code for printing playing album detail 
			# @alb-1 since albums start from 0 as its initailised as 1 
			if i < albums[@alb-1].tracks.length
                @font.draw("Album name: #{albums[@alb-1].artist}", x , y+=50, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLUE)
                @font.draw("Artist name: #{albums[@alb-1].title}\n\n", x , y+=50, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLUE)
            end
			#code for printing track name 
	 while i < albums[@alb-1].tracks.length
				@font.draw("Track name: #{albums[@alb-1].tracks[i].name}", x , y+=50, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
		if (albums[@alb-1].tracks[i].tra_key == @trk)
                    @font.draw("*", x-20 , y, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
		end 
		i+=1
	end
end

	#tra_key used to knwo what track number is being played
    #pri_key used to knwo what album number is being played

	def playTrack(trk, alb)
		albums = load_album()
		i = 0
		while i < albums.length
			if (albums[i].pri_key == alb)  #it says the album number is array which is 0 is acc the first album 
				tracks = albums[i].tracks
				k = 0
						while k< tracks.length
								if (tracks[k].tra_key == trk)
									@song = Gosu::Song.new(tracks[k].location)
									@song.play()
								end
								k+=1
						end
			end
			i+=1
		end
 end
	
	def area_clicked(mouse_x, mouse_y) #code to display and play track when click
		if ((mouse_x >200 && mouse_x < 400)&& (mouse_y > 200 && mouse_y < 450 ))# neil album
			@alb = 1
			@trk = 1
			playTrack(@alb,@trk)
		end
		if ((mouse_x > 200 && mouse_x < 400) && (mouse_y > 550 && mouse_y <800))# platter album
			@alb = 2
			@trk = 1
			playTrack(@trk, @alb)
		end
		if ((mouse_x > 600 && mouse_x < 750) && (mouse_y > 200 && mouse_y <450))#  american pie album
			@alb = 3
			@trk = 1
			playTrack(@trk, @alb)
		end
		if ((mouse_x > 600 && mouse_x < 750) && (mouse_y > 550 && mouse_y <800))# carly album
			@alb = 4
			@trk = 1
			playTrack(@trk, @alb)
		end

        if ((mouse_x >720 && mouse_x < 790)&& (mouse_y > 850 && mouse_y < 950 ))#play
			@song.play()
		end

        if ((mouse_x >810 && mouse_x < 890)&& (mouse_y > 850 && mouse_y < 950 ))#pause
			@song.pause
		end

		if ((mouse_x >900 && mouse_x < 990)&& (mouse_y > 850 && mouse_y < 950 ))#stop
			@song.stop
		end

		if ((mouse_x >990 && mouse_x < 1020)&& (mouse_y > 850 && mouse_y < 950 ))#next
			if (@trk == nil)
				@trk = 1
			end
			@trk += 1
			playTrack(@trk, @alb)
		end
	end 
	

def update
	
		#def area_clicked(mouse_x, mouse_y)
		x = 1100
		y = 200
			if ((mouse_x > x && mouse_x < x+100 ) && (mouse_y > y && mouse_y < y+=50))#  american pie album
				@alb = @alb
				@trk = 1
				playTrack(@trk, @alb)
			end
	
			if ((mouse_x > x && mouse_x <  x+100 ) && (mouse_y > y && mouse_y < y+=50))#  american pie album
			@alb = @alb
			@trk = 2
			playTrack(@trk, @alb)
			end
	
			if ((mouse_x > x && mouse_x <  x+100 ) && (mouse_y > y && mouse_y < y+=50))#  american pie album
				@alb = @alb # album = the album being played 
				@trk = 3 #track number 3 
				playTrack(@trk, @alb)
			end
	
		#end 

#def update
		if (@song)
			#incase if the song is not played move to next track number
			if (!@song.playing?) #no song playing then go to next track 
				@trk+=1
			end
		end

	if ((mouse_x >950 && mouse_x < 1050)&& (mouse_y > 450 && mouse_y < 500))
	
		def draw_albums(albums)
		@bmp = Gosu::Image.new(albums[4].artwork)
		@bmp.draw(200, 200 , z = ZOrder::PLAYER)

		@bmp = Gosu::Image.new(albums[5].artwork)
		@bmp.draw(200, 550, z = ZOrder::PLAYER)

		@bmp = Gosu::Image.new(albums[6].artwork)
		@bmp.draw(600, 200 , z = ZOrder::PLAYER)

		@bmp = Gosu::Image.new(albums[7].artwork)
		@bmp.draw(600, 550, z = ZOrder::PLAYER)
		end 
 
		def area_clicked(mouse_x, mouse_y)  #code to display and play track when click
		if ((mouse_x >200 && mouse_x < 500)&& (mouse_y > 200 && mouse_y < 500 ))# neil album
			@alb = 5
			@trk = 1
			playTrack(@trk, @alb)
		end
		if ((mouse_x > 200 && mouse_x < 500) && (mouse_y > 550 && mouse_y <800))# platter album
			@alb = 6
			@trk = 1
			playTrack(@trk, @alb)
		end
		if ((mouse_x > 600 && mouse_x < 900) && (mouse_y > 200 && mouse_y <500))#  american pie album
			@alb = 7
			@trk = 1
			playTrack(@trk, @alb)
		end
		if ((mouse_x > 600 && mouse_x < 900) && (mouse_y > 550 && mouse_y <800))# carly album
			@alb = 8
			@trk = 1
			playTrack(@trk, @alb)
		end

        if ((mouse_x >720 && mouse_x < 790)&& (mouse_y > 850 && mouse_y < 950 ))#play
			@song.play()
		end

        if ((mouse_x >810 && mouse_x < 890)&& (mouse_y > 850 && mouse_y < 950 ))#pause
			@song.pause
		end

		if ((mouse_x >900 && mouse_x < 990)&& (mouse_y > 850 && mouse_y < 950 ))#stop
			@song.stop
		end

		if ((mouse_x >990 && mouse_x < 1020)&& (mouse_y > 850 && mouse_y < 950 ))#next
			if (@trk == nil)
				@trk = 1
			end
			@trk += 1
			playTrack(@trk, @alb)
		end
	end 
end

#code for prev page 
if ((mouse_x >50 && mouse_x < 150)&& (mouse_y > 450 && mouse_y < 500))
	
	def draw_albums(albums)
	@bmp = Gosu::Image.new(albums[0].artwork)
	@bmp.draw(200, 200 , z = ZOrder::PLAYER)

	@bmp = Gosu::Image.new(albums[1].artwork)
	@bmp.draw(200, 550, z = ZOrder::PLAYER)

	@bmp = Gosu::Image.new(albums[2].artwork)
	@bmp.draw(600, 200 , z = ZOrder::PLAYER)

	@bmp = Gosu::Image.new(albums[3].artwork)
	@bmp.draw(600, 550, z = ZOrder::PLAYER)
	end 

	def area_clicked(mouse_x, mouse_y)  #code to display and play track when click
	if ((mouse_x >200 && mouse_x < 400)&& (mouse_y > 200 && mouse_y < 450 ))# neil album
		@alb = 1
		@trk = 1
		playTrack(@trk, @alb)
	end
	if ((mouse_x > 200 && mouse_x < 400) && (mouse_y > 550 && mouse_y <800))# platter album
		@alb = 2
		@trk = 1
		playTrack(@trk, @alb)
	end
	if ((mouse_x > 600 && mouse_x < 750) && (mouse_y > 200 && mouse_y <450))#  american pie album
		@alb = 3
		@trk = 1
		playTrack(@trk, @alb)
	end
	if ((mouse_x > 600 && mouse_x < 750) && (mouse_y > 550 && mouse_y <800))# carly album
		@alb = 4
		@trk = 1
		playTrack(@trk, @alb)
	end

	if ((mouse_x >720 && mouse_x < 790)&& (mouse_y > 850 && mouse_y < 950 ))#play
		@song.play()
	end

	if ((mouse_x >810 && mouse_x < 890)&& (mouse_y > 850 && mouse_y < 950 ))#pause
		@song.pause
	end

	if ((mouse_x >900 && mouse_x < 990)&& (mouse_y > 850 && mouse_y < 950 ))#stop
		@song.stop
	end

	if ((mouse_x >990 && mouse_x < 1020)&& (mouse_y > 850 && mouse_y < 950 ))#next
		if (@trk == nil)
			@trk = 1
		end
		@trk += 1
		playTrack(@trk, @alb)
	end
end 
end

	def button_down(id)
		case id
			when Gosu::MsLeft
				area_clicked(mouse_x, mouse_y) # runs the are clicked function coded above 
			when Gosu::KbQ
				  close
	    end
	end
end
end 

MusicPlayerMain.new.show if __FILE__ == $0
