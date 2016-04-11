
--------------------------------------------------------------------------------
# The Rails Architecture

--------------------------------------------------------------------------------

## How Rails Handles Request

The requests first hits the server before anything Rails related hears about it. 

Rails actually tries to respond to requests with the public folder first and only 
searches routes if it doesn't find anything that matches the request in the public 
directory. This means that requests handled by things in the public directory bypass 
the Rails Framework and are served up quickest. 

All requests that hit the framework's routing are funnelled into a controller. 
The controller has direct access to both views and models, with one way and two 
way interaction repectively. The model has two way access with the database and 
is the only component to have it. 

And connection between the views and models are handled via the controller action. 
This is one-way, meaning the model can talk to the view via the controller action 
but the view only calls back to the server.Not only that, the view is the ONLY 
component to call back to the server, which then serves back the response to the 
client browser

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/rails_structure.png)

If you drop and html file in public, it will be available if typed after `/` 
in the url. Some web servers let you skip the `.html` extension in the path. 
If you create a directory in public, it will be reflected in url's as well. So 
both your routes in routes.rb and the file structure of the public folder will 
define url paths but keep in mind that public takes precedence!

__A Closer Look__  

Our previous chart of the Rails structure was simplified in that it didn't show 
exactly what is going on between the controllers, action and views. 

To give you an idea of how rails passes around resposibility, focus on the three 
parts: `routes.rb`, the `controllers` folder and the `views` folder. Ignore models 
and the database for now:

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/rails_file_structure_neg.png)

Note that the parenthesis are just there to show "this is where that name would be 
inserted in the file or directory name."

The usual way a request is handled is to treat the url as if:

	http://www.example.com/(ctrl_name)/(action_name)/

has the two parentheisized portions mapped out to the matching controller and 
action (which themselves match the names of files in the `view/` directory!). 

If you were to look at the `*_controller.rb` files you will see they are single 
classes named to match their file name and they contain methods matching the 
action names. Also note that the action names are seen in the views directory, 
with the files for each view matching an action. 

This means that when your site gets a request for 

	http://www.example.com/(ctrl_name_2)/(action_name_3)/

The routes.rb file might (if it follows default conventions) have a line that 
grabs up this URL and points it to the `action_name_3` method of the `ctrl_name_2` 
class. This method then gets called and, unless there is anything in that method 
definition to override default behaivor, that method will render 
`(action_name_3).html.erb` and send it back to the browser (via the server of course).

This is the normal way of handling a request but there are many acceptions. As 
we will see soon.  
§

--------------------------------------------------------------------------------
## Command Line Tools For Rails

Rails was build for development on Unix and Linux machines and makes extensive 
use of the command line. The exact of these tools will become more clear after 
using them but for now here is a broad overview. 

__Rails__ has a command simply named __"rails"__ which is called to generate your 
app as well as various parts withing your app. Type `rails new app_name` to 
generate a new Rails app. 

__Bundle__ is used to manage the various packages, called __Gems__ used by your 
Rails application and Ruby as a whole. After you have set up your Gemfile to list 
all the Gems you will use you type `bundle install` to intall them all. 


__The rake / rails Command__  

__NOTE:__ Starting with Rails version 5, the full functionality of the `rake` 
command is taken over by the `rails` command. In other words, `rake` is no longer 
needed as the `rails` binary includes everything the `rake` command did. Whenever 
you see `rake` being used in this documentation or elsewhere, you would substitute 
it with `rails` if you are using Rails version 5 or greater.

__Rake__ is the Ruby version of Unix's `make` build automation tool. Similar to `make`'s 
`Makefile`, `rake` uses a file called `Makefile` for it's configuration. This file 
will load up the basics of our application, as well as the rake tasks that are 
built into Rails. We can also create our own tasks and put them in the  `lib/tasks`
directory. `rake` is not just used for Ruby on Rails development and is really a 
command line tool belonging to the Ruby ecosystem. 

