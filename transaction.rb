class Transaction
  include AppView
  attr_accessor :description, :type, :amount, :user, :control

  CONTROL = {
    main: 0,
    edit: 1
  }

  def initialize(attributes = {}, user)
    @description = attributes[:desc]
    @type = attributes[:type]
    @amount = attributes[:amount]
    @user = user
    set_control(:main)
  end

  def render
    set_control(:main)
    command_view_print do
      puts "#{user.name}'s Transaction #{description} ($#{amount})"
      puts "[0] Edit Amount"
      puts "[1] Delete Transaction"
      puts "[2] Back to Transaction List"
    end
  end

  def edit_transaction
    set_control(:edit)
    view_print do
      puts "Input new Amount for transaction #{description}"
      input_command(gets.chomp)
    end
  end

  def command(val)
    case control
    when CONTROL[:main]
      val = val.to_i rescue nil
      case val
      when 0
        edit_transaction
      when 1
        user.transactions = user.transactions - [self]
        user.render
      when 2
        user.render
      else
        puts "Invalid Command"
      end
    when CONTROL[:edit]
      @amount = val
      render
    end
  end
end