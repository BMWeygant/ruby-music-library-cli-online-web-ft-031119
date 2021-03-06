class Song
  extend Concerns::Findable
attr_accessor :name
attr_reader :artist, :genre

@@all = []

def initialize(name, artist=nil, genre=nil)
  @name = name
  self.artist = artist if artist
  self.genre = genre if genre
end

def save
@@all << self
end

def self.all
  @@all
end

def self.destroy_all
  self.all.clear
end

def self.create(name)
song = self.new(name)
song.save
song
end

def artist=(artist)
@artist = artist
artist.add_song(self)
end

def genre=(genre)
@genre = genre
genre.songs << self unless genre.songs.include?(self)
end

def self.find_by_name(name)
  all.find{|song| song.name == name}
end

def self.find_or_create_by_name(name)
  find_by_name(name) || create(name)
end

def self.new_from_filename(filename)
info = filename.split(" - ")
artist_info, song_info, genre_info = info[0], info[1], info[2].gsub(".mp3", "")
artist = Artist.find_or_create_by_name(artist_info)
genre = Genre.find_or_create_by_name(genre_info)
new(song_info, artist, genre)
end

def self.create_from_filename(filename)
song_info = Song.new_from_filename(filename)
song_info.save
song_info
end

end