Rake exists outside of Rails for other tasks but with Rails it will be used for 
tasks which link your Rails app's code to the database (which is not really part 
of your Rails app. This differs from __irb__ which is used to manipulate the database 
more directly. 

When you use the `rake` command, you must be in the directory containing the `Rakefile` 
which, in the case of a Rails application is the root of the project. Rake is used 
by typing `rake TASK_NAME OPTIONAL_ENV_VAR`. 

__Printing out Available Rake Tasks__

If you want a list of the available tasks you can type:

	rake -T

and it will return a long list of all the tasks available for a given location. 
You can filter the results to show only those pertaining to database by typing:

	rake -T db

An optional second argument for rake in RoR is the environment variable, for example:

	rake db:schema:dump RAIL_ENV=production

The Rail environment defaults to `production` for pretty much everything so it's 
useful to have this second argument to override that. 


__Rails Console__  

Ruby itself has it's own command line shell called Interactive Ruby which you 
enter by typing `irb` in the normal CL. Rails has it's own version of `irb` which 
you enter with:   

	$ rails console # or rails c

Here you will have access to Rail's database agnostic commands to administrate 
the details of the database using Ruby syntax. Note that we enter the console 
within the default environment which is development. We can also do 

	$ rails console production

but __BEWARE!__ THis will actually modify the data on your live website's database! 


__Rails dbconsole__  

`rails console` will give you access to your database, no matter what lanauges your database uses, in Ruby on Rails syntax. If you are using MySQL, PostgreSQL, SQLite or SQLite3 and would like to access the database in it's own specific interface run:  

	$ rails dbconsole # or rails db

And Rails figures out which database you're using and drops you into whichever command line interface you would use with it. It will even figure out the command line parameters to give to it.  

### Ruby Console Tricks  

Some tools available in Ruby don't have much use in saved code but they can be pretty usesful in  a Ruby console like `irb` or something based on irb like `rails console`. If you want to see what class an object belongs to can run these and get an array of :symbols:  

	> object.class            # returns class name
	> Classname.superclass    # shows superclass
	> "a string".class        #=> String 
	> String.superclass       #=> Object
	> String.methods          # shows ALL methods
	> String.instance_methods # shows all instance methods, including inherited
	> String.methods(false)   # only non-inherited
	> String.instance_methods(false) # only non-inherited instance methods
	
	# You can also chan `.grep()` at the end of any of those. 



Methods in Ruby are also objects. Let's take the Ruby class `String` which has a method called `upcase` as an example. Objects created from any class have a method called `method` that takes a :symbol version of a method name as an arugument
	
	> class_object = String.new
	> method_object = class_object.method(:upcase)
	> method_object.source_location # returns file location where String.new is defined!!!
	
As you can see, the object version of a method has a method itselt called `.source_location` which show the file location where object method's method was defined! We could have done the whole thing at once like this: 

	> String.new.method(:upcase).source_location
	> String.method(:new).source_location
	
So how is this useful? In Rails, a lot of your classes have methods added to them by Rails. For example, when working with the database you made Model class called "Model" which inherits from `ActiveRecord::Base`. You'll have a method called `create` but it's not in your code and maybe you want to look at it's definition. 

	> Model.method(:create).source_location
		=> ["~/.rvm/gems/ruby-2.2.3/gems/activerecord-4.2.6/lib/active_record/persistence.rb", 29]
	
We didn't need `.new` in there since `create` is a class method (doesn't need a new object made to be available). Now just copy the path and remember it's "line 29"
	
	> exit
	$ vim ~/.rvm/gems/ruby-2.2.3/gems/activerecord-4.2.6/lib/active_record/persistence.rb

and look at line 29!

### Ruby Console Add-Ons

