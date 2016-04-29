<div id="page"      style="display: none;"><!-- Rails --></div>  
<div id='home-url'  style="display: none;"><!-- http://www.jeffruss.com --></div>  
<div id='logo-url'  style="display: none;"><!-- https://s3.amazonaws.com/jeffruss/img/JR_20px_wide.png --></div>  

<div class="catergory-menu" id='HowTo'  style="display: none;"><!--  --></div>  
<div class="catergory-menu" id='Resume' style="display: none;"><!--  --></div>  
<div class="catergory-menu" id='GitHub' style="display: none;"><!--  --></div>  

<div class="page-menu" id='Rails'    style="display: none;"><!--http://www.jeffruss.com/?docs=rails--></div>  
<div class="page-menu" id='Boostrap' style="display: none;"><!--http://www.jeffruss.com/?docs=bootstrap--></div>  


# Ruby Cheatsheet
 
<div class="section" id='Basics'><!--#basics--></div>

### BASICS  
* a semicolon is only needed for multi-statement lines  
* no `var` keyword to declare variables. Nothing is in it's place.  
* `variable_name` not `variableName`  
* `puts` adds a newline `print` doesn't  
* `# a comment` or `=begin a multiline comment =end`  
* `base ** exponent`  
* `user_input_without_newline = gets.chomp`  
* `puts "this is #{string} #{interpolation}"` double quotes only  
* Method naming in Ruby... `.mutator!`, `.non_mutator`, `.returns_bool?`, `.setter=`  
* Constants are `ALL_CAPS_WITH_UNDERSCORES` and are not strictly inforced  
* Floats must always have a number before the decimal place!  
* heredoc for multiline string: `str = <<GROCERY_LIST` many lines then `GROCERY_LIST` 
* To enter the Ruby console type `irb` "interactive ruby"  

### CONDITIONAL LOGIC  
* it's `elsif` not `elseif`, `else if` or `elif`  
* use `unless` for the opposite of `if`  
* Ruby  keywords `and or not` are similar to `&& || !`  
* Incr/decr with `+=` and `-=`. there is no `++` or `--`  
* COMBINED COMPARISON OP `<=>` returns -1 if left is lower, 0 if equal, 1 if higher.  
* `nil` is treated as `false` and all non-nil/true values are "truthy"  

<div class="section" id='LoopsIter'><!--#loops-and-iterator--></div>

### LOOPS AND ITERATORS  
* `until` loop is the opposite of `while`  
* `for num in 1..10` is done 10 times with `num` changing each time  
* `for num in 1...10` is done 9 times with `num` changing each time  
* use `loop` keyword together with `break` to put condition inside the loop  
* syntax:    `break if condition` or `next if condition`  
* `object.each  { |item| do_something }` or  `object.each do |item| do_something end`  
* `10.times { print "Chunky bacon!" }`  
* `(1..10).each { |i| puts i }`  another way to run a range  

<div class="section" id='Arrays'><!--#arrays--></div>

### ARRAYS  
* array: `array = [1.2.3]` hash: `hash = {key: val, key: val}`  
* strings can be compared with `== `whereas `.equal?` checks if they are same obj.  
* `array = Array.new(5)            ` makes an array with 5 elements all nil  
* `array = Array.new(5, "empty")   ` makes an array of five strings saying "empty  
* `p array2                        ` prints out array. neat.  

##### array methods:  
* `array[2,3].join(", ")` joins array[2] + ", " + array[3] into string  
* `.values_at(1,3,5).join(", ")` same but elements 1, 3 and 5  
* `.include?(2)    .count(2)` checks if it has a 2 and how many, respectively  
* `.empty?`, `.size` checks if empty and it's size, respectively  
* `.delete_at(2)`,`.delete(2)` deletes [2] and all containing 2, respectively  
* `.shift`,`array.pop` removes 1st and last element, respectively  
* `.first`,`array.last` returns 1st and last element, respectively  
* `.push(8, 9)` add 8 and 9 to the end of the array  
* `.unshift(3)` add 3 to the beginning of an array  
* `.concat(array2)` adds array2 to the end of the array  

<div class="section" id='Hashes'><!--#hashes--></div>

### HASHES  
* `pets = Hash.new` OR `pets = {}` to declare empty hash  
* `pets = Hash.new(1)` hash w/ default (out-of-bound) value of 1, not nil  
* `pets["Stevie"] = "cat"` adds key/value to hash  
* `pets["Stevie"]` accesses value from hash  
* old notation with strings...  `my_hash = { "name" => "Eric", "age" => 26 }`  
* string keys are slower than symbol keys  
* old notation with symbols...  `my_hash = { :name => "Eric", :age => 26 }`  
* newest and best notation...   `my_hash = { name: "Eric", age: 26 }`  

