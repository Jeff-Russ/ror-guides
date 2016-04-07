
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

The Simple route handles a single, explicitly define string url but often we want 
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

--------------------------------------------------------------------------------
## Controllers, Actions and Views

All the router needs to know is which action (really just a ruby method) to call 
and what controller (really just a Ruby class) it belongs to. Once the router 
hands off a request to a controller's action, the router's job is done. 

The controller#action's main job is to determine which view template to render. 
It also has the role of preparing variables for the view, fetching data from a 
database, calling helper methods, and other tasks but we won't consider those 
just yet. 

Each action has the default behavior of loading a view with name matching it's 
own name unless you specify otherwise. Note also that controllers are able to
load a request for a view __even if there is no matching action present__ in the 
controller class! Similarly, you can direct an action to a view not matching 
the request by overriding the default within the action. In this way, action names 
and view names are truely synonymous. What WON'T work is a request that can't 
find both a matching action or a matching view.

Even though the controller can render a view when even if it lacks an action for it, 
it's best practice to define one anyway, even if it is empty, purely for the sake of 
clarity. Empty actions are a very common practice and you will see them often. 
§

--------------------------------------------------------------------------------
### Renders and Redirects

__Renders__

If you would like to override the default rendering of a (same name) view from 
the action you can use:

    render(:template => 'other_controller/other_action_or_view')

Note that `other_action_or_view` might be either because you can have an 
action-less view file or you could have an action which winds up rendering a 
differently named view. (IS THIS TRUE??)

A __shorthand__ is available for the above. If you leave out the template key, 
Rails will see the string and assume it is a view template. Therefore this is 
the same:

    render('other_controller/other_action_or_view')

a further __shorthand__ is avaible if the view is in the same folder as the action's 
controller name. You can leave of the controller name in this case because Rails 
knows where to look:

    render('other_action_or_view')

Now, since this is a single call with a single arg, Ruby convention lets us type:

    render 'other_action_or_view'

__Redirects__

Even though a controller's main role is to render a view it can bypass this task 
completely with a redirect.  

Redirects are not exclusive to Rails or any framework, they are used everywhere 
as they are part of the HTTP specs. When you redirect someone, you send back an 
HTTP status code like this:

	HTTP/1.1 302 Found
	Location: http://www.example.com/controller/view

This message is very small and happens quickly but be aware that whatever 
data was fetched or set during the first request is gone once we get the 
second request. There are ways around this but they are more advanced usage of 
Rails. 

You might wonder why we would perform another round-trip with the client browser 
with a _redirect_ when we could just call another view with _render_. When we 
simply _render_, we still have the same code available and we might need something 
additional like user credentials or a cookie. We also might want to have the browser 
show a different URL, which is what happens after a _redirect_. Rather than mimicing 
a different request coming in, it's often better to just have that different request 
in the first place. 

__How to Redirect__

Here is an action called `gets_redirected`'s full definition:

	def gets_redirected
		redirect_to(:controller => 'other_controller', :action => 'other_action_or_view')
	end

If the controller is the same as the one you are currently in, you can skip the 
first argument. Note that you do not need to have matching view for `gets_redirected` 
because the action will never get to the point of asking for one. As soon as 
`redirect_to` is called, a new HTTP request is imminent and you will need an 
action called `other_action` to handle it. 

Since redirects are a part of the HTTP spec, the `redirect_to` method need not be 
used with a Rails routing, it can be used with an external web address as well. 

	redirect_to('http://www.google.com')
§

--------------------------------------------------------------------------------
### Views and Related Helpers

Nothing I don't already know. 

__Instance Variable__  

Nothing I don't already know. 

__Links__  

Not much I don't already know. 

__URL Parameters__  

good stuff. add later.
§

--------------------------------------------------------------------------------
# MVC: Models and the Database

--------------------------------------------------------------------------------
## Creating and Configuring Database

__Creating a Database__  

Let's go over how to create a database. You should know how to do this not just 
from within Rails using the Rails command but also according to how it would be 
done without Rails.  

__In mySQL__  

	CREATE DATABASE db_name; 
	SHOW DATABASES;          
	USE db_name;             
	DROP DATABASE db_name;   # deletes database

SKIP SKIP SKIP SKIP

__Configuring App to DB__  

The first step is, of course, to make sure you have the proper Gem installed for 
your chosen database technology. 

`config/database.yml` is the file you use to configure your database which is in 
YAML format. In YAML, Structure is shown through indentation (one or more spaces, 
but typically two). Sequence items are denoted by a dash (not shown below), and 
key value pairs within a map are separated by a colon. This shows our database 
setting for the rails development environment:  

	development:
	  adapter: mysql2
	  encoding: utf8
	  database: simple_cms_development
	  pool: 5
	  username: root
	  password: secretpassword
	  socket: /tmp/mysql.sock

The `adapter:` value will change depending on what database tech you are working 
with. The `database:` value is the database name, which defaults to the app name 
followed by and underscore and the environment name. If you set up your mySQL 
database manually, you will likely create a user specifically for this app which 
you should then set to the value of `username:` rather than `root`. The `password:` 
should of course match the password you created for the user.  
  
`socket:` is important because it's the file that Rails uses while connecting. 
This should be set automagically but if for any reason it does not, here is where 
you set it.  
  
To test your connection to the database you can do this in terminal:

	$ rake db:schema:dump

This has Rails connect to the database and export the schema in a new file 
`db/schema.rb`. If you don't get an error and you do see this file, you connected 
successfully. 

§

--------------------------------------------------------------------------------
## What is a RDMS?

The analogy of a database to a spreadsheet is helpful but incomplete. First the 
helpful part; If one were to arrange a spreadsheet as if it was a true database you 
would start with a horizontal row atop the spreadsheet with each cell labeling 
what kind of data goes below it in each column, i.e. first-name, last-name, address, etc.  

In a real database, each cell in the __column__ below the labling cell is if a 
particular data type, i.e. integer, string, etc) and only that type.  
  
Each __row__ refers to a different real-life object (person, product, etc) and 
is also sometimes (incorrectly, some say) called a __record__. 
  
The intersection of a row and a column is called a __field__ in databases.  
  
This entire structure is equivalent of a real database __table__. Typically a 
application has only one __database__ with many __tables__.  
  
What make Relational Databases Management System distict from spreadsheets is 
the __relational__ part. In a RDMS, one real live entity might have it's details 
listed in mulitiple tables which are linked together with __foreign keys__. We'll see 
more about foreign keys later but just know they provide a way of linking a row of 
data in one table to another. For example, we may have a table for contact info on 
people and another on medical history. A single patient has their data in multiple 
tables but within the tables cells there are references to other table rows in 
in order to link them together. This is helpful for organizing your database into 
smaller pieces rather than just having one big, unweildy table.  
  
Another thing that makes spreadsheets and RDMS different is __indexes__. An index 
on a RDMS table allows for rapid lookup of a record. In spreadsheets you are just 
looking things up with your own eyes but in a real database, lookups are often 
done in software and need to be blazing fast!  
§

--------------------------------------------------------------------------------
## What is Schema? Migration? Model?

__What are Schemas?__  

Getting back to the similarities, the term we use in RDMS for all of the labels 
without the data populated within it is the __schema__ the __schema__ is like the 
description of structure of the database. It's the setup you do to prepare a 
spreadsheet before you enter the tables. Rails has a way of abstracting this schema 
from the actual database's language into or Rails application. This means a few things, 
we can configure and use our database using Ruby language, using Rails classes and 
methods rather than using SQL code or whatever the database uses. It also (usually) 
means that we can define our database scheme without even choosing which database 
technology to use! In fact, we can use a small simple DBMS during production and 
then another one more suited to high traffic in our deployment, all without needing 
to change much or any of our code.  

To summarize, migrations are a blueprints that describe how the structure of you 
database is organized. On a more concrete level, your schema is stored as a single, 
auto-generated Ruby file in your application called `db/schema.rb`. This file is 
not the place where the database's scheme is _defined_ but instead can be thought 
of as a place where the schema is _documented_. If you want to actually modify the 
schema, the place to do that is from migration files as we shall see next. Migration 
files are a bit more scattered and are not the best place for the developer to 
get a birds-eye view of the database's struture the way `db/schema.rb` is.  


__What are Migrations?__  

