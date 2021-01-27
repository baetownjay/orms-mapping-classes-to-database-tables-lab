class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn] 
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    #this is just here on ruby
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
    #creates a new db table for the first time
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    #deletes db table if needed
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    #puts ruby init into db table as a row
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    #this is setting ruby id value to that of which was assigned in sql
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    #creates ruby instance and db row in 1
    student = Student.new(name, grade)
    student.save
    student
  end

end