##### hash methods:  
* `.delete(a_key)` deletes key/val for a_key  
* `.update(another_hash)` combines two hashes, deleting duplicate entries  
* `.merge(another_hash)` combines two hashes, keeping duplicate entries  
* `.has_key?(k)` checks if k is a key  
* `.has_value?(v)` checks if v is a value  
* `.empty?`, `.size` checks if has is empty and it's size, respectively  
* `.delete(whatever)` deletes whatever  
* `.keys`, `.values` returns all of the keys or values, respectively  

<div class="section" id='ProcsEtc'><!--#methods-blocks-procs-lambas-and-sorting--></div>

### METHODS BLOCKS PROCS LAMDAS AND SORTING  
* Methods are declared with the `def` keyword  
* () for methods etc are option unless there is a block being passed also  
* the last statement in a block is the `return`  
* SPLAT ARGS look like `*arg` which could be any number of args. use `arg.each` on it  
* `.sort!` can take a block to define the sort... `{ |L, R| R <=> L }` inverts sort  
* `array.collect! { |n| n * 2 }` applies block to each element of array AKA `.map`  
* If you pass a block into a method, it is given the name `yield` inside the method.  
   The syntax for passing is method `{ |optional_arg| statements }`  
* procs are blocks saved to a variable name so they can be passed more than once  
   `a_proc = Proc.new { |n| n % 3 == 0 }` THEN `a_method(&a_proc)` OR `a_proc.call`  
   Procs treat missing args as nil. They don't return control back to method.  
* `a_lambda = lambda { |para| expression }` THEN `a_method(&a_lambda)`  
   Lambda throw error if wrong # of arg. They return control back to method.  

<div class="section" id='Classes'><!--#classes--></div>

### CLASSES  
* The constructor method in a class is `def initialize`.  
* Instantiate using the constructor like this `object = Class.new(any_args)`  
* `@instance_var`, `@@class_var`, `$global_var`, `local_var`  
* `class DerivedClass < BaseClass` inheritance in Ruby  
* override a parent method simply by creating one in child with same name  
* while in body of overriding method, `super(optional args)` calls super's version  
* `def Classname.class_var_getter { @@class_var }` this is a class method  
* `public` (default) and `private` are put the line of above `def` with same indenting  
* To auto-generate getter for `@inst_var`, declare it like - `attr_reader :inst_var`  
* To auto-generate setter for `@inst_var`, declare it like - `attr_writer :inst_var` . What this generates is`def inst_var=(value) { @inst_var = value }`. `name=` is the name of the method and can be used with a space ( name = whatever)  
* To auto-generate both the getter and setter use `attr_accessor`  
* With these getter/setter declarationg you can declare many at at time, comma sep.  

<div class="section" id='Mixins'><!--#modules-and-mixins--></div>

### MODULES AND MIXINS  
* Modules are similar to C++ namespaces and also similar to java interfaces  
    They are basically classes that __CAN'T__ hold variable and can't be instantiated.  
* They also use the `::` scope resolution op.  
* Modules are written in `CapitalizedCamelCase`, just like class names  
* Modules are declared like classes only with the `module` keyword instead of `class`  
* Modules contain constants and methods. Variable don't make sense in modules.  
* Some modules like `Math` are automatically available. eg. `Math::PI`  

##### Keywords
`require`, `require_relative`, `include`, `prepend`, `extend`  

* For others like date you use `require` and single quotes with lowercase module name. `require 'date' <br>puts Date.today`  
* If the module is in a separate file in the same directory and called human.rb: `require_relative "human"`  
* If you want to use two modules that have the same named method or data you can: `prepend UseThis` and `UseThis` will be used over the other module when clashing  
* The `include` keyword is actually similar to using namespace in C++. It's often used inside a class def to avoid the `::` op. eg.  `include Math`  
* Using `include` in a class mixes in a class and a module. We can also include a Class for it's methods and data in another class the same way. These are called __mixins__ and they imitate __multiple inheritance.__  
* The `extend` keyword mixes a module's methods at the class level. This means the class itself can use the methods, as opposed to instances of the class.  

##### Polymporphism
Say you have the classes `Bird`, `Cardinal < Bird`, `Parrot < Bird` all w/ `tweet` method. Make the `Bird::tweet` take an arg of `bird_type `and run `bird_type.tweet`. Make: `generic_bird = Bird.new` THEN: `generic_bird.tweet(Cardinal.new)`  