Rails will use what it calls __migrations__ to automate the process of setting 
up your database's schema. The migration files are nothing more than Ruby Classes 
containing methods to set `up` changes or take them `down` (undo) and in fact 
can have two methods matching those names.

Each time a change is needed to the database's schema, a migration file is made 
and it's `up` method is called, which creates whatever tables, columns, etc are 
needed. The `down` method usually resemble the `up` methods with the order or 
instructions reversed.  

New in Rails version 3 was support for a method called `change` to be used instead 
of both `up` and `down`. Here, rails attempts to use the same method for both doing 
and undoing, by guessing how the method might be executed in reverse as is needed for 
undoing.  

The migration files are ordered by data created since often new features depend on 
old ones. Migrations also make it easy for multiple developers (who of course 
have their own local versions of the database in their respective production 
environments) to coordinate changes and revert them, if needed.  

To sumarize, __migrations__ define the methods executed and repeated to set up 
your database's schema. Their effect on the database are _reversable_. They keep 
the database schema in the realm of Ruby code instead of database languages like 
SQL. The allow for sharing between developers and version control without having 
to share an actual duplicate copy of a database.  

__What are Models?__  

Once we have migrations run we have a workable databases that can be accessed with 
the Ruby language, but our Rails apps need to actually interact (create, read, update and delete rows) via another part of RoR called __models__ models are not exclusive 
to Rails, they are the __M__ in __MVC__.  
  
In Rails

> one table = one model  
> each model/table is a single real-life noun (person, product, etc)  

Once we run migrations, their work is 
essentially done and models come into play as our messenger between the rails app 
and the database. Controllers will take user input from the view and put it into the 
database via the models. Likewise they can look at the data in the db via the model 
give it to the views for display to the user. Here is the acronym said by many, 
not just Rails folks, to outline the operations involed when working with a database:  

__CRUD__  
> Create  
> Read  
> Update  
> Delete  

Beyond the CRUD roles, Models also the appropriate place _process_ the incoming 
or outcoming data.  
§

--------------------------------------------------------------------------------
## Rails Naming Conventions 

Before we actually create some migrations lets get some naming conventions clear. 
Naming conventions matter a lot in Rails because Rails links the various parts of 
your app by filenames, classnames and tablenames. If you don't follow the conventions, 
these things will loose their connection. You can override these defaults with 
our own configuration but development will be faster and easier if we follow them. 

As you probably know, Class names are camelCase but starting with a capital (aka 
PascalCase) and method names are snake_case. This convention only applies to the 
actual code and not the file names. the file names are always snake\_case ( no 
capitals anywhere).  

Models are Classes and therefore follow PascaCase but, in addition to that, you 
should know that model names are SINGULAR as they define a SINGLE model for many 
instances. Any controller that refer to models in their name should do so in a 
plural form. For example, You many have a `User` model in file called 
`app/models/user.rb` and a controller called `UsersController` that sits in a
file called `app/controllers/users_controller.rb`.  

Table names although they are the database mirror of our Rails model, are 
snake\_case and pluralized; for example `invoice_items`, `orders`.  

