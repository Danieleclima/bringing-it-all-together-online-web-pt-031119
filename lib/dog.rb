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
      SELECT * FROM pokemon
      WHERE id = ?
      SQL
    result = db.execute(sql,id)[0]
    Pokemon.new(id: result[0], name: result[1], type: result[2], db: db)
  end
end