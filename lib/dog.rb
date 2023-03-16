class Dog
  attr_accessor :name, :breed, :id

  def initialize(attr_hash)
    @id = attr_hash[:id]
    @name = attr_hash[:name]
    @breed = attr_hash[:breed]
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT, 
        breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed) VALUES   (?, ?)
    SQL
    DB[:conn].execute(sql, @name, @breed)
    @id = DB[:conn].execute("SELECT * FROM dogs").last[0]
    self
  end

  def self.create(attr_hash)
    Dog.new(attr_hash).save
  end

  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed: row[2])
  end

  def self.all
    DB[:conn].execute("select * FROM dogs").collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    row =  DB[:conn].execute("SELECT * FROM dogs WHERE (name = ?)", name)[0]
    Dog.new_from_db(row)
  end 

  def self.find(id)
    row =  DB[:conn].execute("SELECT * FROM dogs WHERE (id = ?)", id)[0]
    Dog.new_from_db(row)
  end 


end