Visit [here](http://itsignals.cascadia.com.au/?p=7)  and 
[here](http://alexander-clark.com/blog/rails-conventions-singular-or-plural/) 
for more naming conventions.  
§

--------------------------------------------------------------------------------
## Generating Models and Migrations

The first time you create a model you will need both the model .rb file and at 
least one migration .rb file. Subsequent changes to the model do not require more 
model files but SHOULD involve you modifing the database by creating more migration 
files rather than modifying pre-existing ones. For this reason, when you run: 
`rails generate model` it will create both the model and migration files. You also 
have the option of `rails generate migration` which will generate a migration file 
but not a model file. (note that there is an alias for `generate` which is just `g`).  
§

--------------------------------------------------------------------------------
## Naming Conventions with Generate

It's important to realize that all `generate` is doing is generating file and 
filenames. It's not doing anything magical like linking them together. It's the 
names of each item that leads to them being linked. One could create all the 
files and, if named properly, the end result would be the same as if `generate` 
was used. 

When you run `rails generate` + __something__, rails will make filenames, 
classnames and sometimes method names. Since naming conventions for these three 
do not mirror each other, the `rails generate` command can accept PascalCase or 
snake\_case and will adjust the result according to Rails naming conventions. 

When it comes to the issue of plural vs singular, The command you type should 
adhere to the conventions. For example. You are generating a user model you can 
type `rails g model User` or `rails g model user` but don't type the plural 
versions of these.

In contrast, if you are working with __migrations__ for these you should use the 
__pluralized__ versions. For example, `rails g migration ModifyUsers` or 
`rails g migration modify_users`. 
§

--------------------------------------------------------------------------------
## Object Relational Mapping 

It may seems obvious but Ruby and SQL are vastly different languages, each with 
different concept and implimentation of an "object." The goal of Object-Relational 
Mapping (ORM) is to serve as a bridge between these two. Our app has Ruby 
objects which should mirror the "objects" in the database. Rails has several 
Ruby classes that contruct this bridge.  

__ActiveRecord::Base__ (aka "ActiveRecord") is the M in MVC. It's name come 
from the design pattern called __active record pattern__ which was outlined by 
Martin Fowler before Rails existed in 2003. It specifies that database tables or 
views are wrapped into a class. Thus, an object instance is tied to a single row 
in the table. ActiveRecord (in PascalCase) is the Rails implimentation of the 
active record pattern. The ActiveRecord class facilites the creation of objects 
which are tied to our database and allows us to extend a static database to have 
business logic, processed within our application code. In this way, ActiveRecord 
not only preforms CRUD on the database, it makes it intelligent.  

Remember that each model names matches a table name. Also note that a model is really 
just a Ruby class. ActiveRecord lets us create a new row in the table by 
instantiating an object from the model's class 

	DATABASE    RAILS                       Example
	
	table       Model's class               User
	row         object from Model's class   user = User.new
	column      object attribute's name     user.first_name
	field       object attribute's value    user.first_name = "Jeff"
	INSERT      call .save method on obj    user.save
	field       attribute's value changed   user.first_name = "Geoff"
	UPDATE      call .save method again     user.save
	DELETE      call .delete method on obj  user.delete


Note that Rails was smart enough to know the second call to the save method 
should actually run UPDATE in SQL instead of INSERT since data is already present. 

When we use `generate model User`, our user.rb file has boilerplate code with a 
class inheriting from `ActiveRecord::Base`, making it an __"ActiveRecord Model"__. 
This makes our model database-ready. You could also create a model file manually 
if you don't want a matching database migration file. In this case you would not 
need the `< ActiveRecord::Base` inheritance in your model file. But be aware that 
the inheritance gives us a lot. Without it we will be missing all the attribute 
accessors corresponding to data on the database and would have to put them all in 
one by one. If you have a table with 75 columns this is a lot of work. Rails will 
invisibly add and update all of this behind the scenes if we follow Rails conventions.  

__ActiveRecord::Relation__ (aka "Active Relation" or "ARel") was added in Rails 
version 3. The line between ActiveRecord and Active Relation is a bit blurred. 
Many things you do in ActiveRecord::Base actually rely heavily on 
ActiveRecord::Relation. ARel uses relational algebra to simplify the generation 
of complex database queries. Small queries can be chained like we see in Ruby 
objects. ARel is used for things like joins and aggregations, using efficient 
SQL and timed executions which wait until the actual query is needed. 
§

--------------------------------------------------------------------------------
# Migration Basics

--------------------------------------------------------------------------------
## Adding / Removing Tables & Columns

__Adding / Removing Tables__  

It's helpful to fill out your migration the long way using `up` and `down` before 
relying the shortcut `change` method. Here we  use `rails g model User` and we get:

	class CreateUsers < ActiveRecord::Migration
	  def change
	    create_table( :users ) do |t|
	    
	    t.timestamps
	  end
	end
	

Here we see the `create_table` method which is used to create a database table we 
are calling `:users`. This Ruby symbol `:users` is notably plural (as tables are) 
as opposed to Models (singular). `t` is the actual table, to which we are adding 
attributes via a Ruby `do` block. 

	class CreateUsers < ActiveRecord::Migration
	
	  def change
	    create_table( :users ) do |t|
	    
	    t.timestamps
	  end
	  
	  def down
	    drop_table :users
	  end
	  
	end

Now we have a new method called `drop_table` which is the opposite of `create_table`. 
It is not in block form the way `create_table` because it doesn't need to know 
anything about the table in order to delete it. As a side note, notice we added 
parenthesis to the argument in `create_table`. As a matter of style, this guide 
will use parentheis for arguments in method calls when they are in block form. 

__Adding Columns__  

The create\_table block accepts two ways to add columns to a database. Here is one:

	t.column "first_name", :string

This creates a table column of a data-type known to Ruby as a string but might be 
called any number of things in the actual database itself. We don't exactly HAVE 
to know how it's done directly in the database, using SQL code (or whatever the DB is 
based on) at this stage because Rails is handling this for us when we eventually 
run the migration. We need a label for the column which here we use the string 
literal `"first_name"`. note that `t.columns` can take a third argument for 
__options__: 

	t.column "label_name", :data_type, options

Now for the shorter form:

	t.data_type "label_name", options

This is the version you will see in wild more often but you should be familiar 
with both since sometimes you will not have this optional shorter version available. 
§

--------------------------------------------------------------------------------
## Data-Types and Options

Rails defines a number or data-types which it then translates to the data-types 
native to your chosen database technology:

	binary    boolean
	
	text      string
	
	date      datetime    time
	
	integer   float       decimal

Much like how SQL has clauses to `LIMIT` number of character, set `DEFAULT` 
values and more, Rails has equivalents it calls __"options"__:

	:limit		=>	size
	
	:default	=>	value
	
	:null		=>	true/false
	
	:precision	=>	number
	
	:scale		=>	number

Rails will actually generate a sensible default for each one of these so you don't
have to set them unless you want to override the defaults. Looking at an example, 
if we have a `user_name` that we want to have a limit of 10 character:

	t.column "user_name", :string, :limit => 10

We can shorten it as seen above, and then further to use newer Ruby hash syntax:

	t.string "user_name", :limit => 10
	
	# new hash syntax:
	t.string "user_name", limit: 10

__Timestamps__  

Rails is, in a sense, waiting for us to possibly put these two columns in:

	t.datetime "created_at"
	t.datetime "updated_at"

When Rails sees these it will automatically update and populate them for us 
whenever a row is created or updated. You don't need to do anything additional. 
The shorthand for these two is:

	t.timestamps

If you put this one line in, Rails essentially replaces it with the two lines 
seen before. 

__ID__  

Note that Rails will always create an id, an __auto-incrementing primary key__ 
with the data type __integer__, for each table since this is something you will 
almost always need. 
§

--------------------------------------------------------------------------------
## Running Basic Migrations

To run the migration, execute this command at the __root of your project__:

	$ rake db:migrate

By running this without a second argument, you are essentially running 
`rake db:migrate RAILS_ENV=development` since that is the default. Note that this 
runs __all migrations that have not yet been run__.  

__Verify Changes on Database__  

At this point you can verify it worked by going into your database's command 
line and checking (with `SHOW TABLES;` then perhaps `SHOW FIELDS FROM users;`, 
for example). You should see everything you specified plus the `id` integer that 
is automatically added. This is a good place to observe Rail's default options for 
all of the fields you specified as well as __id__.

Something else you can verify from your respective database's command line is the 
list of migrations that were run. In mySQL you can type:

	SELECT * FROM schema_migrations;

and you will see each migration _file_ that went into the current state (schema) 
of your database. They are listed by the long integer timestamp prefixes seen 
in the filename of each .rb file used for the migration(s). This is a good way 
to check the state (schema) of the database from the database's perspective. This 
`schema_migrations` table is managed by Rails and you typically will not (or 
should not) make any changes to it directly. 

__Verify Changes from Rails app__  

After running the migration, not only will your database change but the `db/schema.rb` 
file in your application will change to reflect the migration as well. If all went 
well, the `schema.rb` file should reflect exactly what you see on the database 
itself. 

If you want to roll back your database to it's pristine state, before any migrations:  

	$ rake db:migrate VERSION=0

`VERSION=0` is another environment variable representing the state of the database 
before any migrations. __All environment variables must be ALL\_CAPS__, this is 
very important. 

Now if you run `SHOW TABLES;` you will those tables added are no longer there. 
Also, if you run `SELECT * FROM schema_migrations;` you will see that that table 
is now empty. 
§

--------------------------------------------------------------------------------
## Running Specific Migrations

Run this to see a report of the current state of migrations:

	$ rake db:migrate:status

This will list each migration file by it's integer timestamp and status of each 
as either __up__ or __down__. This list is a good reference from which you can 
grab the long integer timestamps and use them in the `VERSION` environmental 
variables for migration commands. For example:

	$ rake db:migrate VERSION=xxxxxxxxxxxxxx

This will run only that migration and nothing else. If you run a full migration 
after this, it will run all the other migrations. (EVEN ONES BEFORE IT??). Then 
if you re-run the specific version migration again it will take the additional 
ones back down but it will not un-run the one specified. __this all seems incomplete!!__

there is also 

	db:migrate                   # run all migration files not yet run, in order
	                             
	db:migrate:up   VERSION=num  # runs up for specific migration file
	                             
	db:migrate:down VERSION=num  # runs down for specific migration file
	                             
	db:migrate:redo VERSION=num  # runs down then up for specific migration file
	                             
	db:migrate:redo              # assumes VERSION is LAST migration
	                             
	db:rollback	                 # rollback last run migration(i.e. Default STEP=1)
	                             
	db:rollback STEP=4           # rollback last 4 migrations.
§

--------------------------------------------------------------------------------
## Migration Methods

Within our migration files we have various methods available to us in addition to 
`create_table` and `drop_table` which we have already seen:

TABLE METHODS:
	
	create_table( table, options ) { |t| ...columns... }
	
	drop_table( table )
	
	rename_table( table, new_name ) 

NOTE: The two args for `rename_table`, if placed in a `change` definition, NOT 
`up` or `down`, are reversed by Rails if you undo the migration in the command line. 
If you have this method inside and `up` method then you will need to swap the args 
manually in the `down` method. 
	

COLUMN METHODS:

	add_column    (table, column, new_name) # short syntax unavailable
	
	remove_column (table, column)
	
	rename_column (table, column)
	
	change_column (table, column, type, options) # change def/options without removal

NOTE: `rename_column` has the same arg reversal behaivor as `rename_table`.

INDEX METHODS:

	add_index    (table, column, options)
	
	remove_index (table, column)

In the above, `column` can be an array of column names. Also note that `options` 
can be 

	:unique => true/false
	
	:name => "your_custom_name"

RAW SQL METHOD:

	execute ("any SQL string")

DANGER: This, of course, only works with SQL and Rails will not alter your input 
in any way to fit the particular flavor of SQL being used!  

When you create a migration file that is meant to alter a pre-existing table, 
you should name it such that it's purpose is apparent, like `change_users` or 
`alter_users`. You will often want to plant a few `puts` into your `up` and `down` 
methods so that when you run the migrations you can be reminded of what is going 
on.  

Whenever you create a new migration you should test not only it's `up` functionality 
but it's `down`. It's much better to catch mistakes before the database is actually 
populated with real data!!
§

--------------------------------------------------------------------------------
## When Things Go Wrong 

Migrations can be stuck in a broken state where you can't run `up` or `down` if 
you're not careful. For example, you could have `delete_column` for column names 
that don't exit at a given point. This might seem like an easy typo to fix but 
sometimes if custom migrations are run, you might not have forseen that point 
in time. When things like this happen you will see the dreaded:

	rake aborted!

To complicate things further, failed migrations are still partially executed. 
This means that if you go in and fix and typo then try to run it again you will 
could get another due to the partial migration that already occured!! Then trying 
to completely roll back to `VERSION=0` fails because you might have missing tables 
or columns refered to in one or more `down` methods!!  

At this point we are pretty trapped and there are several ways to get out. One 
way would be to go into your database using it's own interface and edit it to 
the schema as seen by Rails.  

The other, and much easier, way would be to comment out the portion of offending 
migration that was ran so that all the remains is what didn't yet run. 

All of this needs to be ironed out before you deploy. Fixing a problem on a development 
database is one thing but in production it will mean often mean a serious loss of 
data. Keep your migration files small, with each only addressing a single table 
if you can. TEST EVERYTHING THOROUGHLY before deploying any part of your database, 
especially when those parts are available to be populated with actual data!  

__Linking Model names to Table Names__  
Sometimes you might have legacy code that does not follow naming conventions, or 
perhaps a migration changed a Table name and the model class still matches the old, 
now deleted tablename. You can, within your model class, point it to any tablename 
with:  

	self.table_name = "new_name"

And with that it will be fixed. Of course you could also just rename the model.rb 
file and the classname within it.  
§

--------------------------------------------------------------------------------
# Introducing Our Example Database

--------------------------------------------------------------------------------

It's sometimes hard to understand database concepts without a concrete example. 
For that reason let's choose the example of a high school's database for our 
database Schema. Let's start by thinking of the main "objects" that are at play 
in a high school we have a classrooms, teachers, courses and students. We won't 
consider the student's grades at the moment, just the their enrollments and the 
details of each course in terms of where it is and who is teaching it. 

Each of these things is actually a Model in the strictest sense of the word; they 
are Ruby classes in Rails, each representing A single table. The relationship between 
these tables is obviously inter-related and for that reason we need to introduction 
some details about the "relational" part or relational databases.  

§

--------------------------------------------------------------------------------
## Database "Relationships" are Rails "Associations"  

Let's think of our example of the high school. Assume each teacher has only one 
classroom and each classroom has only one teacher. Both the classroom and it's 
teacher have many courses it teaches. Students freely pass between different 
classrooms taking different courses but teachers stay in their respective rooms.  

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_associations.png)  

