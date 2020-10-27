class Task
  ALL_QUERY     = "SELECT * FROM tasks"
  FIND_QUERY    = "SELECT * FROM tasks WHERE id = ?"
  DESTROY_QUERY = "DELETE FROM tasks WHERE id = ?"
  UPDATE_QUERY  = "UPDATE tasks SET title = ?, description = ?, done = ? WHERE id = ?"
  CREATE_QUERY  = "INSERT INTO tasks (title, description, done) VALUES (?, ?, ?)"

  attr_reader :id, :title, :description
  attr_writer :done

  def initialize(attrs = {})
    @id          = attrs[:id]
    @title       = attrs[:title]
    @description = attrs[:description]
    @done        = attrs[:done] == 1 # => 0 1 since SQLite has no booleans
  end

  def self.find(id)
    results = DB.execute(FIND_QUERY, id) # => [{}, {}] OR [] if none is found
    task_attributes = results.first # => {} OR nil since first of empty array is nil
    return nil if task_attributes.nil?

    build_task(task_attributes)
  end

  def self.all
    results = DB.execute(ALL_QUERY)
    results.map { |task_attributes| build_task(task_attributes) }
  end

  def persisted?
    !@id.nil?
  end

  def save
    persisted? ? update : create
  end

  def destroy
    DB.execute(DESTROY_QUERY, id)
  end

  def done?
    @done
  end

  def self.build_task(attributes)
    symbolized_attributes = attributes.transform_keys(&:to_sym)
    new(symbolized_attributes)
  end

  private

  def create
    DB.execute(CREATE_QUERY, title, description, done? ? 1 : 0)
    @id = DB.last_insert_row_id
  end

  def update
    DB.execute(UPDATE_QUERY, title, description, done? ? 1 : 0, id)
  end
end
