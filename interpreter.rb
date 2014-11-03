class Brainfuck

  def initialize
    # Initial tape of 0's
    @array = []
    100.times { @array << 0 }
    @pos = 0 # Current position of the array

    # Read input:
    input = gets.chop
    @input_array = input.split("")
    @pointer_input = 0

    # Setup output:
    @output = ""

    # Helper structures:
    @hash_brackets = {} # Stores a pair <key, value> = <Open bracket position, Close bracket position>
    @flag_read_next = false

    pre_processing_brackets

    while(@pointer_input < @input_array.size)
      translate
      @pointer_input += 1
    end

    p @output
  end

  # Check balance of brackets, both overall balance and "[]]" errors,
  # while storing the positions of a corresponding open-close bracket pair
  def pre_processing_brackets
    raise "Number of brackets unbalanced" if @input_array.count("[") != @input_array.count("]")

    array_open_brackets = []
    @input_array.each_with_index do |c, i|
      case c
      when "["
        array_open_brackets.push i
      when "]"
        raise "Closing a unopened bracket" if array_open_brackets.size == 0
        @hash_brackets[array_open_brackets.pop] = i
      end
    end
  end

  # Translate the character 'c' with the list having a pointer input at 'i'
  def translate
    if @flag_read_next == true
      @array[@pos] = c.each_byte.first
      @flag_read_next = false
      return
    end

    case @input_array[@pointer_input]
    when ">" then @pos += 1
    when "<" then @pos -= 1
    when "+" then @array[@pos] += 1
    when "-" then @array[@pos] -= 1
    when "." then @output << @array[@pos] != 10 ? @array[@pos].chr : (10.chr + 13.chr) # \n conversion to \n \r
    when "," then @flag_read_next = true
    when "[" then @pointer_input = @hash_brackets[@pointer_input] if @array[@pos] == 0
    when "]" then @pointer_input = @hash_brackets.invert[@pointer_input] if @array[@pos] != 0
    end
  end

end

Brainfuck.new