Obvously this is not showing the full school, there are more than one classroom 
and many teachers, but this encapsulates the details of the relationships, or 
"assocations" as they are called in Rails, between the Models.  

Now to consider the more concrete aspects of our chart in action, the Model class 
defines the structure of the database tables. ___TO CLARIFY,__ although "one model 
equals one table" that does not mean that the two are synonymous. The objects 
created from the Model class are each a row in the table that the Model class 
defines. In other words, the table in the database is really the Model class plus 
all of the objects created with the Model class. In this sense, the Model class is 
the table's schema and the object's attributes are the data.  

Now getting back to the topic of associations, the tables themselves have special 
columns just for the __foreign keys__ that link each row (Model instance) to a 
row sitting in another table. The other table has what's called a __primary key__ 
which matches the the foreign key and completes the connection between the two 
tables for a given row. 

With the `Classroom` and `Teacher` models, we will learn about the so called 
"__One-to-one__" relationship, which is the simplest relatinship you can have. 
Each row in the `teachers` table will have __foreign key__ to link it to a classroom, 
thus making this table reponsible for "knowing" about it's relationship to the 
`teachers` table. In "__one-to-one__" relationships it's generally a design choice
as to which table holds the foreign key. In Rails, the records (rows) with foreign 
key are said to "__belong to__" those in the other table so one might choose based on 
what conceptually feel right. Think of the table with the foreign key as the 
__child table__ and the table referred to as the __parent table__. Just like with 
OOP, the child knows about the parent but the parent doesn't necessarily know about 
the child.  

With the `Teacher` and `Course` models, we will learn a little bit about the so
called "__One-to-many__" relationship. Here, the Course should be the side that 
holds the __foreign key__ since. If it was the Teacher side that held it, the 
`teachers` table would need a new row each time a teacher was assigned to a new 
course. Since each course will only ever have ONE teacher, it makes sense to give 
it that key since it's schema won't need adjustment each time there is a new course 
assignment.   

We will ignore the `Student` model for now since that __Many-to-many__ relationship 
is a lot more complicated. They make use of a third table called a "__JOIN__" which 
handles the complex network of relationships rather than having the two tables handle 
them themselves. I'm sure you can tell by the pictorial why one might want to 
bring in something else to handle that messy network of connections.  
§

--------------------------------------------------------------------------------
## Coding our Example 

Here is the game plan for migrations as pseudocode:   

	Classroom: room_num(integer),  lab_equip(boolean),  permalink(string) 
	Teacher:   first_name(string), last_name(string),   classroom_id(integer) 
	Course:    name(string),       description(text),   teacher_id(integer), 

`permalink` is a reference to a URL string that is a web page devoted 
to the classroom. This doesn't really make sense in the real world example but 
it here just for demonstration purposes. we will give it an __index__ to 
__speed up the lookup__ of the URL. (the integer index is not shown above)  

An __index__ is similar to a __key__ in that they are both integers for used 
for identification purposes. A __key__ holds an integer which is a unique 
identifier to and is not meant to be changed later as it might be referenced 
in multiple places. An __index__ IS changable and used for for grouping of 
data and as a "handle" for __rapid lookup__. __All foreign keys must also__ 
__have an index!__

In addition to this __index__, we'll also have two __foreign keys__. Above, 
`classroom_id` and `teacher_id` are the foreign keys. These and all integer
foreign keys also have integer __indexes__ (not shown above).

`description ` is a biography of the teacher and since it's potentially very 
lengthy, it's stored as `text` instead of a `string`.  

Let's do it:  

	$ rails generate model Classroom

Here is the generated migration file. Notice that the __migration class__ 
__names are plural!__ and, since this is the first time dealing with 
the classrooms table, Rails knows we are creating it and prepends the class 
name with `Create`.  

	class CreateTeachers < ActiveRecord::Migration
	  def change
	    create_table( :teachers ) do |t|
	
	      t.timestamps  # you see instead: `t.timestamps null: false`
	    end
	  end
	end


We could use the `change` method but for the sake of learning, let's separate 
it into `up` and `down`. Here is the `CreateClassrooms` class in it's final 
state with everything added:  

	class CreateClassrooms < ActiveRecord::Migration
	  def up
	    create_table( :classrooms ) do |t|
		  t.integer "room_num"
		  t.boolean "lab_equip", default: false
		  t.string "permalink"
		  
		  t.timestamps
	    end
	    add_index("classrooms", "permalink")
	  end
	 
	  def down
	    drop_table :classrooms
	  end
	end

We added `default: false` since most classrooms are not lab equipped. 

There is a `permalink` string but also there is an index with the same name. 
Also note that the `permalink` index, and in fact __all indexes, must be created__
__outside of the call to create\_table!__ The `drop_table :teachers` is all we 
need to to drop the added columns as well as the indexes since they are in fact 
also parts of the table.  

We really didn't have to do anything unexpected with the `down` method. In this 
case, when `drop_table` just executes `create_table` but in reverse, flipping the 
implied `add_column` methods to `remove_column`. We could just rename `up` back 
to to `change` and delete the `down` method and everything would work fine in 
since we are only ADDING columns to the table. 

__REMEMBER:__ `create_table` is reversable because the `add_column` method 
is __reversable__. The `remove_column` method is __NOT reversable__. The reason 
for this is that when you add a column, you provide the full definition for it. 
`remove_column` doesn't need the full definition but `add_column` does. Rails 
cannot invert `remove_column` to `add_column` because it lacks the full definition 
needed to create a column!    

	$ rails generate model Teacher
	
No let's move on to the __teachers__ table, where we we'll keep it simple and
just use `change`: 


	class CreateTeachers < ActiveRecord::Migration
	  def change
	    create_table( :teachers ) do |t|
	      t.integer "classroom_id"  # same as: t.references :classroom
	      t.string "first_name"
	      t.string "last_name"
	      
	      t.timestamps
	    ends
	    add_index("teachers", "classroom_id")
	  end
	end
	
The adding the foreign key is done in the `create_table` block. There are two 
acceptable syntaxes for this as you can see in the comment. Remember that __All__ 
__foreign keys also need an index__ so you can see that being creating, again, 
outside the call to `create_table`.  

Let's create the Model/Migration for `Course` using another even quicker way. 
Rails lets you include the desired columns right in the Rails `generate` command!  

	$ rails g model Course teacher:references, name:string, description:text, teacher_id:integer:index

The synax for this is `column_name:type, column_name:type,` etc. You can also add 
and index for the foreign key with `parentname_id:integer:index` or in fact any 
index with `indexname_id:type:index` but beware of non-integer indexes!  

As seen before also could have choosen `teacher_id:integer` which makes the 
foreign key naming obvious and explicit but we choose the newer, abstracted 
`references` syntax introduced in Rails 4 to create the index for our foreign 
key.  

Here is what our command generated:  

	class CreateCourses < ActiveRecord::Migration
	  def change
	    create_table( :courses ) do |t|
	      t.references, :teacher
	      t.string, :name
	      t.text, :description
	      t.integer :teacher_id
	
	      t.timestamps null: false
	    end
	    add_index( :courses, :teacher_id )
	  end
	end

