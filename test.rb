require "sqlite3"
DB = SQLite3::Database.new("tasks.db")
DB.results_as_hash = true
require_relative "task"

# Task
# Initialize
new_task = Task.new(title: "Should work", description: "I hope so...")
p new_task.title
p new_task.description
puts "Should have false as done:"
p new_task.done?
puts "Should have no id:"
p new_task.id

# # READ
# -- find one task
task = Task.find(1)
puts "Title matches the DB:"
p task.title == "Complete Livecode"

# -- get all tasks as instances
tasks = Task.all
p tasks
puts "Returns task instances:"
p tasks.all? { |task| task.is_a?(Task) }

# CREATE
new_task = Task.new(title: "Hello world", description: "How are you?")
new_task.save
p new_task.id
new_id = new_task.id

# DESTROY
last_task = Task.find(new_id)
last_task.destroy
last_task_again = Task.find(new_id)
puts "last_task_again should be nil:"
p last_task_again

# UPDATE
first_task = Task.find(1)
first_task.done = true
first_task.save

first_task_again = Task.find(1)
puts "Done should be true:"
p first_task_again.done?
