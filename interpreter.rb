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
    @hash_brackets = {} # Stores a pair <key, value> = <Close bracket position, Open bracket position>
    @flag_read_next = false

    pre_processing_brackets

    while(@pointer_input < @input_array.size)
      translate(@input_array[@pointer_input], @pointer_input)
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
  def translate(c, i)
    if @flag_read_next == true
      @array[@pos] = c.each_byte.first
      @flag_read_next = false
      return
    end

    case c
    when ">" then @pos += 1
    when "<" then @pos -= 1
    when "+" then @array[@pos] += 1
    when "-" then @array[@pos] -= 1
    when "." then @output << @array[@pos] != 10 ? @array[@pos].chr : (10.chr + 13.chr) # \n conversion to \n \r
    when "," then @flag_read_next = true
    when "[" then start_loop(i)
    when "]" then # No-Op
    end
  end

 def start_loop(i)
    # Jump pointer input to corresponding ']'
    @pointer_input = @hash_brackets[i] if @hash_brackets[i] > @pointer_input

    # Finding limits of interation:
    first = i + 1
    last = @hash_brackets[i] - 1

    flag_stop = false
    pos_to_zero = @pos

    while flag_stop == false
      for i in first..last
        c = @input_array[i]
        translate(c, i + first)
        flag_stop = true if @array[pos_to_zero] == 0
      end
    end
  end
end

Brainfuck.new