As you can see, this longer generate command really cut down on our development  time!  
§

--------------------------------------------------------------------------------
# CRUDing Records with ActiveRecord

--------------------------------------------------------------------------------

The following examples will be show in the __rails console__ since it gives us 
some nice feedback on what we're doing but keep in mind that the same syntax is 
valid in Ruby code elsewhere. Also not that, contrary to methods given to us in 
ARel, perform their action immediately. 
§

--------------------------------------------------------------------------------
## New & Create  

	$ rails console             # enter the Rails Console
	> teacher = Teacher.new     # create object called teacher in temp. memory 
	> teacher.new_record?       # returns true if teacher did not already exist 
	> teacher.first_name = "Jo" # set first_name attr. to "Jo" in temp. memory 
	> teacher.first_name        # prints out "Jo"
	> teacher.new_record?       # returns true because we haven't saved yet
	> teacher.save              # generates and runs SQL or whatever you are using
	> teacher.new_record?       # now we will see false
	> teacher.id                # prints the newly created integer id. 

__Using Mass Assignment__  

This is the long way to do things. We could have sent in values at the time of 
instantiation as aruguments to the constructor. The `new` constructor takes 
`:symbol => value` pairs as arguments. You could populate the entire record 
(row) with on line in the Rails Console (known as __"Mass Assignment"__). 
You don't have to provide all the attributes, you can provide just the ones 
you want and let the defaults handle the rest. This only works if they actually 
do have defaults; you can set an attribute to reject not having it's value 
explicitly set as we will see later on with __"validations"__.  

One handy fact is that `teacher.save` returns true if it was sucessful so we 
can make it the condition of an `if` statement for error handling. If the 
data entered does not meet the requirements of your model or the database, 
false will be returned.  

__Using Quickest Way__  

We used mass assignment with the `new` method, which then requires us to run 
`save` but we have another option of using `create` instead of `new`, which does 
not require `save` afterward. Unlike `save`, `create` does not return a boolean, 
it returns the object just like `new` does so we'll need to find out if it was 
successful by other means.  
§

--------------------------------------------------------------------------------
## Find/Save & Find/Update Attributes  

Your model's class has a class method called `find` which takes and id (aka 
the primary key) as argument and returns the appropriate record's object.   

	> teacher = Teacher.find(1) # runs SELECT
		=> all...the...data...
	> teacher.new_record? 
		=> false
	> teacher.first_name = "Bob" 
	> teacher.save   # This will run UPDATE because it's not a new record
		=> all...the...new...data... 

__Using Mass Assignment__  

After you run find and get the object, you can use the `update_attributes` method 
with all of your attributes as arguments, in the same way as you would with `new` 
only this is with a pre-existing record. Since we already have the object, 
`update_attributes` can return a boolean instead of the object, so we can use that 
for verifying the operation was successful.  

§

--------------------------------------------------------------------------------
## Find/Destroy Records  

Notice the title says "destroy records" and not "delete records". There is a 
`delete` method bypasses some Rails features and will not behaive as you expect 
so it's better to use the `destroy` method. After you run find:  

	> teacher.destroy # runs DELETE on actual database only
		=> you'll see a "frozen hash" here

The hash still sits in memory even though it was deleted from the database. 
It's is "frozen" which means you can't edit it but you can use this object and 
it's frozen hash to display information on what was deleted to the user or 
something else, which could be handy.  

NOTE that whatever id was used by the deleted record is then abandoned. Future 
records will not take over this id integer but rather then will just increment 
the last id, whether or not it still exists.  
§

--------------------------------------------------------------------------------
# Database Finders & Queries  

--------------------------------------------------------------------------------

Most of your interaction with the database via Rails will actually be queries. 
For that reason, Rails provides more than one way to do this.  

Remember the distinction between normal __ActiveRecord__ and what has been called 
__ARel__ outlined before. When it comes to making queries to the database, you have 
a choice between these two . The former includes methods like `find` and the various 
`find_by` methods we will see next. They execute a single statement of SQL and do 
so immediately. The later include methods like `where` which are used to gradually 
"compose" a complex SQL queries until the time comes to run it.  

Be aware that many `find_by` methods are deprecated, about to be removed or 
simply neglected in favor of the newer ARel Query methods. This guide tries to 
stick to only the common `find_by` methods but don't be surprised if one or more 
methods are removed by the time you read this.  
§

--------------------------------------------------------------------------------
## ActiveRecord Finders (not ARel)

Note that `find` is often not the ideal choice. The reason for this is that when 
it fails, it returns a severe error called `ActiveRecord::RecordNotFound` which 
usually results in a __404__ page to the user. Therefore you should only use `find` 
if you really are sure that the object exists, which by the way is not unusual.  

Our alternative is __"Dynamic Finders"__. The dynamic finder for id (primary keys) 
is `find_by_id` and they are others for different attributes. Unlike `find`, dynamic 
finders don't return and error, they return `nil` which is much easier to deal with. 
When they are sucessful, they return the record object. The reason they are called 
dynamic is that Rails creates one for each attribute in the model:  

	object = Model.find_by_attributename(value)

If more than one match is found, it will return the first one that it finds.  
  
We also have:  

	all   = Teacher.all     # returns nil or an array of every record
	first = Teacher.first   # returns nil or the first record
	last  = Teacher.last    # returns nil of the first record
§

--------------------------------------------------------------------------------
## ActiveRecord::QueryMethods (ARel)  

As you already know, ARel queries wait until they are needed before actually being 
performed. __Query Methods__ don't return an array like ActiveRecord does, they 
return an __Relation Object__, which can then be chained together with 
other query methods and when you are done, Active Relation will take them all 
and construct one big SQL statement. This way it's much more efficient.  

### The `where` Query Method  

`where` is one such query method and is named after the SQL `WHERE` clause it 
generates. If you execute this in the  __Rails Console__, you will actually see 
the resulting SQL printing back to you even though it wasn't run in the database 
yet. You can also see the resulting SQL via the __Relation Object__ it returned 
if you call `.to_sql` on it. Chaining is possible like this:

	relation_object = Model.where(conditions).where(conditions)

But often you can can just have multiple conditions in one `where` call's argument 
instead with the exact same results. Even when there is only one possible match, 
you still get an array. You can force it into not being an array with `first`: 

	relation_object = Model.where(:id => 1).first

And then you don't have an array. Note that the above has the hash style argument. 
There are three possible arugument styles:  

1. __where with STRING... `Model.where(raw_SQL_string)`__  
   __BEWARE__ of how you use `where` when taking __raw SQL string__ because 
   it invites the possibility of __SQL Injection__. If you give the user control 
   of even a part of this string they could abuse it to insert malicious code. 
   You should generally only use hard-coded strings that take no user input either 
   directly or from data in the database that might have originated from user input. 
   Even though the example below looks as if the string in the argument is Ruby, 
   it's actually SQL (remember that model's attributes and their values are actually 
   in hash syntax in Rails, not using an equal sign assignment operator)  
   
		relation_object = Client.where("orders_count = '2'")
   
   This is actually a conditional statement, at least in the resulting SQL, where 
   it evaluated as true when `orders_count = '2'` Within these strings, you can 
   insert variables using Ruby's string interpolation like `"orders_count = #{var}"` 
   and, depending on how that `var` is set, this could be where the danger lies.  
   
2. __where with ARRAY... `Model.where(template_w_placeholders, inserts...)`__  
   The alternative to using a full SQL string is to use an __array__. The first 
   element of the array is a __template__ that contains portions of SQL together 
   with __placeholders__. The remaining element(s) are the inserts for the 
   placeholders. This array argument way is safer because Rails has a 
   chance to escape the inserted SQL before running it.  
   
		relation_object = Client.where(["orders_count = ?", 2])
   
   The square brackets here are actually optional, either way it will be 
   interpreted as an array. The question mark `?` is the placeholder and `2` will 
   be inserted in it.  
   
3. __where with HASH... `Model.where(hash_as_condition)`__  
   This option also provides safe SQL escaping and is a simpler approach compared 
   to both strings and arrays. Each key-value pair will be joined by an SQL 
   `AND` before generating the SQL `WHERE` clause.   
   
		relation_object = Client.where(:orders_count => 2)
   
   This is just one condition but you can actualy have many, separated by commas.  

