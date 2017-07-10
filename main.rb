require 'pry'
require 'pry-coolline'
require './app_view'
require './transaction'
require './user'

class Main
  include AppView

  attr_accessor :users, :control

  CONTROL = {
    main: 0,
    new_user: 1
  }

  def initialize
    @users = []
    @control = CONTROL[:main]
  end

  def start
    render_view
  end

  def render_view
    render
  end

  def render
    set_control(:main)
    command_view_print do
      puts "Main:"
      users.each_with_index do |user, i|
        puts "[#{i}] Show #{user.name}"
      end
      puts "[#{new_user_number}] Add User"
    end
  end

  def new_user_number
    users.count
  end

  def new_user
    set_control(:new_user)
    view_print do
      puts "Input Name"
      input_command(gets.chomp)
    end
  end

  def command(val)
    case control
    when CONTROL[:main]
      val = val.to_i rescue nil
      case val
      when new_user_number
        new_user
      else
        if (usr = users[val] rescue false)
          usr.render
        else
          puts "Invalid Command"
        end
      end
    when CONTROL[:new_user]
      # Carlo
      @users << User.new(val, self)
      render
    end
  end
end

app = Main.new
app.start
