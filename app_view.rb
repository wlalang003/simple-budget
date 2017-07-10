module AppView
  def clscr
    system('clear')
  end

  def set_control(key)
    @control = self.class::CONTROL[key]
  end

  def input_command(val)
    self.command(val)
  end

  def command_view_print(&block)
    view_print(&block)
    puts "Input Command: (type 'exit' to close the app)"
    if !(val = gets.chomp).nil?
      if val == "exit"
        Process.kill 9, Process.pid
      elsif (val.to_i rescue false)
        input_command(val)
      end
    end
  end

  def view_print(&block)
    clscr
    yield
  end
end