### Other Query Methods 

`where` is the most powerful query method but there are several others:  

	order(sql_fragment) # sort results alphabetically, reverse, etc  
	limit(integer)      # limit the number of results to `integer`  
	offset(integer)     # skip first `integer` result. example: see records 20 to end  

These are all chainable with each other and `where`. The order of the chaining 
doesn't _usually_ matter  

__Syntax for sql_fragment in `order` Method's Argument__  

The format for this argument roughly follows `table_name.column_name ASC /DESC`. 
Since we are calling `order` on a Model which essentially IS a table, we often 
do not need the `table_name` part of this argument. It's not necessary for for 
single tables but it is recommended for joined tables and REQUIRED when joined 
tables have the same column name. So if you have a `users` table joined to a 
`login_password` table you might want to specify where `name` is:

	User.where(:account => "pro").order("users.name ASC")

This will find all pro users and sort them in ascending order by name as it 
appears in the users table. You can also have multiple arguments: 

	User.where(:account => "pro").order("users.visible DESC, users.name ASC") 

§

--------------------------------------------------------------------------------
## Custom Queries with Named Scopes

So far we have interacted with the database with methods provided to us by the 
Rails Framework. We didn't need add any functionality to our Models in order 
to perform these queries and other CRUD operations. We also have __Named Scopes__, 
which allow us to define custom queries in our models using multiple 
__Active Relation query methods__. Our resulting __Named Scopes__ can be called 
taking arguments just like pre-existing Rails methods. Prior to Rails 4, 
__Lamda Syntax__ was option in them but now it's required.  

This is roughly how you define a scope in your model:

	scope :name_of_scope, lambda {where(:active => true )}

Scopes are placed in your Model file class and most people put them before any 
method `def` blocks.   

You can use __"Stabby Lambda Syntax__, but be aware there are actually 
some subtle implementation differences so we won't be using this:  

	scope :name_of_scope, -> {where(:active => true )}

Be aware that these both are really identical to just creating a class method 
like below. They are just a little nicer syntax to work with.

	def ModelName.name_of_scope
	  where(:active => true )
	end

The reason why lambda syntax is now required is that lambda are evaluated 
when they are called and not when they are defined. This matters when you 
use things like `Time.now` since you want that to be evaluated each time 
the lambda is called. This created a lot of errors and confusion to lambdas 
were made a requirement.   
	
__Named Scopes Taking Arguments__  

Here is the scope taking an argument. Note that this is one case where the 
__Stabby Sytax__ would not be the same:  

	scope :account, lambda {|acc_type| where(:account_type => acc_type )}
	
This would be called like: `User.account('pro')`  

__Named Scoped can be chained when they are called__ and can also have 
chainging within them, making for some really compacted sytax that would 
otherwise be a quite verbose set of queries.   

§

--------------------------------------------------------------------------------
# Database Associations

--------------------------------------------------------------------------------

Relational databases make it easy to link tables together using __foreign keys__ 
and __joins__. If you want to work with data in related tables you could go about 
that by looking at a record's foreign key and then finding the related data by 
making a second query to to the related table but this is a bit tedious. It 
would be best if our Ruby side of things had prior knowledge about the 
relationships between tables and in fact it does. __ActiveRecord__ has what it 
calls __associations__ that are used to define relationships between data in 
separate tables.  

§

--------------------------------------------------------------------------------
## Associations In Our Example 

__INSERT STUFF__

Let's first look at how the relationships are conceived of in RDBMS and in Rails. 
There are three main __types of data model relationships__:  
>
* __One-to-one__, abbrevated as __1:1__   
   example: __classroom:teacher__ or __teacher:classroom__
	* each classroom `has_one :teacher` (reversible)
	* each teacher `belongs_to :classroom` (reversible)
	* foreign key goes on the `teacher` table (reversible)
	<br><br>
* __One-to-many__, abbrevated as __1:m__  
   example: __teacher:courses__
	* each teacher `has_many :courses`
	* each course `belongs_to :teacher`
	* the foreign keys __MUST__ go on the `courses` tables 
	<br><br>
* __Many-to-many__, abbrevated as __m:m__   
example: __students\<JOIN\>courses__
	* a course `  :students`
	* a student `has_and_belongs_to_many :courses`
	* this must be a __JOIN__ since we have two foreign keys 

Your first observation of this should take note that whenever you see 
`belongs_to`, you also see __foreign key__. Whatever side does belongs to
something else is the side with a foreign key in it's table. The _sort of_ 
exception to this is Many-to-many, where the foreign keys are actually 
stored in a third table called a __JOIN__ which we shall see later.  

The second observation should be that the One-to-One relationship says 
(reversible) this means that either side can be the keeper of the 
foreign key and have the `belongs_to` method.  

One-to-Many is not reversible and the many is the side that is the keeper 
of the foreign keya and has the `belongs_to` method.  

Keep this example in your memory and/or refer back to it as we will need it 
in future sections.   

__Rails Associations Methods__

The method `has_and_belongs_to_many` is used for this many-to-many and is 
over spoken of as "the HABTN method." It's essentially both `has_many` and 
`belongs_to` rolled into one. These, together with `has_one` make up the 
four macro-like methods for database associations provided to us by the Rails 
framework. They all accept symbols repesenting the models as arguments. Here 
are some things things to adhere to: 


* Each symbol has a plural form which must be used if appropriate
* Both sides should have have their associations specified
* The `belongs_to` side should have the foreign key
* The method declarations should be in the model class, often at the top 

§

--------------------------------------------------------------------------------
## One-to-One Relationships

__As Per Our Classroom Example:__  

This is the easiest relationship to understand and set up. You have two single 
objects connect to each other: __classroom and teacher__. You have a choice to 
set this up in either direction: with classroom `belongs_to` teacher or teacher 
`belongs_to` classroom. It usually makes no difference in practice and is just 
a conceptual preference.  

However, you must note the fact that the __foreign key is stored with__ 
__the object that__ `belongs_to` __and not the one that__ `has_one`. If we 
decided to have classrooms `belongs_to` their teacher, we could do this but we 
would put the foreign key on the classrooms table and then set up the classroom 
model to `has_one` teacher. 

The reason for this will be clear when you see the __One-to-many__ relationship 
which also follows this rule. 

__When Should we Use One-to-One Relationships?__  

One-to-one Relationships are __used to reject the possiblity of anything__ 
__other than mutually unique ownership between to entities.__ For example, a US 
citizen has one and only one Social Security number and each SS number can only 
belong to (or be belonged to by) one citizen. Knowing that this will never 
change makes using a one-to-one relationships with person having 
`has_one :ss_number` ss_number having `has_one :person`. Whichever one has 
`belongs_to` also has has the foreign key, the choice is yours.  

__One-to-one relationships are not used very commonly__ because often the data 
they refer to could just be a single model/table.A good reasons for splitting 
them up might be performance or privacy. For example you might have a Customer 
model/table with phone number for each person and find your self doing most of 
your queries for the phone number and not any of the other attributes. Imagine 
you have a call center that really only needs the people's names and phone 
numbers. In this case __you might choose to break off a separate, smaller table__ 
called phone_numbers. This will speed up queries and hide non-essential data like 
credit card numbers.  

All told, you may want to avoid one-to-one relationships unless you have a good 
reason. They are often clunky and result in a database with too many tables. Also, 
if your schema evolves and you wind up adding a "row" for something you will then 
be dealing with "many" and you will need to break your associations and set up a 
new schema.   

__About One-to-One Relationships__  

> 
* one-to-one relationships are not very common
* use one-to-one to break up tables or...
* use one-to-one to help with frequent queries performance

### Updating our Example's One-to-One Relationships  

With our example: `Teacher` and `Classroom` we already have the foreign key and
index in the Teachers migration. We then add:  

> `Teacher` model class `belongs_to :classroom`  
> `Classroom` model class `has_one :teacher`   

When you have these associations added, it triggers Rails to do some 
magic behind the scenes. It sets up some automatic methods for you for both
models. 

	teacher.classroom                  # returns `classroom` it `belongs_to`
	teacher.classroom = new_classroom  # It's also assignable
	classroom.teacher                  # returns `teacher` it `has_one` of
	classroom.teacher = new_teacher    # It's also assignable

__Associating Two Specific Records__

