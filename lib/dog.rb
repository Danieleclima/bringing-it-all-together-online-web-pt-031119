require "pry"

class Dog 
  attr_accessor :name, :breed
  attr_reader :id 
  
  def initialize (id: nil, name:, breed:)
    @name = name
    @breed = breed
    @id = id
  end
  
  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql =  <<-SQL
      DROP TABLE  dogs 
        SQL
        
    DB[:conn].execute(sql)
  end
  
  def save
        sql =  <<-SQL
      INSERT INTO dogs (name, breed) 
      VALUES (?, ?)
        SQL
        
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
  end
  
  def self.create(attributes)
    dog = self.new(attributes)
    dog.save
    dog
  end
  
  def self.find_by_id (id)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE id = ?
      SQL
    result = DB[:conn].execute(sql,id)[0]
    Dog.new(id: result[0], name: result[1], breed: result[2])
  end
  
  def self.find_or_create_by
    song = DB[:conn].execute("SELECT * FROM songs WHERE name = ? AND album = ?", name, album)
    if !song.empty?
      song_data = song[0]
      song = Song.new(song_data[0], song_data[1], song_data[2])
    else
      song = self.create(name: name, album: album)
    end
    song
  end
  
end