<div class="section" id='Enumerat.'><!--#enumeration--></div>

### ENUMERATION  

* The `Array` and `Hash` classes in Ruby include the `Enumerable` module  
* The `Enumerable` module provides a set of methods to traverse, search, sort and manipulate collections.The Enumerable module itself doesn't define the each method. It's the responsibility of the class that is including this module to do so.
* An __enumerator__ is an object of the class type `Enumerator` that allows for the aformentioned tasks to be performed. `array.each` returns an enumerator obj.  

<div class="section" id='Except.'><!--#exceptions--></div>

### EXCEPTIONS  

__keywords:__ `raise`, `begin`, `rescue`, `end`  

* Put `raise` in a named (`def`) block of code and surround the raise statement with conditional logic to either execute it or not depending on scenario. `raise` is like `throw` in C++. Ex. statement: `raise an_error` 
* `begin` is like the `try` block in C++. It begins with the keyword `raise` and ending with `end`. It can contain a call to the method containing `raise`.  
* `rescue` is like the `catch` block in C++. If the block containing `raise `contained.`raise an_error` then the catch block would start like `rescue and_error` and end with `end`.  

<div class="section" id='Shortcuts'><!--#shortcuts--></div>

### SHORTCUTS  

* a simpler `if`...  `expression if boolean`, NOT THIS: `if bolean puts "It's true!"`. Single-line would be `if bolean then puts "It's true!" end`. `puts "Ruby is eloquent!" if Ruby_is_eloquent` works with `unless` as well.  
* `puts 3 < 4 ? "3 is less than 4!" : "3 is not less than 4."` (with ternary)  
* `fav_book ||= "blah"`, NOT `fav_book = "blah" if fav_book.nil?`  
* circut evaluation means the above sets `fab_book` to `"blah"` only if `nil` or `false`
* `"L".upto("P") { |l| puts l }` for staircase looping, also `downto`  
* `[1, 2, 3].respond_to?(:push)` checks of the object can have `.push` performed.Note that we converted the `.push` method to a :symbol  
* `<<` concatenation operator instead of `.push` and `+`  
* `"I am #{age} years old."`, NOT  `"I am " + age.to_s + " years old."`  
* `nums = strings.map(&:to_i)` passed to_i as a symbol converted to a proc!  
* A random example  - `private; def password; 12345; end`  
* `case` statements can fold up: `when CONDITION then STATEMENT` and `else STATEMENT`  

<div class="section" id='Common'><!--#common--></div>


### Common Methods, etc:  
* `.length`, `.reverse`, `.upcase`, `.downcase`, `.swapcase`, `.allcaps`  
* `.capitalize`, `.floor`, `.count`  
* `a_boolean = a_number.even?`  
* `.lstrip` strips whitespace on left .rstrip #on right .strip #all whitespace  
* `.rjust(20, '.')` right justify and fill with dots. also .ljust and .center  
* `.chop`chops off left character `.chomp` eliminates newline  
* `.chomp("es")` chomps off "es" at end  
* `.delete("a")` deletes every occurance of "a"  
* `.include?(arg)` checks if a collection or string contains arg  
* `.gsub(arg1,arg2)` replaces all arg1 with arg2 in a string  
* `.each .times .collect` takes a block as a arg  
* `.split(" ")`, `.split(/ /)`  strips out " " and uses them to return array  
* `.split` defaults to using space as delimiter  
* `.split(//)` splits every character out into an array of them  
* `.to_s`, `.to_sym`, `.to_i`, `.to_f`, `.sort!`  
* `(1..10).to_a` returns an array of 10 ordered integers    
* `.is_a? Integer`  
* `.count("aeiou")` counts number of vowels `.count("^aeiou")` consonants  
* `.start_with?("a string")`, `.index("special word")` 
* `.equal?(object)` checks if they are the same object  
* `.printf` allows for C style formatted strings  
* `.class` find out what class and object belongs to.`.object_id` get id  
   <br>
* `file File.new("filename.ext", "w")` "w" means write the file.  
* `file File.new("filename.ext", "a")` "a" means append the file.  
* `file.puts("Random text").to_s`  
* `file.close`  
* `file.open`  
* `puts File.read("filename.ext")`  
* `load "Rubyfile.rb"` will execute a Ruby file!  

<hr>
<a href='http://www.jeffruss.com' style='color:#FFFFEE'>
<small>© Copyright 2016 Jeffrey Russ</small><br><br><br>
</a>