Let's say we alreay have a classroom in the database but no teachers:   

	$ rails console
	> classroom = Classroom.find(1)
		# you'll see the classroom data
	> classroom.teacher
		# you won't get a no method error but you will get: 
	  => nil
	> first_teacher = Teacher.new(first_name: "Joan", last_name: "Hill")
		# you will see id and classroom_id are still nil. It's not saved yet. 
	> first_teacher.classroom
	  => nil # no association has been made yet. No SQL needed to know that. 
	    # lets set the association:
	> classroom.teacher = first_teacher
		# NOTE: this actually runs INSERT and saves classroom, with the teacher!
		# you will see that both have id's set now. Now let's test it: 
	> classroom.teacher
		# shows the page row as a hash
	> first_teacher.classroom
		# shows the classroom row as a hash

__Removing the Association Made__  

You can remove the association without removing the actual data by:  

> 
* setting the foreign key equal to nil: `first_teacher.classroom_id = nil`  
* setting `.teacher` to nil on the classroom: `classroom.teacher = nill`  
* calling `classroom.teacher.delete` or `first_teacher.classroom.delete`  

To destroy the record and remove the association to it:  

>
* `classroom.teacher.destroy` or `first_teacher.classroom.destroy`

After `classroom.teacher.destroy` if you then run `classroom.teacher` it still 
shows it the teacher object, but in frozen state. The frozen state does not last 
forever though. If you search for classroom again it will be gone.  
§

--------------------------------------------------------------------------------
## One-to-Many Relationships

One-to-many relationships are much more common than one-to-one relationships 
and are perhaps the most common of the three.  

__As Per Our Classroom Example:__  

You might remember seeing that the the "foreign keys __MUST__ go on the 
`courses` tables." and you might have wondered why.  

Think of it this way: if you have a single object attached to many, it makes 
more sense to have each of the many store the relationship to the single object. 
Otherwise. The single object whould need many foreign keys, one for each of 
the multiple objects it's related to, each with it's own column. This gets 
messy and it makes a lot more sense for each of the many to have a single 
foreign key.  

For this reason, we have foreign key on the `courses` table, each pointing to 
the teacher that `belongs_to` it. To abstract this out of our example, the 
__foreign key MUST go on the table that__ `belongs_to` __when the thing it__ 
__belongs to__ `has_many`, similar to what we saw with 1:1, only now it really 
matters since we are dealing with a `has_many`.


__About One-to-Many Relationships__  

>
* Possibly the most common used of the three
* Use the plural form of the model symbol in the `has_many` declaraion
* Used when many things EXCLUSIVELY belong to one thing


### Updating our Example's One-to-Many Relationships 

Remember that our school example has a one-to-many relationship between Teacher 
and Courses. We already have the foreign key in the Courses migration associating 
each to it's respective teacher. Now add:  

> `Teacher` model class `has_many :courses`  
> `Course` model class `belongs_to :teacher`   

Rails automatically adds methods to the model with `has_many` only this time it's 
more than with `has_one` since we are working with arrays:  

	teacher.courses                     # returns array of one or more courses
	teacher.courses = [course1, course] # specify EVERY course in an array or:  
	teacher.courses << course           # Ruby's "append op" to add another course
	teacher.courses.delete(course1)     # remove assocation with course1
	teacher.courses.destroy(course2)    # destroy course2 from database 
	teacher.courses.clear               # remove all courses
	teacher.courses.empty?              # see if array is empty (no courses)
	teacher.courses.size                # size of array (now many courses)

__Associating Specific Records__

Let's say we alreay have a teacher in the database but no courses. This first 
part is the same as we saw with one-to-one only the attribute name is plural 
and the if the attribute is empty it returns and empty array instead of `nil`. 
If that doesn't make sense look at the comments below:  

	$ rails console
	> first_teacher = Teacher.find(1)
		# you'll see the teacher data
	> first_teacher.courses # attribute is PLURAL this time and returns ARRAY
		# you won't get a no method error but you will get and empty array 
	> chemistry = Course.new(name: "Chemistry", description: "blah blah blah")
		# you will see id and teacher_id are still nil. It's not saved yet.  

Now let's set the association. This time we aren't just assigning an attribute, 
we are setting the contents of an array. 

	> first_teacher.courses << chemistry
		# NOTE: just like with one-to-one this actually saves it to the db
		# you will see that both have id's set now. Let's add more:
	> bio = Course.new(name: "Biology", description: "blah blah blah")
	> first_teacher.courses << bio
	> first_teacher.courses
		# this should now list both courses
	> bio.teacher
		# this should show our teacher	
	> chemistry.teacher
		# this should show the same teacher!
	> first_teacher.courses.size
	  => 2
	> first_teacher.courses
	  => false
	  
__Removing the Association Made__  

You can remove the association without removing the actual data by:

	> first_teacher.courses.delete(bio)

Or remove association and delete the associatated record:  

	> first_teacher.courses.destroy(chemistry)
	> first_teacher.courses.empty?
	  => true

__Querying Associated Records__

You can use `record.associated_record` and add query methods to the end which 
will apply to `associated_record`, not `record`. 

	first_teacher.courses.where(name: chemistry)

This would show the data for the chemestry class if we hadn't deleted it.  
§

--------------------------------------------------------------------------------
## Many-to-Many with Model-less Joins

In the case of Many-to-many, it's far too complicated to have foreign keys 
on each of the two tables for the same reasons we saw the `has_many` table not 
being the suitable table to hold foreign keys, only now the issue has grown to 
BOTH tables with `has_many`. For this reason we bring in a third table to handle 
all the relationships. This third table is called __JOIN table__ which will 
store the __two foreign keys required for each Many-to-many relationship__. 
Let's refer back to the chart of our school example's associations:  

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_join.png)  

That mess of connections is now encapsulated in another green box. This is 
called a "join table" in relational database terminology and in fact __JOIN__ 
is a keyword in SQL. The Join's primary job is to hold the foreign keys for 
multiple tables so they don't have to. The naming convention in Rails is to 
name the table with the names of the two tables it joins, with an underscore 
between them. Of course, like all table names, the name will be two plural 
words. __IMPORTANT:__ Rails expects these two table names to be in 
__alphabetical order__ in the join table's name. You can configure Rails 
to use some other name but things won't work automatically unless you follow
these conventions.  

__Join tables dealing with two Models in Rails have:__ 
>
* Two foreign key columns
* index for each foreign key pair, preferably one array w/two elements handling both
* NO PRIMARY KEY COLUMN in Rails joins! `id: false`

When you have two many-to-many tables, each row "has many" AND each "belongs 
to" many rows found on the other table. This combination of relationship is 
special and therefore has special treatment in Rails. We use: 
`has_and_belongs_to_many`.

### Updating our Example's Many-to-Many (Simple) 

Add these to the model classes:  

>`Course` model class `has_and_belongs_to_many :students`   
>`Student` model class `has_and_belongs_to_many :courses` 

Now we can run `generate`. With this simple many-to-many, our __JOIN__ will 
not need a model class so we'll create a migration file directly:  

	$ rails generate migration CreateCoursesStudentsJoin

The naming of this migration is just for clarity, the actual name of the table 
is more strict. This generate command will assume a table name based on our 
typing of `CreateCoursesStudentsJoin`. It will know that "Create" is should not 
be part of the table name but it may not know that "Join" should not. In other 
words you might see in the code:  

	create_table( :courses_students_joins )

Because it thinks the name of one of the tables is actually `students_joins` 
which is incorrect. We __must__ change it to: 

	create_table( :courses_students, id: false )

Notice that we also added `id: false`. The default for newly created tables is 
to add a primary key but we, again, __JOINS must not have a primary key!!__. 
Therefore we have to __suppress it with the__ `id: false` __hash__. 

Now we need to create three things: the two foreign keys, which are integer id's 
and one index to handle both of them.  

	class CreateCoursesStudentsJoin < ActiveRecord::Migration
	
	  def change
	    create_table( :courses_students, id: false ) do |t|
	      t.integer "course_id"
	      t.integer "student_id"
	    end
	    add_index( :courses_students, ["course_id", "student_id"])
	  end
	
	end

Notice that the second argument for `add_index` is now an array since we are 
dealing with two id's. This migration file is now complete and we can run 
`$ rake db:migrate` to create the join table. 

__ADD HERE overriding of :class_name in model and join table's name in model__ 
__these go after assocation methods__

