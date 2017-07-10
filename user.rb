class User
  include AppView

  attr_accessor :transactions, :name, :main, :control

  CONTROL = {
    index: 0,
    transactions: 1,
    new_transaction: 2,
    edit: 3
  }

  def initialize(name, main)
    @name = name
    @main = main
    @transactions = []
    set_control(:index)
  end

  def edit_user
    set_control(:edit)
    command_view_print do
      puts "Input New Name for #{name}"
    end
  end

  def show_transactions
    set_control(:transactions)
    command_view_print do
      puts "Transactions of #{name}:"
      puts "Number Description Income/Expense Amount"
      transactions.each_with_index do |t, i|
        puts "[#{i}] #{t.description} #{t.type} $#{t.amount}"
      end
      puts "[#{new_transaction_number}] Add Transaction"
      puts "[#{transaction_back_number}] Back to User #{name}"
    end
  end

  def new_transaction
    set_control(:new_transaction)
    view_print do
      puts "Input Transaction Description"
      desc = gets.chomp
      puts "Input Transaction Type(Income/Expense)"
      type = gets.chomp
      puts "Input Amount"
      amount = gets.chomp
      input_command({desc: desc, type: type, amount: amount})
    end
  end

  def new_transaction_number
    transactions.count
  end

  def transaction_back_number
    new_transaction_number + 1
  end

  def command(val)
    case control
    when CONTROL[:index]
      case val.to_i
      when 0
        show_transactions
      when 1
        set_control(:edit)
        edit_user
      when 2
        main.users = main.users - [self]
        main.render
      when 3
        main.render
      else
        'Invalid Command'
      end
    when CONTROL[:transactions]
      val = val.to_i rescue nil
      case val
      when new_transaction_number
        new_transaction
      when transaction_back_number
        render
      else
        if (tr = transactions[val] rescue false)
          tr.render
        else
          puts "Invalid Command"
        end
      end
    when CONTROL[:edit]
      # Boggs
      self.name = val
      render
    when CONTROL[:new_transaction]
      #Transaction.new({desc: desc, type: type, amount: amount})
      transactions << Transaction.new(val, self)
      show_transactions
    else
      puts "Invalid Command"
    end
  end

  def render
    set_control(:index)
    command_view_print do
      puts "User #{name}:"
      puts "[0] Show Transactions"
      puts "[1] Edit User"
      puts "[2] Delete User"
      puts "[3] Back to Main"
    end
  end
end
