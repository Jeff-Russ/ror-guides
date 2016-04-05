<div id="page"      style="display: none;"><!-- Rails --></div>  
<div id='home-url'  style="display: none;"><!-- http://www.jeffruss.com --></div>  
<div id='logo-url'  style="display: none;"><!-- https://s3.amazonaws.com/jeffruss/img/JR_20px_wide.png --></div>  

<div class="catergory-menu" id='HowTo'  style="display: none;"><!--  --></div>  
<div class="catergory-menu" id='Resume' style="display: none;"><!--  --></div>  
<div class="catergory-menu" id='GitHub' style="display: none;"><!--  --></div>  

<div class="page-menu" id='Boostrap' style="display: none;"><!--http://www.jeffruss.com/?docs=bootstrap--></div>  
<div class="page-menu" id='Rails'    style="display: none;"><!--http://www.jeffruss.com/?docs=rails--></div>  


# The Ruby Language (with some Rails)

## Cheatsheet
    
### BASICS  

1. `puts` adds a newline print doesn't  
2. `# a comment` or `=begin a multiline comment =end`  
3. `variable_name` not `variableName`  
4. no `var` keyword to declare variables. Nothing is in it's place.  
5. `base ** exponent`  
6. `user_input_without_newline = gets.chomp`  
7. `puts "this is #{string} #{interpolation}"` double quotes only  
8. a semicolon is only needed for multistatement lines  
9. Method naming in Ruby... `.mutator!`, `.non_mutator`, `.returns_bool?`, `.setter=`  
10. Constants are `ALL_CAPS_WITH_UNDERSCORES` and are not strictly inforced  
11. Floats must always have a number before the decimal place!  
12. Variables are passed to methods by value so they can't be mutated  
13. heredoc for multiline string: `str = <<GROCERY_LIST` many lines then `GROCERY_LIST` 
14. To enter the Ruby console type `irb (Interactive Ruby)`  

### CONDITIONAL LOGIC  