Note that at this point, no SQL JOIN clause has been run. We simply have a 
table with two id's and an index.   

__Associating Specific Records__

For this exercise you should have two courses and two students added to your 
database. You would do this the same way as you would with any other table 
with a Rails model. Also have the four records queried and saved to objects. 
the following assumes you have the four named as `course1`, `course2`, 
`student1`, and `student2`: 

	$ rails console
	> course1.students << student1
	> course1.students << student2
		# now let's use the array assignment way with course2
	> course2.students = [student1, student2]

§

--------------------------------------------------------------------------------
## Many-to-Many with Modeled Joins

When we associated students to courses all we did was record the fact that the 
two are linked without any further details about the relationship. In some cases 
it becomes necessary to record more details about the nature of the association. 
In our example's Student and Course models, we might want to keep track of what 
semeseter the student took or is taking the course, their grade, etc. All of this 
should go in the join table since it's the joins role to keep track of anything 
relating to both records in relation to each other.  

For this we need to restructure our Rails association methods. Before we had this:

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_join_model-less.png)  

Notice there is no Model defined in our code for the join table. Now we will 
actually define one with a different, more suitable name and give it two 
association methods. We will also change the associations in the other two 
models:  

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_join_with_model.png)  

Be aware that there is a better way to do this but for the sake of learning we 
will use the above association methods.  

__Keys in Join Models__

Our join will still have two foreign keys but now __we have a model for it we__ 
__must have a primary key and id because we will be performing CRUD__ 
__operations on it and they should be fast and efficient!__ 

__Naming Join Models__

__When we create the join with an explicit model we no longer need to follow__ 
__naming convensions and can give it a more descriptive name.__ Usually these 
join tables end with "__-ments__" or "__-ships__" as in "assignments" or 
"memberships." Usually there is one model name in this name like ""course 
enrollments" but since it's self apparent that "enrollments" involves students 
and teachers we can keep it short. It's a matter of preference.  

__Associations In Models that use a Modeled Join__

Also, __now that our join has a defined model, we need to have the two__ 
__associated models it joins point to the join rather than each other.__  

### Updating our Example with a Join Model 

First let's drop the join table we have now:

	$ rails g migration DropCoursesStudentsJoin

Now rename the class and make `change` look like: 

	class DropCoursesStudents < ActiveRecord::Migration
	  def change
	    drop_table :courses_students
	  end
	end

You can run `rake db:migrate` now or wait until we have this new addition:  

	rails g model Enrollment

Since we need both a model and migration we ran `rails g model`, which also 
makes the migration. Also, remember that models are singular and migration 
are plural. Running this created a `CreateEnrollments` migration, plural:  

	class CreateEnrollments < ActiveRecord::Migration
	  def change
	    create_table :enrollments do |t|
	    
	      t.timestamps
	    end
	  end
	end

Let's add the two foreign keys and one index for both of them:  

	class CreateEnrollments < ActiveRecord::Migration
	  def change
	    create_table :enrollments do |t|
	      t.references :course
	      t.references :student
	      
	      t.timestamps
	    end
	    add_index :enrollments, ["course_id", "student_id "]
	  end
	end

A couple of things to note: unlike the model-less join, we do not need to 
add `id: false`. We need a primary key so we'll let the default take over. 
Also note that, since we used `t.references` instead of `t.integer`, we can 
leave off the `_id` at the end. We used an array to handle the two foreign 
keys at once.  

At this point we don't have any functionality that we lacked in the 
model-less join. Let's add the student's grade in the course, right before 
`timestamps`:   

	t.decimal :grade, precision: 5, scale: 2

We used `decimal` because it has fixed precision and is not floating point. 
`:scale` determines the number of digits after the decimal point and 
`:precision` determins the total number of digits. Now let's add something 
to show if the course is an elective or required:  

	t.boolean :elective, default: false

Now we can run `rake db:migrate` and move on to defining the model files which are empty classes at the moment. Add the following:  

>`Course` model class `has_many :enrollments`   
>`Student` model class `has_many :enrollments` 
>`Enrollment` model class `belongs_to :courses`
>`Enrollment` also should `belongs_to :students`


Remember that there is a better way to do this but for the sake of learning we 
will use the above association methods.  

__REVIST DEFAULT OVERRIDES__  

Note that at this point, no SQL JOIN clause has been run. We simply have a 
table with two id's and an index.   

__Associating Specific Records__

For this exercise you should have two courses and two students added to your 
database. You would do this the same way as you would with any other table 
with a Rails model. We have to handle the joins differently now that we have 
a model for the join table. Let's say a student visits the registrar and says 
he needs and elective. The student is looked up and `student1` is made. The 
desired course is looked up and `course1` is made, then:  

	$ rails console
	> student1.enrollments  # shows no courses. same for student2
	> course1.enrollments   # show no students. same for course2
	 
Next we open up a new enrollment object (the join) and set it to elective.  
Since it has a model, we need to work with this join object. After we set it 
to elective we will add it to the course

	> enroll = Enrollment.new
	  => # you'll see keys but all nil
	> enroll.elective = true    
	> course1.enrollments << enroll
	
`<<` will automatically save the `course1` record. If we used the `=` 
assignment operator we would need to run `.new` on it to save it. Now we 
have `course1` with an unknown student as an elective. We could do this:  

	> course1.enrollments << student1

But let's do it this way: 

	> enroll.enrollments = student1 
	> enroll.save
	
__GOTCHA:__ You might thinks all is well since you ran `.save` but it's not.  
If you look at `course1.enrollments` you'll see that the student was added BUT 
if you look at `student1.enrollments` you won't see the course added! We need 
to reload `student1` from the database:  

	> student1.enrollments(true)
	> student1.enrollments 
      => # now you'll see it!

This reveals that `.save` only saved to the database but did not update our 
instantiated `student1` object. If we use `<<` on the JOIN table object it will 
save in both places. __BEWARE OF THIS__ since it leaves you with an out of sync 
object.  

__Using Mass Assignment__

Another to to associate two records that have a modeled join is to simply do 
it all with mass assignment to the join object. You'll still need to have 
student and course objects ready to go but this way is ultimately much quicker:  

	> Enrollment.create(student: student2, course: course2, elective: true)

__BEWARE OF THIS__ too since it also updates the database but not the object. 
We need to run this:  

	> student2.enrollments(true)
	> course2.enrollments(true)
	
Now the objects are updated to the new state of the database.  

### Traversing our Example with a Join Model

Before if we wanted to get a student's associated course data we could run 
`a_course.students` and get an array. We can't do that now since courses has 
no direct relationship with students and visa-versa. They instead both have a 
relationship with `enrollments` and we must go to this join to get the 
other table's associated data like this:  

	a_student.enrollments.map { |e| e.students } 
	
This goes through each enrollment to look up it's students and returns the 
same array. This is not only more of a pain, it's also results in not very 
efficient SQL. We want to be able to simple call `a_course.students` and have 
it __traverse__ the join. To do this, we must tell ActiveRecord about this 
outer relationship between courses and students. Do to this we use the 
`:through` hash with our `has_many` declarations.  

### INNER JOIN: __has_many__ with __:through__

The solution is to add to a second relation to each of our two outer models
which using `through` which has similar effect as `has_and_belongs_to_many`. 

>`Course` model class `has_many :enrollments`  
>`Course` model class `has_many :students, through: :enrollments`  
> 
>`Student` model class `has_many :enrollments`  
>`Student` model class `has_many :courses, through: :enrollments`

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_join_with_through.png)

Basically what these do is say "we have a relatinship with students/courses 
that you can find out about if you look at the enrollments table." 

__REVIST DEFAULT OVERRIDES__  

Now if you go to console and query a student or course you will see the SQL 
has added an __"INNER JOIN."__ Now the following are available:  

	> student1.courses
		=> # shows course data
	> course1.students
		=> # shows student data
		
and show the other tables data by __"traversing the INNER JOIN."__ This is 
easier and more efficient but be aware that it's __not exactly the same as__
__a direct assocation in some cases.__ We can use `<<` to add students and 
courses to each other but __if the INNNER JOIN has required fields we can't__ 
__sucessfully save the record without adding to  the JOIN directly.__ 
for this reason, you might want to do everything via an object from the JOIN 
when creating a record and then you can use the way possible with `:through` 
for modifying existing records. 

## CRUD with Models in the Controllers