You might want to consider `irbtools` to get much nicer console formatting. It color codes things and sets `=>` output to the right of what you typed intead of underneath, where it clutters up your console with more lines. There is also the gem `hirb` which let's you view data on your database in an actual table format, like SQL, insead of all in one big line without and visual indication of rows and colums. As of this writing, here is how you install them (be in project root!): 

	$ # install gem for all of Ruby:
	$ gem install irbtools
	$ gem install hirb
	$
	$ # make it load required file each session: 
	$ echo "require 'irbtools'" >>  ~/.irbrc  # adds line to irb resource file
	$ echo "#require 'irbtools/more'" >>  ~/.irbrc # we may uncomment this later
	$ echo "Hirb.enable" >>  ~/.irbrc # to auto-load the SQL-like formatting
	$ 
	$ # add gem and binding for `rails console` (per project basis):
	$ echo "# for nicer console formating:" >> Gemfile
	$ echo "gem 'irbtools', require: 'irbtools/binding'" >> Gemfile
	$ echo "#gem 'irbtools-more', require: 'irbtools/binding'" >> Gemfile
	$ 
	$ # add gem for better, SQL-like output from queries (per project basis): 
	$ echo "# for formated queries in rails c:" >> Gemfile
	$ echo "gem 'hirb'" >> Gemfile
	

If you are using a higher version of Ruby, you can use `irbtools-more` which added `did_you_mean` suggestions after receiving invalid input. For this you would uncomment those two lines with `more` and comment the ones without. If you ever want to go back to normal view of database queries in a particular `irb` or `rails console` session you can always type `Hirb.disable` and then to go back type `Hirb.enable`.  

To further unclutter output in the Ruby command lines you might want to silence printout of SQL that gets exectued you can type `ActiveRecord::Base.logger = nil` but beware that you might not notice problems happening without it. 



§

--------------------------------------------------------------------------------
## URL Routing 

These are just three of them:

1. Simple Route aka Match Route
2. Default Route
3. Root Route

Some of these handle only one URL, some handle many and are sort of "catch-alls". 
Note that routes are processed in the order that they appear in routes.rb. 
Generally, best practice dictates that you put specific things on top and 
catch-alls like the root route on the bottom. 

__Simple ( aka Match) Route__  

When you put in routes.rb: 

    get "ctrlName/actionName"

this is a simple route and it's actually shorthand for:

    match "ctrlName/actionName",
      :to => "ctrlName#actionName",
      :via => :get

The long version shows us that Rails is matching the string in the url to another 
string which represents the controller action pair and does this for GET requests. 
The two strings do not need to be exactly the same but when they are, the shorthand 
is available.

__Default Route__  

The Simple route handles a single, explicitly defined string url but often we want 
to target a number of requests without naming them all individually. 

Such is the case with Default Routes. A default route follows the form:

> :controller/:action/:id

And always in that order. For example, lets say we have something to let users 
edit something. We have a User controller with an edit action and each user has an 
integer id in the database. Here is how you would write a default route:

    match ':controller(/:action(/:id))', :via => :get

Note that these :symbols above are exactly as you would see in an actual example. 
`:controller` means "take whatever you get here and try it as a controller name."

The parenthesis are a bit like regex capture groups and indicated that they are 
optional; they don't have to be there, you could just ask for the controller and 
let the default action take over or ask for controller and action and not have an 
id. This way you could use the route to do other things like ask what user to lookup. 
The default action is `index`, meaning if the url ends in `/controller_name`, 
and you have an action defined called `index`, it will be called. 

There is a longer version of a Default Route that looks like this:

    match ':controller(/:action(/:id)(.:format))', :via => :get

where `:format` could be something like json for example. 

By the way, these are called "default routes" because older versions of Rails used 
to always have a default route at the bottom of routes.rb but now this is considered 
bad practice. 

Remember that, since default routes are a sort of catch-all, they should be 
placed lower on the routes.rb document!

__Root Route__  

The Root Route simply defines what to do when the site's root url gets a request:

    root :to => "demo#index"

We now have a shorthand which is:

    root "demo#index"

note that these use the `#` sign and not the `/` as is the case with simple routes.  

§  

--------------------------------------------------------------------------------

# MVC: View and Controller 