1. it's `elsif` not `elseif`, `else if` or `elif`  
2. use `unless` for the opposite of `if`  
3. Ruby  keywords `and or not` are similar to `&& || !`  
4. Incr/decr with `+=` and `-=`. there is no `++` or `--`  
5. COMBINED COMPARISON OP `<=>` returns -1 if left is lower, 0 if equal, 1 if higher.  
6. nil` is treated as `false` and all non-nil/true values are "truthy"  

### LOOPS AND ITERATORS  

1. `until` loop is the opposite of `while`  
2. `for num in 1..10   `is done 10 times with `num` changing each time  
3. `for num in 1...10  `is done 9 times with `num` changing each time  
4. use `loop` keyword together with `break` to put condition inside the loop  
5. syntax:    `break if condition      next if condition`  
6. `object.each  { |item| do_something }` or  `object.each do |item| do_something end`  
7. `10.times { print "Chunky bacon!" }`  
8. `(1..10).each { |i| puts i }`  another way to run a range  

### ARRAYS  

1. `array = [1.2.3]   hash = {key: val, key: val}`  
2. strings can be compared with `== `whereas `.equal?` checks if they are same obj.  
3. `array = Array.new(5)            ` makes an array with 5 elements all nil  
4. `array = Array.new(5, "empty")   ` makes an array of five strings saying "empty  
5. `p array2                        ` prints out array. neat.  

##### array methods:  

1. `array[2,3].join(", ")` joins [2][3][4] with ", " into string  
2. `.values_at(1,3,5).join(", ")` same but elements 1, 3 and 5  
3. `.include?(2)    .count(2)` checks if it has a 2 and how many, respectively  
4. `.empty?`, `.size` checks if empty and it's size, respectively  
5. `.delete_at(2)`,`.delete(2)` deletes [2] and all containing 2, respectively  
6. `.shift`,`array.pop` removes 1st and last element, respectively  
7. `.first`,`array.last` returns 1st and last element, respectively  
8. `.push(8, 9)` add 8 and 9 to the end of the array  
9. `.unshift(3)` add 3 to the beginning of an array  
10. `.concat(array2)` adds array2 to the end of the array  

### HASHES  

1. `pets = Hash.new` OR `pets = {}` to declare empty hash  
2. `pets = Hash.new(1)` hash w/ default (out-of-bound) value of 1, not nil  
3. `pets["Stevie"] = "cat"` adds key/value to hash  
4. `pets["Stevie"]` accesses value from hash  
5. old notation with strings...  `my_hash = { "name" => "Eric", "age" => 26 }`  
6. string keys are slower than symbol keys  
7. old notation with symbols...  `my_hash = { :name => "Eric", :age => 26 }`  
8. newest and best notation...   `my_hash = { name: "Eric", age: 26 }`  

##### hash methods:  

1. `.delete(a_key)` deletes key/val for a_key  
2. `.update(another_hash)` combines two hashes, deleting duplicate entries  
3. `.merge(another_hash)` combines two hashes, keeping duplicate entries  
4. `.has_key?(k)` checks if k is a key  
5. `.has_value?(v)` checks if v is a value  
6. `.empty?`, `.size` checks if has is empty and it's size, respectively  
7. `.delete(whatever)` deletes whatever  
8. `.keys`, `.values` returns all of the keys or values, respectively  

### METHODS BLOCKS PROCS LAMDAS AND SORTING  

1. Methods are declared with the `def` keyword  
2. () for methods etc are option unless there is a block being passed also  
3. the last statement in a block is the `return`  
4. SPLAT ARGS look like `*arg` which could be any number of args. use `arg.each` on it  
5. `.sort!` can take a block to define the sort... { |L, R| R <=> L } inverts sort  
6. `array.collect! { |n| n * 2 }` applies block to each element of array AKA `.map`  
7. If you pass a block into a method, it is given the name `yield` inside the method.  
   The syntax for passing is method `{ |optional_arg| statements }`  
8. procs are blocks saved to a variable name so they can be passed more than once  
   `a_proc = Proc.new { |n| n % 3 == 0 }` THEN `a_method(&a_proc)` OR `a_proc.call`  
   Procs treat missing args as nil. They don't return control back to method.  
9. `a_lambda = lambda { |para| expression }` THEN `a_method(&a_lambda)`  
   Lambda throw error if wrong # of arg. They return control back to method.  
   
### CLASSES  

1. The constructor method in a class is `def initialize`.  
2. Instantiate using the constructor like this `object = Class.new(any_args)`  
3. `@instance_var`, `@@class_var`, `$global_var`, `local_var`  
4. `class DerivedClass < BaseClass` inheritance in Ruby  
5. override a parent method simply by creating one in child with same name  
6. while in body of overriding method, `super(optional args)` calls super's version  
7. `def Classname.class_var_getter { @@class_var }` this is a class method  
8. `public` (default) and `private` are put the line of above `def` with same indenting  
9. To auto-generate getter for `@inst_var`, declare it like - `attr_reader :inst_var`  
10. To auto-generate setter for `@inst_var`, declare it like - `attr_writer :inst_var` . What this generates is`def inst_var=(value) { @inst_var = value }`. `name=` is the name of the method and can be used with a space ( name = whatever)  
11. To auto-generate both the getter and setter use `attr_accessor`  
12. With these getter/setter declarationg you can declare many at at time, comma sep.  

### MODULES AND MIXINS  

1. Modules are similar to C++ namespaces and also similar to java interfaces  
    They are basically classes that __CAN'T__ hold variable and can't be instantiated.  
2. They also use the `::` scope resolution op.  
3. Modules are written in `CapitalizedCamelCase`, just like class names  
4. Modules are declared like classes only with the `module` keyword instead of `class`  
5. Modules contain constants and methods. Variable don't make sense in modules.  
6. Some modules like `Math` are automatically available. eg. `Math::PI`  
<br>__keywords:__ `require`, `require_relative`, `include`, `prepend`<br>  
7. For others like date you use `require` and single quotes with lowercase module name.  
    `require 'date' <br>puts Date.today`  
8. If the module is in a separate file in the same directory and called human.rb:  
    `require_relative "human"`  
9. If you want to use two modules that have the same named method or data you can:  
    `prepend UseThis` and `UseThis` will be used over the other module when clashing  
10. The `include` keyword is actually similar to using namespace in C++. It's often used inside a class def to avoid the `::` op. eg.  `include Math`  
11. Using `include` in a class mixes in a class and a module. We can also include a Class for it's methods and data in another class the same way. These are called __mixins__ and they imitate __multiple inheritance.__  
12. The `extend` keyword mixes a module's methods at the class level. This means  
    the class itself can use the methods, as opposed to instances of the class.  
13. __Polymporphism:__ you have `Bird`, `Cardinal < Bird`, `Parrot < Bird` all w/ `tweet` method.  
    Make the `Bird::tweet` take an arg of `bird_type `and run `bird_type.tweet`  
    Make: `generic_bird = Bird.new` THEN: `generic_bird.tweet(Cardinal.new)`  
    
### ENUMERATION  

1. The `Array` and `Hash` classes in Ruby include the `Enumerable` module  
2. The `Enumerable` module provides a set of methods to traverse, search, sort and manipulate collections.The Enumerable module itself doesn't define the each method. It's the responsibility of the class that is including this module to do so.
3. An __enumerator__ is an object of the class type `Enumerator` that allows for the aformentioned tasks to be performed. `array.each` returns an enumerator obj.  

### EXCEPTIONS  

__keywords:__ `raise`, `begin`, `rescue`, `end`  

1. Put `raise` in a named (`def`) block of code and surround the raise statement with conditional logic to either execute it or not depending on scenario. `raise` is like `throw` in C++. Ex. statement: `raise an_error` 
2. `begin` is like the `try` block in C++. It begins with the keyword `raise` and ending with `end`. It can contain a call to the method containing `raise`.  
3. `rescue` is like the `catch` block in C++. If the block containing `raise `contained.`raise an_error` then the catch block would start like `rescue and_error` and end with `end`.  

### SHORTHANDS  

1. a simpler `if`...  `expression if boolean`, NOT THIS: `if bolean puts "It's true!"`. Single-line would be `if bolean then puts "It's true!" end`. `puts "Ruby is eloquent!" if Ruby_is_eloquent` works with `unless` as well.  
2. `puts 3 < 4 ? "3 is less than 4!" : "3 is not less than 4."` (with ternary)  
3. `fav_book ||= "blah"`, NOT `fav_book = "blah" if fav_book.nil?`  
4. circut evaluation means the above sets `fab_book` to `"blah"` only if `nil` or `false`
5. `"L".upto("P") { |l| puts l }` for staircase looping, also `downto`  
6. `[1, 2, 3].respond_to?(:push)` checks of the object can have `.push` performed.Note that we converted the `.push` method to a :symbol  
7. `<<` concatenation operator instead of `.push` and `+`  
8. `"I am #{age} years old."`, NOT  `"I am " + age.to_s + " years old."`  
9. `nums = strings.map(&:to_i)` passed to_i as a symbol converted to a proc!  
10. A random example  - `private; def password; 12345; end`  
11. `case` statements can fold up: `when CONDITION then STATEMENT` and `else STATEMENT`  

### common methods:  
 `.length`, `.reverse`, `.upcase`, `.downcase`, `.swapcase`, `.allcaps`  
 `.capitalize`, `.floor`, `.count`  
 `a_boolean = a_number.even?`  
 `.lstrip` strips whitespace on left .rstrip #on right .strip #all whitespace  
 `.rjust(20, '.')` right justify and fill with dots. also .ljust and .center  
 `.chop`chops off left character `.chomp` eliminates newline  
 `.chomp("es")` chomps off "es" at end  
 `.delete("a")` deletes every occurance of "a"  
 `.include?(arg)` checks if a collection or string contains arg  
 `.gsub(arg1,arg2)` replaces all arg1 with arg2 in a string  
 `.each .times .collect` takes a block as a arg  
 `.split(" ")`, `.split(/ /)`  strips out " " and uses them to return array  
 `.split` defaults to using space as delimiter  
 `.split(//)` splits every character out into an array of them  
 `.to_s`, `.to_sym`, `.to_i`, `.to_f`, `.sort!`  
 `(1..10).to_a` returns an array of 10 ordered integers    
 `.is_a? Integer`  
 `.count("aeiou")` counts number of vowels `.count("^aeiou")` consonants  
 `.start_with?("a string")`, `.index("special word")` 
 `.equal?(object)` checks if they are the same object  
 `.printf` allows for C style formatted strings  
 `.class` find out what class and object belongs to.`.object_id` get id  
   
### common classes and their useages:  
1. `file File.new("filename.ext", "w")` "w" means write the file.  
   `file File.new("filename.ext", "a")` "a" means append the file.  
   `file.puts("Random text").to_s`  
   `file.close`  
   `file.open`  
   `puts File.read("filename.ext")`  
   `load "Rubyfile.rb"` will execute a Ruby file!  
    
    
    
    
    ===============  RUBY - CODEACADEMY.COM ================  

.-------------------------------------------------------------------------------  

## HASHES  

--------------------------------------------------------------------------------  
#### SORTING HASHES  

    colors = {"blue" => 3, "green" => 1, "red" => 2}  
    colors = colors.sort_by do |color, count|  
      count  
    end  
    colors.reverse!  

Above we sort colors into green, red, and blue, from smallest to largest by count.  
Just so you know, the .sort_by function returns an array of arrays, but that's  
fine for our purposes. Finally, we reverse the array order so that the colors  
with the largest counts are first.  


.-------------------------------------------------------------------------------  
#### SYMBOLS AND HASHES  

We can certainly use strings as Ruby hash keys; as we've seen, there's always  
more than one way to do something in Ruby. However, the Rubyist's approach would  
be to use symbols.  
   
    menagerie = { :foxes => 2,  
      :giraffe => 1,  
      :weezards => 17,  
      :elves => 1,  
      :canaries => 4,  
      :ham => 1  
    }  
    
The rules for naming symbols is that they start with a colon and after the colon  
they follow naming rules and conventions of normal variables. You can think of a  
Ruby symbol as a sort of name. It's important to remember that symbols aren't  
strings. While there can be multiple different strings that all have the same  
value, there's only one copy of any particular symbol at a given time.  

The .object_id method gets the ID of an object—it's how Ruby knows whether two  
objects are the exact same object.  

    puts "string".object_id  
    puts "string".object_id  
    puts :symbol.object_id  
    puts :symbol.object_id  
    
Variables can store symbols. Symbols can be converted to strings and visa-versa  

    my_first_symbol = :symbol  
    a_string = :symbol.to_s  
    my_second_symbol = a_string.to_sym   # the following is another way:  
    my_third_symbol = a_string.intern    # internalize the string into a symbol  
    
Symbols pop up in a lot of places in Ruby, but they're primarily used either as  
hash keys or for referencing method names.  

1. They're immutable, meaning they can't be changed once they're created;  
2. Only one copy of any symbol exists at a given time, so they save memory;  
3. Symbol-as-keys are faster than strings-as-keys because of the above two reasons.  

.-------------------------------------------------------------------------------  
#### NEW HASH SYNTAX  

The hash syntax has changed in Ruby 1.9. Just when you were getting comfortable!  
If you're used to JavaScript objects or Python dictionaries, it will look familiar:  

    new_hash = { one: 1,  
      two: 2,  
      three: 3  
    }  

The two changes are:  

1. You put the colon at the end of the symbol, not at the beginning;  
2. You don't need the hash rocket anymore.  

It's important to note that even though these keys have colons at the end instead  
of the beginning, they're still symbols!  


.-------------------------------------------------------------------------------  
#### HASH METHODS  

What if we want to filter a hash for values that meet certain criteria?  
For that, we can use .select  

    grades = { alice: 100,  
      bob: 92,  
      chris: 95,  
      dave: 97  
    }  
    great = grades.select {|name, grade| grade < 97}# {:bob=>92, :chris=>95}  
    alice = grades.select { |k, v| k == :alice }    # {:alice=>100}  
    
If we only work on the key(s) or values(s) it can be a pain to have to always  
deal with both when we only want one. Ruby includes two hash methods, .each_key  
and .each_value, that do exactly what you'd expect:  

    my_hash = { one: 1, two: 2, three: 3 }  
    my_hash.each_key { |k| print k, " " }   # ==> one two three  
    my_hash.each_value { |v| print v, " " } # ==> 1 2 3  

.-------------------------------------------------------------------------------  

## METHODS  

--------------------------------------------------------------------------------  
#### CALL AND RESPONSE  

Ruby is less concerned about what kind of thing an object is and only really  
cares about what method calls it responds to.  

Remember when we mentioned that symbols are awesome for referencing method names?  
Well, .respond_to? takes a symbol and returns true if an object can receive that  
method and false otherwise. For example,  

    [1, 2, 3].respond_to?(:push)  

would return true, since you can call .push on an array object. However,  

    [1, 2, 3].respond_to?(:to_sym)  

would return false, since you can't turn an array into a symbol.  

.-------------------------------------------------------------------------------  
#### METHOD SYNTAX  

methods are defined with the def keyword. Arguments are put in parentheses.  

    def method_name (arg1, arg2)  
        sum = arg1 + arg2  
        return sum  
    end  
    
If there is no argument you don't need () in the definition or the call.  
Ruby methods have an optional return statement(s).  

For instance, if you don't tell a JavaScript function exactly what to return,  
it'll return undefined. For Python, the default return value is None. But for Ruby,  
it's something different: Ruby's methods will return the result of the last  
evaluated expression.  

This means that if you have a Ruby method like this one:  

    def add(a,b)  
      return a + b  
    end  
    
You can simply write:  
    
    def add(a,b)  
      a + b  
    end  

Methods that return a boolean have a name ending with a question mark ?  
Methods with side effects end with an exclamation point !  

.-------------------------------------------------------------------------------  
#### SPLAT ARGUMENTS  

Splat arguments are arguments preceded by a *, which signals to Ruby: "Hey Ruby,  
I don't know how many args there are about to be, but it could be more than one."  

    def what_up(greeting, *bros)  
      bros.each { |bro| puts "#{greeting}, #{bro}!" }  
    end  
     
    what_up("What up", "Justin", "Ben", "Kevin Sorbo")  
  
.-------------------------------------------------------------------------------  

## BLOCKS  

--------------------------------------------------------------------------------  
#### AS METHOD ARGUMENT  

A block is just a bit of code between do..end or {}. It's not an object on its  
own, but it can be passed to methods like .each or .select  

You can think of blocks as a way of creating methods that don't have a name.  
(These are similar to anonymous functions in JavaScript or lambdas in Python.)  

    # method that capitalizes a word  
    def capitalize(string)  
      puts "#{string[0].upcase}#{string[1..-1]}"  
    end  
    
    capitalize("ryan") # prints "Ryan"  
    capitalize("jane") # prints "Jane"  
    
    # block that capitalizes each string in the array  
    ["ryan", "jane"].each {|string| puts "#{string[0].upcase}#{string[1..-1]}"} # prints "Ryan", then "Jane"  
        
A method can take a block as a parameter. That's what .each has been doing this  
whole time: taking a block as a parameter and doing stuff with it! You just  
didn't notice because we didn't use the optional parentheses.  

Why do some methods accept a block and others don't? It's because methods that  
accept blocks have a way of transferring control from the calling method to the  
block and back again. We can build this into the methods we define by using the  
yield keyword.  

    def block_test  
      puts "We're in the method!"  
      puts "Yielding to the block..."  
      yield  
      puts "We're back in the method!"  
    end  
    
    block_test { puts ">>> We're in the block!" }  
    
You can also have the method accept an argument. The caller then supplies the arg  
and the block in that order. The block uses the arg surrounded by  | |  

    yield_w_arg("string") { |s| puts "you passed in #{s}. }  
    
In the definition of yield_w_arg, the block you passed in it called with the  
appearance of the yeild() keyword with the () for an argument. The argument could  
be something internal to yield_w_arg or it could be the argument that was passed in.  

    def yield_name(externally_passed_argument)  
      yield("internally passed argument")  
      yield(externally_passed_argument)  
    end  
    
.-------------------------------------------------------------------------------  
#### PROCS  

Blocks are not objects, and this is one of the very few exceptions to the  
"everything is an object" rule in Ruby. Because of this, blocks can't be saved  
to variables and don't have all the powers and abilities of a real object.  
For that, we'll need... procs! A proc is a saved block we can use over and over.  

    def greeter  
        yield  
    end  
    phrase = Proc.new { puts "Hello there!"}  
    greeter(&phrase)  

Here is a more complex example taking an argument:  

    multiples_of_3 = Proc.new do |n|  
      n % 3 == 0  
    end  
    
    (1..100).to_a.select(&multiples_of_3)  # note the &  
    
Remember that do and {} are interchangle so we could have done this:  
    
    multiples_of_3 = Proc.new { |n| n % 3 == 0 }  
    
Procs are full-fledged objects, so they have all the powers and abilities of  
objects. (Blocks do not.) Unlike blocks, we can call procs directly by using  
Ruby's .call method. Check it out!  

    hi = Proc.new { puts "Hello!" }  
    hi.call  
    
Just as you can pass a Ruby method name around with a symbol you can also  
convert symbols to procs using that handy little &.  

    strings = ["1", "2", "3"]  
    nums = strings.map(&:to_i)    # ==> [1, 2, 3]  
    
By mapping &:to_i over every element of strings, we turned each string into an integer!  


.-------------------------------------------------------------------------------  
#### LAMBDAS  

Like procs, lambdas are objects. The similarities don't stop there: with the  
exception of a bit of syntax and a few behavioral quirks, lambdas are identical  
to procs.  

    lambda { puts "Hello!" }    #  same as Proc.new { puts "Hello!" }  
    lambda { |param| block }    #  another lambda  
    
There are only two main differences. First, a lambda checks the number of arguments  
passed to it, while a proc does not. This means that a lambda will throw an error  
if you pass it the wrong number of arguments, whereas a proc will ignore unexpected  
arguments and assign nil to any that are missing.  

Second, when a lambda returns, it passes control back to the calling method;  
when a proc returns, it does so immediately, without going back to the calling method.  

    def batman_ironman_proc  
      victor = Proc.new { return "Batman will win!" }  
      victor.call  
      "Iron Man will win!"  
    end  
    
    puts batman_ironman_proc  
    
    def batman_ironman_lambda  
      victor = lambda { return "Batman will win!" }  
      victor.call  
      "Iron Man will win!"  
    end  
    
    puts batman_ironman_lambda  
    
.-------------------------------------------------------------------------------  

## RUBY CLASSES  
    
--------------------------------------------------------------------------------  
#### CLASSES IN RUBY  

    class Language  
      def initialize(name, creator)  
        @name = name  
        @creator = creator  
      end  
    	
      def description  
        puts "I'm #{@name} and I was created by #{@creator}!"  
      end  
    end  
    
    Ruby = Language.new("Ruby", "Yukihiro Matsumoto")  
    Ruby.description  
    
The initialize member is named as such so that it's idenfied as the constructor.  
variables beginning with @ are instance variables (attributes). Class names should  
begin with an uppercase letter and use CamelCase Not_underscores  

When dealing with classes or methods, you can have:  
  local_variable:   ones that are only available certain methods  
 $global_variable:  variables that are available everywhere  
 @@class_variable:  variables that are members of a certain class  
@instance_variable: variables that are only available to particular instances of a class  

Global variables can be declared in two ways. The first is one that's already  
familiar to you: you just define the variable outside of any method or class,  
and voilà! It's global. If you want to make a variable global from inside a  
method or class, just start it with a $, like so: $matz. To make a getter method  
for a global variable called @@globo in a class called Class use this naming:  

    def Class.get_globo  
        @@globo; end  

Class variables are like instance variables, but instead of belonging to an  
instance of a class, they belong to the class itself. Class variables always  
start with two @s, like so: @@files.  

.-------------------------------------------------------------------------------  
####  CLASS INHERITANCE  

    class ApplicationError  
      def display_error  
        puts "Error! Error!"  
      end  
    end  
    
    class SuperBadError < ApplicationError   # NOTE USE OF <  
    end  
    
    err = SuperBadError.new  
    err.display_error  
    
To override a method simply define it in the subclass. Sometimes you'll be working  
with a derived class (or subclass) and realize that you've overwritten a method or  
attribute defined in that class' base class (also called a parent or superclass)  
that you actually need. Have no fear! You can directly access the attributes or  
methods of a superclass with Ruby's built-in super keyword.  
    
    class DerivedClass < Base  
      def some_method  
        super(optional args)  
          # Some stuff  
        end  
      end  
    end  
    
super() calls Base.some_method  


.-------------------------------------------------------------------------------  
####  PUBLIC AND PRIVATE CLASSES  

Methods are public by default in Ruby, so if you don't specify public or private,  
your methods will be public. In this case, however, we want to make it clear.  
Note that everything after the public keyword through the end of the class  
definition will now be public unless we say otherwise.  

     class ClassName  
    
      public  
      def public_method  
        # public_method stuff; end  
    end  
    
Private methods can only be called  from other code inside the object. Another way  
to say this is that the method cannot be called with an explicit receiver. You've  
been using receivers all along—these are the objects on which methods are called!  
Whenever you call object.method, object is the receiver of the method.  


.-------------------------------------------------------------------------------  
#### ATTR_READER, ATTR_WRITER ATTR_ACCESSOR  

Ruby has a less verbose alternative to the creaton of getter and setter methods  
for private data.  

    class Person  
      attr_reader :name  
      attr_writer :name  
      def initialize(name)  
        @name = name  
      end  
    end  

Ruby does something like this for us automatically:  

    def name; @name; end  
    
    def name=(value)  
      @name = value  
    end  
    
Like magic, we can read and write variables as we please! We just pass our  
instance variables (as symbols) to attr_reader or attr_writer.  

(That name= might look funny, but you're allowed to put an = sign in a method name.  
That's just a Ruby convention saying, "hey, this method sets a value!")  

If we want to both read and write a particular variable, there's an even shorter  
shortcut than using attr_reader and attr_writer. We can use attr_accessor to  
make a variable readable and writeable in one fell swoop.  


.-------------------------------------------------------------------------------  

## MODULES  

--------------------------------------------------------------------------------  

You can think of a module as a toolbox that contains a set methods and constants.  
There are lots and lots of Ruby tools you might want to use, but it would clutter  
the interpreter to keep them around all the time.  

You can think of modules as being very much like classes, only modules can't  
create instances and can't have subclasses. They're just used to store things!  
This creates a module called Circle:  

    module Circle  
      PI = 3.141592653589793  
      def Circle.area(radius); PI * radius**2; end  
      def Circle.circumference(radius); 2 * PI * radius; end  
    end  
    
Like class names, module names are written in CapitalizedCamelCase,  
rather than lowercasewithunderscores. Variable don't make sense in modules so we  
use constants which are ALL_CAPS_WITH_UNDERSCORES. This tips off the interpreter  
to give a warning if we attempt to modify them (but doesn't stop us!!)  

One of the main purposes of modules is to separate methods and constants into  
named spaces. This is called (conveniently enough) namespacing, and it's how Ruby  
doesn't confuse Math::PI and Circle::PI. Same scope resolution op as C++!!  

Some modules, like Math, are already present in the interpreter. Others need to  
be explicitly brought in, however, and we can do this using require.  
We can do this simply by typing  

require 'date'  
puts Date.today  

We can do more than just require a module, however. We can also include it!  
Any class that includes a certain module can use those module's methods!  
A nice effect of this is that you no longer have to prepend your constants and  
methods with the module name. Since everything has been pulled in, you can simply  
write PI instead of Math::PI.  

    include Math    # Note the lack of quotes.  

This can be put anywhere in your code, even a class definition.  

.-------------------------------------------------------------------------------  

## MIXIN  

--------------------------------------------------------------------------------  

When a module is used to mix additional behavior and information into a class, it's  
called a mixin. Mixins allow us to customize a class without having to rewrite code!  

    module Action  
      def jump  
        @distance = rand(4) + 2  
        puts "I jumped forward #{@distance} feet!"; end; end  
    
    class Rabbit  
      include Action  
      attr_reader :name  
      def initialize(name)  
        @name = name; end; end  
    
    class Cricket  
      include Action  
      attr_reader :name  
      def initialize(name)  
        @name = name; end; end  
    
    peter = Rabbit.new("Peter")  
    jiminy = Cricket.new("Jiminy")  
    
    peter.jump  
    jiminy.jump  

Now you understand why we said mixins could give us the ability to mimic  
inheriting from more than one class: by mixing in traits from various modules  
as needed, we can add any combination of behaviors to our classes we like!  

Whereas include mixes a module's methods in at the instance level (allowing  
instances of a particular class to use the methods), the extend keyword mixes a  
module's methods at the class level. This means that class itself can use the  
methods, as opposed to instances of the class.