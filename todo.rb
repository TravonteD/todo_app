#!/usr/bin/ruby -w
require 'json'
# Define Classes
class Task
    def initialize(task_text, task_status)
        @task_text = task_text.chomp
        @task_status = task_status
    end

    def get_text
        return @task_text
    end

    def get_status
        return @task_status
    end

    def set_status
        if @task_status == 0
            @task_status = 1
        else
            @task_status = 0
        end
    end
    
    def to_hash
        new_hash = {:text => @task_text, :status => @task_status}
    end
end

class TaskList
    def initialize()
        @list = []
    end

    def add(task)
        @list.push(task)
    end

    def get_task(task_number)
        return @list[task_number]
    end

    def to_string
        @list.each do |x|
            puts "#{@list.index(x)} | #{x.get_status} #{x.get_text}"
        end
    end
    
    def to_hash
        new_hash = {}
        @list.each do |task|
            new_hash["#{@list.index(task)}"] = task.to_hash
        end
        return new_hash
    end
    
    def empty
        @list = []
    end
end

# Define Methods
def clear
    system 'clear'
end

def create_task
    print "enter new task: "
    task_text = gets
    task = Task.new(task_text, 0)
    @tasklist.add(task)
end

def edit_task
    print "which task would you like to edit: "
    val = gets.chomp.to_i
    begin 
        task = @tasklist.get_task(val)
        task.set_status
        view_tasks
    rescue StandardError => e
        puts e.message
        puts "not index invalid"
        val = gets
        view_tasks
    end
end

def view_tasks
    clear
    puts "tasks | 0 = incomplete 1 = complete"
    @tasklist.to_string
    @options[1].each do |x|
        print " #{@options[1].index(x)} #{x} |"
    end
    puts
    choice = gets.chomp.to_i
    case choice
    when 0
        create_task
        view_tasks
    when 1
        edit_task
    when 2
        main_screen
    else
        puts "choice invalid"
    end
end

def save_list
    @tasklist.empty
    list = @tasklist.to_hash.to_json   
    save_file = File.new("todo_save.json", "w+")
    save_file.write(list)
    save_file.close
    main_screen
end

def load_list
    save_file = File.read("todo_save.json")
    oldlist = JSON.parse(save_file)
    oldlist.each do |i, task|
       old_task = Task.new(task['text'],task['status'])
        @tasklist.add(old_task)
    end
    view_tasks
end

def main_screen
    clear
    # ask what the user would like to do
    puts "what would you like to do?"
    # show options
    @options[0].each do |x|
        puts "- #{@options[0].index(x)} #{x}"
    end
    choice = gets.chomp.to_i
    case choice
    when 0
        view_tasks
    when 1
        create_task
        view_tasks
    when 2 
        save_list
    when 3
        load_list
    when 4
        x=1
        clear
    else
        puts "choice invalid"
    end
end
# initialize options menu and empty task list
@options = [["view tasks", "create new task", "save list", "load list", "exit"],
            ["create new", "toggle status", "back"]]
@tasklist = TaskList.new()

# Starting Screen
clear
puts "Welcome to your todo list!"
print "press a key to continue..."
val = gets
main_screen
