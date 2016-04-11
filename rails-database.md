________________________________________________________________________________
# MVC: Models and the Database
________________________________________________________________________________
## Creating and Configuring Database

__Creating a Database:__ 

Let's go over how to create a database. You should know how to do this not just from within Rails using the Rails command but also according to how it would be 
done without Rails. In mySQL: 

	CREATE DATABASE db_name; 
	SHOW DATABASES;          
	USE db_name;             
	DROP DATABASE db_name;   # deletes database

SKIP SKIP SKIP SKIP

__Configuring App to DB:__ 

The first step is, of course, to make sure you have the proper Gem installed for your chosen database technology. 

`config/database.yml` is the file you use to configure your database which is in YAML format. In YAML, Structure is shown through indentation (one or more spaces, but typically two). Sequence items are denoted by a dash (not shown below), and key value pairs within a map are separated by a colon. This shows our database setting for the rails development environment:  

	development:
	  adapter: mysql2
	  encoding: utf8
	  database: simple_cms_development
	  pool: 5
	  username: root
	  password: secretpassword
	  socket: /tmp/mysql.sock

The `adapter:` value will change depending on what database tech you are working with. The `database:` value is the database name, which defaults to the app name followed by and underscore and the environment name. If you set up your mySQL database manually, you will likely create a user specifically for this app which you should then set to the value of `username:` rather than `root`. The `password:` should of course match the password you created for the user.  
  
`socket:` is important because it's the file that Rails uses while connecting. This should be set automagically but if for any reason it does not, here is where you set it. To test your connection to the database you can do this in terminal:

	$ rake db:schema:dump

This has Rails connect to the database and export the schema in a new file `db/schema.rb`. If you don't get an error and you do see this file, you connected successfully. 
________________________________________________________________________________
## What is a RDMS?

The analogy of a database to a spreadsheet is helpful but incomplete. First the helpful part; If one were to arrange a spreadsheet as if it was a true database you would start with a horizontal row atop the spreadsheet with each cell labeling what kind of data goes below it in each column, i.e. first-name, last-name, address, etc.  

In a real database, each cell in the __column__ below the labling cell is if a particular data type, i.e. integer, string, etc) and only that type.  
  
Each __row__ refers to a different real-life object (person, product, etc) and is also sometimes (incorrectly, some say) called a __record__. 
  
The intersection of a row and a column is called a __field__ in databases. This entire structure is equivalent of a real database __table__. Typically a 
application has only one __database__ with many __tables__.  
  
What make Relational Databases Management System distict from spreadsheets is the __relational__ part. In a RDMS, one real live entity might have it's details 
listed in mulitiple tables which are linked together with __foreign keys__. We'll see more about foreign keys later but just know they provide a way of linking a row of data in one table to another. For example, we may have a table for contact info on people and another on medical history. A single patient has their data in multiple tables but within the tables cells there are references to other table rows in in order to link them together. This is helpful for organizing your database into smaller pieces rather than just having one big, unweildy table.  
  
Another thing that makes spreadsheets and RDMS different is __indexes__. An index on a RDMS table allows for rapid lookup of a record. In spreadsheets you are just looking things up with your own eyes but in a real database, lookups are often done in software and need to be blazing fast!  
________________________________________________________________________________
## What is Schema? Migration? Model?

__What are Schemas?__  

Getting back to the similarities, the term we use in RDMS for all of the labels without the data populated within it is the __schema__ the __schema__ is like the description of structure of the database. It's the setup you do to prepare a spreadsheet before you enter the tables. Rails has a way of abstracting this schema from the actual database's language into or Rails application. This means a few things, we can configure and use our database using Ruby language, using Rails classes and methods rather than using SQL code or whatever the database uses. It also (usually) means that we can define our database scheme without even choosing which database technology to use! In fact, we can use a small simple DBMS during production and then another one more suited to high traffic in our deployment, all without needing to change much or any of our code.  

To summarize, migrations are a blueprints that describe how the structure of you database is organized. On a more concrete level, your schema is stored as a single, auto-generated Ruby file in your application called `db/schema.rb`. This file is not the place where the database's scheme is _defined_ but instead can be thought of as a place where the schema is _documented_. If you want to actually modify the schema, the place to do that is from migration files as we shall see next. Migration files are a bit more scattered and are not the best place for the developer to get a birds-eye view of the database's struture the way `db/schema.rb` is.  

__What are Migrations?__  

Rails will use what it calls __migrations__ to automate the process of setting up your database's schema. The migration files are nothing more than Ruby Classes containing methods to set `up` changes or take them `down` (undo) and in fact can have two methods matching those names.

Each time a change is needed to the database's schema, a migration file is made and it's `up` method is called, which creates whatever tables, columns, etc are 
needed. The `down` method usually resemble the `up` methods with the order or instructions reversed.  

New in Rails version 3 was support for a method called `change` to be used instead of both `up` and `down`. Here, rails attempts to use the same method for both doing and undoing, by guessing how the method might be executed in reverse as is needed for undoing.  

The migration files are ordered by data created since often new features depend on old ones. Migrations also make it easy for multiple developers (who of course have their own local versions of the database in their respective production environments) to coordinate changes and revert them, if needed.  

__One important note on migration files:__ the migration filenames are prepended with a timestamp and when you set up or update your database, all migration file that have not be run will be run __IN ORDER.__ If you make a migration to create a model, share it to fellow developers and then decide to modify the model you __should NOT modify old migration files but instead, make a new one that modifies!__  Imaging other developers made migrations to modify what you did in the "create" migration. This will be run after yours. If you modify your original by, for example renaming some field, the other user's migration could have references to things that should exist if you left your migration alone, but now don't. So the rule is:   

__Once you run your migrations, don't modify old migration files, make new ones!__  

To sumarize, __migrations__ define the methods executed and repeated to set up your database's schema. Their effect on the database are _reversable_. They keep 
the database schema in the realm of Ruby code instead of database languages like SQL. The allow for sharing between developers and version control without having to share an actual duplicate copy of a database.  

__What are Models?__  

Once we have migrations run we have a workable databases that can be accessed with the Ruby language, but our Rails apps need to actually interact (create, read, update and delete rows) via another part of RoR called __models__ models are not exclusive to Rails, they are the __M__ in __MVC__. In Rails:  

> one table = one model  
> each model/table is a single real-life noun (person, product, etc)  

Once we run migrations, their work is essentially done and models come into play as our messenger between the rails app and the database. Controllers will take user input from the view and put it into the database via the models. Likewise they can look at the data in the db via the model give it to the views for display to the user. Here is the acronym said by many, not just Rails folks, to outline the operations involed when working with a database:  

__CRUD:__ 
> Create  
> Read  
> Update  
> Delete  

Beyond the CRUD roles, Models also the appropriate place _process_ the incoming or outcoming data.  
________________________________________________________________________________
## Rails Naming Conventions 

Before we actually create some migrations lets get some naming conventions clear. Naming conventions matter a lot in Rails because Rails links the various parts of your app by filenames, classnames and tablenames. If you don't follow the conventions, these things will loose their connection. You can override these defaults with our own configuration but development will be faster and easier if we follow them. 

As you probably know, Class names are camelCase but starting with a capital (aka PascalCase) and method names are snake_case. This convention only applies to the actual code and not the file names. the file names are always snake\_case ( no capitals anywhere).  

Models are Classes and therefore follow PascaCase but, in addition to that, you should know that model names are SINGULAR as they define a SINGLE model for many instances. Any controller that refer to models in their name should do so in a plural form. For example, You many have a `User` model in file called `app/models/user.rb` and a controller called `UsersController` that sits in a file called `app/controllers/users_controller.rb`.  

Table names although they are the database mirror of our Rails model, are snake\_case and pluralized; for example `invoice_items`, `orders`.  

Visit [\<here\>](http://itsignals.cascadia.com.au/?p=7)  and [\<here\>](http://alexander-clark.com/blog/rails-conventions-singular-or-plural/) for more naming conventions.  
________________________________________________________________________________
## Generating Models and Migrations

The first time you create a model you will need both the model .rb file and at least one migration .rb file. Subsequent changes to the model do not require more model files but SHOULD involve you modifing the database by creating more migration files rather than modifying pre-existing ones. For this reason, when you run: `rails generate model` it will create both the model and migration files. You also have the option of `rails generate migration` which will generate a migration file but not a model file. (note that there is an alias for `generate` which is just `g`).  
________________________________________________________________________________
## Naming Conventions with Generate

It's important to realize that all `generate` is doing is generating file and filenames. It's not doing anything magical like linking them together. It's the 
names of each item that leads to them being linked. One could create all the files and, if named properly, the end result would be the same as if `generate` 
was used. 

When you run `rails generate` + __something__, rails will make filenames, classnames and sometimes method names. Since naming conventions for these three do not mirror each other, the `rails generate` command can accept PascalCase or snake\_case and will adjust the result according to Rails naming conventions. 

When it comes to the issue of plural vs singular, The command you type should adhere to the conventions. For example. You are generating a user model you can 
type `rails g model User` or `rails g model user` but don't type the plural versions of these.

In contrast, if you are working with __migrations__ for these you should use the __pluralized__ versions. For example, `rails g migration ModifyUsers` or `rails g migration modify_users`. 
________________________________________________________________________________
## Object Relational Mapping 

It may seems obvious but Ruby and SQL are vastly different languages, each with different concept and implimentation of an "object." The goal of Object-Relational Mapping (ORM) is to serve as a bridge between these two. Our app has Ruby objects which should mirror the "objects" in the database. Rails has several Ruby classes that contruct this bridge.  

__ActiveRecord::Base__ (aka "ActiveRecord") is the M in MVC. It's name come from the design pattern called __active record pattern__ which was outlined by 
Martin Fowler before Rails existed in 2003. It specifies that database tables or views are wrapped into a class. Thus, an object instance is tied to a single row in the table. ActiveRecord (in PascalCase) is the Rails implimentation of the active record pattern. The ActiveRecord class facilites the creation of objects which are tied to our database and allows us to extend a static database to have business logic, processed within our application code. In this way, ActiveRecord not only preforms CRUD on the database, it makes it intelligent.  

Remember that each model names matches a table name. Also note that a model is really just a Ruby class. ActiveRecord lets us create a new row in the table by 
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


Note that Rails was smart enough to know the second call to the save method should actually run UPDATE in SQL instead of INSERT since data is already present. 

When we use `generate model User`, our user.rb file has boilerplate code with a class inheriting from `ActiveRecord::Base`, making it an __"ActiveRecord Model"__. This makes our model database-ready. You could also create a model file manually if you don't want a matching database migration file. In this case you would not need the `< ActiveRecord::Base` inheritance in your model file. But be aware that the inheritance gives us a lot. Without it we will be missing all the attribute accessors corresponding to data on the database and would have to put them all in one by one. If you have a table with 75 columns this is a lot of work. Rails will invisibly add and update all of this behind the scenes if we follow Rails conventions.  

__ActiveRecord::Relation__ (aka "Active Relation" or "ARel") was added in Rails version 3. The line between ActiveRecord and Active Relation is a bit blurred. 
Many things you do in ActiveRecord::Base actually rely heavily on ActiveRecord::Relation. ARel uses relational algebra to simplify the generation of complex database queries. Small queries can be chained like we see in Ruby objects. ARel is used for things like joins and aggregations, using efficient SQL and timed executions which wait until the actual query is needed. 
________________________________________________________________________________
# Migration Basics
________________________________________________________________________________
## Adding / Removing Tables & Columns

__Adding / Removing Tables:__ 

It's helpful to fill out your migration the long way using `up` and `down` before relying the shortcut `change` method. Here we  use `rails g model User` and we get:

	class CreateUsers < ActiveRecord::Migration
	  def change
	    create_table( :users ) do |t|
	    
	    t.timestamps
	  end
	end
	
Here we see the `create_table` method which is used to create a database table we are calling `:users`. This Ruby symbol `:users` is notably plural (as tables are) as opposed to Models (singular). `t` is the actual table, to which we are adding attributes via a Ruby `do` block. 

	class CreateUsers < ActiveRecord::Migration
	
	  def change
	    create_table( :users ) do |t|
	    
	    t.timestamps
	  end
	  
	  def down
	    drop_table :users
	  end
	  
	end

Now we have a new method called `drop_table` which is the opposite of `create_table`. It is not in block form the way `create_table` because it doesn't need to know anything about the table in order to delete it. As a side note, notice we added parenthesis to the argument in `create_table`. As a matter of style, this guide will use parentheis for arguments in method calls when they are in block form. 

__Adding Columns:__ 

The create\_table block accepts two ways to add columns to a database. Here is one:

	t.column "first_name", :string

This creates a table column of a data-type known to Ruby as a string but might be called any number of things in the actual database itself. We don't exactly HAVE to know how it's done directly in the database, using SQL code (or whatever the DB is based on) at this stage because Rails is handling this for us when we eventually run the migration. We need a label for the column which here we use the string literal `"first_name"`. note that `t.columns` can take a third argument for __options__: 

	t.column "label_name", :data_type, options

Now for the shorter form:

	t.data_type "label_name", options

This is the version you will see in wild more often but you should be familiar with both since sometimes you will not have this optional shorter version available. 
________________________________________________________________________________
## Data-Types and Options

Rails defines a number or data-types which it then translates to the data-types native to your chosen database technology:

	binary    boolean
	
	text      string
	
	date      datetime    time
	
	integer   float       decimal

Much like how SQL has clauses to `LIMIT` number of character, set `DEFAULT` values and more, Rails has equivalents it calls __"options"__:

	:limit		=>	size
	
	:default	=>	value
	
	:null		=>	true/false
	
	:precision	=>	number
	
	:scale		=>	number

Rails will actually generate a sensible default for each one of these so you don't have to set them unless you want to override the defaults. Looking at an example, if we have a `user_name` that we want to have a limit of 10 character:

	t.column "user_name", :string, :limit => 10

We can shorten it as seen above, and then further to use newer Ruby hash syntax:

	t.string "user_name", :limit => 10
	
	# new hash syntax:
	t.string "user_name", limit: 10

__Timestamps:__ 

Rails is, in a sense, waiting for us to possibly put these two columns in:

	t.datetime "created_at"
	t.datetime "updated_at"

When Rails sees these it will automatically update and populate them for us whenever a row is created or updated. You don't need to do anything additional. The shorthand for these two is:

	t.timestamps

If you put this one line in, Rails essentially replaces it with the two lines seen before. 

__ID:__ 

Note that Rails will always create an id, an __auto-incrementing primary key__ with the data type __integer__, for each table since this is something you will almost always need. 
________________________________________________________________________________
## Running Basic Migrations

To run the migration, execute this command at the __root of your project__:

	$ rake db:migrate

By running this without a second argument, you are essentially running `rake db:migrate RAILS_ENV=development` since that is the default. Note that this runs __all migrations that have not yet been run__.  

__Verify Changes on Database:__ 

At this point you can verify it worked by going into your database's command line and checking (with `SHOW TABLES;` then perhaps `SHOW FIELDS FROM users;`, for example). You should see everything you specified plus the `id` integer that is automatically added. This is a good place to observe Rail's default options for all of the fields you specified as well as __id__.

Something else you can verify from your respective database's command line is the list of migrations that were run. In mySQL you can type:

	SELECT * FROM schema_migrations;

and you will see each migration _file_ that went into the current state (schema) of your database. They are listed by the long integer timestamp prefixes seen in the filename of each .rb file used for the migration(s). This is a good way to check the state (schema) of the database from the database's perspective. This `schema_migrations` table is managed by Rails and you typically will not (or should not) make any changes to it directly. 

__Verify Changes from Rails app:__ 

After running the migration, not only will your database change but the `db/schema.rb` file in your application will change to reflect the migration as well. If all went well, the `schema.rb` file should reflect exactly what you see on the database itself. 

If you want to roll back your database to it's pristine state, before any migrations:  

	$ rake db:migrate VERSION=0

`VERSION=0` is another environment variable representing the state of the database before any migrations. __All environment variables must be ALL\_CAPS__, this is very important. 

Now if you run `SHOW TABLES;` you will those tables added are no longer there. Also, if you run `SELECT * FROM schema_migrations;` you will see that that table is now empty. 
________________________________________________________________________________
## Running Specific Migrations

Run this to see a report of the current state of migrations:

	$ rake db:migrate:status

This will list each migration file by it's integer timestamp and status of each as either __up__ or __down__. This list is a good reference from which you can grab the long integer timestamps and use them in the `VERSION` environmental variables for migration commands. For example:

	$ rake db:migrate VERSION=xxxxxxxxxxxxxx

This will run only that migration and nothing else. If you run a full migration after this, it will run all the other migrations. (EVEN ONES BEFORE IT??). Then if you re-run the specific version migration again it will take the additional ones back down but it will not un-run the one specified. __this all seems incomplete!!__

there is also 

	db:migrate                   # run all migration files not yet run, in order
	                             
	db:migrate:up   VERSION=num  # runs up for specific migration file
	                             
	db:migrate:down VERSION=num  # runs down for specific migration file
	                             
	db:migrate:redo VERSION=num  # runs down then up for specific migration file
	                             
	db:migrate:redo              # assumes VERSION is LAST migration
	                             
	db:rollback	                 # rollback last run migration(i.e. Default STEP=1)
	                             
	db:rollback STEP=4           # rollback last 4 migrations.

________________________________________________________________________________
## Migration Methods

Within our migration files we have various methods available to us in addition to `create_table` and `drop_table` which we have already seen:

TABLE METHODS:
	
	create_table( table, options ) { |t| ...columns... }
	
	drop_table( table )
	
	rename_table( table, new_name ) 

NOTE: The two args for `rename_table`, if placed in a `change` definition, NOT `up` or `down`, are reversed by Rails if you undo the migration in the command line. If you have this method inside and `up` method then you will need to swap the args manually in the `down` method. 
	

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

DANGER: This, of course, only works with SQL and Rails will not alter your input in any way to fit the particular flavor of SQL being used!  

When you create a migration file that is meant to alter a pre-existing table, you should name it such that it's purpose is apparent, like `change_users` or `alter_users`. You will often want to plant a few `puts` into your `up` and `down` methods so that when you run the migrations you can be reminded of what is going on.  

Whenever you create a new migration you should test not only it's `up`functionality but it's `down`. It's much better to catch mistakes before the database is actually populated with real data!!
________________________________________________________________________________
## When Things Go Wrong 

Migrations can be stuck in a broken state where you can't run `up` or `down` if you're not careful. For example, you could have `delete_column` for column names that don't exit at a given point. This might seem like an easy typo to fix but sometimes if custom migrations are run, you might not have forseen that point in time. When things like this happen you will see the dreaded:

	rake aborted!

To complicate things further, failed migrations are still partially executed. This means that if you go in and fix and typo then try to run it again you will could get another due to the partial migration that already occured!! Then trying to completely roll back to `VERSION=0` fails because you might have missing tables or columns refered to in one or more `down` methods!!  

At this point we are pretty trapped and there are several ways to get out. One way would be to go into your database using it's own interface and edit it to the schema as seen by Rails.  

The other, and much easier, way would be to comment out the portion of offending migration that was ran so that all the remains is what didn't yet run. 

All of this needs to be ironed out before you deploy. Fixing a problem on a development database is one thing but in production it will mean often mean a serious loss of data. Keep your migration files small, with each only addressing a single table if you can. TEST EVERYTHING THOROUGHLY before deploying any part of your database, especially when those parts are available to be populated with actual data!  

__Linking Model names to Table Names:__ 
Sometimes you might have legacy code that does not follow naming conventions, or perhaps a migration changed a Table name and the model class still matches the old, now deleted tablename. You can, within your model class, point it to any tablename with:  

	self.table_name = "new_name"

And with that it will be fixed. Of course you could also just rename the model.rb file and the classname within it.  
________________________________________________________________________________
# Introducing Our Example Database
________________________________________________________________________________

It's sometimes hard to understand database concepts without a concrete example. For that reason let's choose the example of a high school's database for our database Schema. Let's start by thinking of the main "objects" that are at play in a high school we have a classrooms, teachers, courses and students. We won't consider the student's grades at the moment, just the their enrollments and the details of each course in terms of where it is and who is teaching it. 

Each of these things is actually a Model in the strictest sense of the word; they are Ruby classes in Rails, each representing A single table. The relationship between these tables is obviously inter-related and for that reason we need to introduction some details about the "relational" part or relational databases.  
________________________________________________________________________________
## Database "Relationships" are Rails "Associations"  

Let's think of our example of the high school. Assume each teacher has only one classroom and each classroom has only one teacher. Both the classroom and it's teacher have many courses it teaches. Students freely pass between different classrooms taking different courses but teachers stay in their respective rooms.  

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_associations.png)  

Obvously this is not showing the full school, there are more than one classroom and many teachers, but this encapsulates the details of the relationships, or "assocations" as they are called in Rails, between the Models.  

Now to consider the more concrete aspects of our chart in action, the Model class defines the structure of the database tables. ___TO CLARIFY,__ although "one model equals one table" that does not mean that the two are synonymous. The objects created from the Model class are each a row in the table that the Model class defines. In other words, the table in the database is really the Model class plus all of the objects created with the Model class. In this sense, the Model class is the table's schema and the object's attributes are the data.  

Now getting back to the topic of associations, the tables themselves have special columns just for the __foreign keys__ that link each row (Model instance) to a row sitting in another table. The other table has what's called a __primary key__ which matches the the foreign key and completes the connection between the two tables for a given row. 

With the `Classroom` and `Teacher` models, we will learn about the so called "__One-to-one__" relationship, which is the simplest relatinship you can have. Each row in the `teachers` table will have __foreign key__ to link it to a classroom, thus making this table reponsible for "knowing" about it's relationship to the `teachers` table. In "__one-to-one__" relationships it's generally a design choice as to which table holds the foreign key. In Rails, the records (rows) with foreign key are said to "__belong to__" those in the other table so one might choose based on what conceptually feel right. Think of the table with the foreign key as the __child table__ and the table referred to as the __parent table__. Just like with OOP, the child knows about the parent but the parent doesn't necessarily know about the child.  

With the `Teacher` and `Course` models, we will learn a little bit about the so called "__One-to-many__" relationship. Here, the Course should be the side that holds the __foreign key__ since. If it was the Teacher side that held it, the `teachers` table would need a new row each time a teacher was assigned to a new course. Since each course will only ever have ONE teacher, it makes sense to give it that key since it's schema won't need adjustment each time there is a new course assignment.   

We will ignore the `Student` model for now since that __Many-to-many__ relationship is a lot more complicated. They make use of a third table called a "__JOIN__" which handles the complex network of relationships rather than having the two tables handle them themselves. I'm sure you can tell by the pictorial why one might want to bring in something else to handle that messy network of connections.  
________________________________________________________________________________
## Coding our Example 

Here is the game plan for migrations as pseudocode:   

	Classroom: room_num:integer,  lab_equip:boolean 
	Teacher:   first_name:string, last_name:string, classrooom_id foreign key
	Course:    name:string,       description:text, teacher_id foreign key
	Student:   first_name:string, last_name:string (incomplete)


Each has a primary key which is not shown and automatically created. We are not yet defining the relationship between courses and students for now. Above, `classroom_id` and `teacher_id` are the foreign keys. These and all integer foreign keys also have integer __indexes__ (not shown above).

An __index__ is similar to a __key__ in that they are both integers for used for identification purposes. A __key__ holds an integer which is a unique identifier to and is not meant to be changed later as it might be referenced in multiple places. An __index__ IS changable and used for for grouping of data and as a "handle" for __rapid lookup__. __All foreign keys must also have an index!__

`description ` is a biography of the teacher and since it's potentially very lengthy, it's stored as `text` instead of a `string`.  

Let's do it  

__CLASSROOM model/migration:__ 

	$ rails generate model Classroom

Here is the generated migration file. Notice that the __migration class names are plural!__ and, since this is the first time dealing with the classrooms table, Rails knows we are creating it and prepends the class name with `Create`.  

	class CreateClassrooms < ActiveRecord::Migration
	  def change
	    create_table( :classrooms ) do |t|
	
	      t.timestamps  # you see instead: `t.timestamps null: false`
	    end
	  end
	end


We could use the `change` method but for the sake of learning, let's separate it into `up` and `down`. Here is the `CreateClassrooms` class in it's final state with everything added:  

	class CreateClassrooms < ActiveRecord::Migration
	  def up
	    create_table( :classrooms ) do |t|
		  t.integer "room_num"
		  t.boolean "lab_equip", default: false
		  
		  t.timestamps
	    end
	  end
	 
	  def down
	    drop_table :classrooms
	  end
	end

We added `default: false` since most classrooms are not lab equipped. 

We really didn't have to do anything unexpected with the `down` method. In this case, when `drop_table` just executes `create_table` but in reverse, flipping the implied `add_column` methods to `remove_column`. We could just rename `up` back to to `change` and delete the `down` method and everything would work fine in since we are only ADDING columns to the table. 

__REMEMBER:__ `create_table` is reversable because the `add_column` method is __reversable__. The `remove_column` method is __NOT reversable__. The reason for this is that when you add a column, you provide the full definition for it. `remove_column` doesn't need the full definition but `add_column` does. Rails cannot invert `remove_column` to `add_column` because it lacks the full definition needed to create a column!    

__Classroom: The Quicker Way:__ 

Let's delete this and do it a different way:  

	$ rails destroy model Classsroom
	$ rails g model Classroom room_num:integer lab_equip:boolean

The synax for this is `column_name:type column_name:type,` etc. __IMPORTANT:__ Notice that there are no commas. If you put commas, you will not get an error but commas will be inserted into the actual migration file and you will get an error when you finally run the migration!  

Note that this quicker way does not allow you to set a default modifier like we had with `t.boolean "lab_equip", default: false`. There are, however some accepted modifiers in the generate command. It's a bit advanced for now but you can look up "passing modifiers to rails generate" if you're interested. Here is the output with `, default: false` added in afterward:  

	class CreateClassrooms < ActiveRecord::Migration
	  def change
	    create_table :classrooms do |t|
	      t.integer :room_num
	      t.boolean :lab_equip, default: false
	
	      t.timestamps null: false
	    end
	  end
	end

__TEACHER model/migration__

	$ rails generate model Teacher
	
No let's move on to the __teachers__ table, where we won't use the full `generator` but we'll keep it simple and just use `change`: 

	class CreateTeachers < ActiveRecord::Migration
	  def change
	    create_table( :teachers ) do |t|
	      t.integer "classroom_id" 
	      t.string "first_name"
	      t.string "last_name"
	      
	      t.timestamps
	    ends
	    add_index("teachers", "classroom_id")
	  end
	end
	
The adding the foreign key is done in the `create_table` block. Remember that __All foreign keys also need an index__ so you can see that being created with `add_index`. `add_index` must be outside the call to `create_table`. The `drop_table :teachers` is all we need to to drop the added columns as well as the indexes since they are in fact also parts of the table. 

__Teacher:__ `classroom_id:integer:index` __Shortcut__

Before you run the migration, let's delete this and create it another way, completely with `rails generate`:  

	$ rails destroy model Teacher
	$ rails g model Teacher classroom_id:integer:index first_name:string last_name:string

`classroom_id:integer:index` generates the line `t.integer "classroom_id"` for the foreign key and  `add_index("teachers", "classroom_id")` for it's index. The results of this generate command is the same as we achieved before manually. By the way, you can also use this three keyword with a different type: `permalink:string:index`. This would allow you to have a URL permalink string in the body of `create_table` and then create the normal index (not a string) just as we have with `classroom_id`.  

Let's run the migration and see what the results are in the database:  

	$ rake db:migrate
	$ rails console
	> ActiveRecord::Base.connection.tables # this is to display all tables
	 => ["schema_migrations", "classrooms", "teachers"]  
	> Teacher.column_names # this shows the columns for the teachers table
	 => ["id", "classroom_id", "first_name", "last_name", "created_at", "updated_at"]
	 
Note that this shows the foreign key `classroom_id` but not the index for it.  In other words, It does not prove we have an index for `teacher_id` and would look exactly the same if we didn't have `add_index("teachers", "classroom_id")` in our migration file. 

	> Teacher.connection.index_exists? :teachers, :classroom_id
	   (0.3ms)              SELECT sql
	            FROM sqlite_master
	            WHERE name='index_teachers_on_classroom_id' AND type='index'
	            UNION ALL
	            SELECT sql
	            FROM sqlite_temp_master
	            WHERE name='index_teachers_on_classroom_id' AND type='index'
	
	 => true 

`index_exists?` method on one of the ActiveRecord "connection adapters" classes. It takes two symbol arguments, the table name and the index name. It runs SQL and then returns `true` if there is an index for it on that table. 

__Teacher:__ `t.references` __Shortcut__

There is yet another way using newer `references` syntax introduced in Rails 4 that uses a single line that makes both the foreign key and the index. There is also a way to generate this in the `generate` command. Let's step back and redo the teachers migration with this:   

	$ rake db:rollback STEP=1 # go back one migration
	$ rails destroy model Teacher
	$ rails g model Teacher classroom:references first_name:string last_name:string
	
This gives us the migration with the newer synax. Instead of `t.integer "classroom_id"` and `add_index("teachers", "classroom_id")` we have a single line handling both: `t.references :classroom, index: true, foreign_key: true`:  

	class CreateTeachers < ActiveRecord::Migration
	  def change
	    create_table :teachers do |t|
	      t.references :classroom, index: true, foreign_key: true
	      t.string :first_name
	      t.string :last_name
	
	      t.timestamps null: false
	    end
	  end
	end

If you the the same test in `rails console`, you will see the same results. 

__COURSE model/migration__

Now that we know the shortcuts, let's make the Course model and migration the easiest way:  

	$ rails g model Course teacher:references name:string description:text 

Here is what our command generated:  

	class CreateCourses < ActiveRecord::Migration
	  def change
	    create_table :courses do |t|
	      t.references :teacher, index: true, foreign_key: true
	      t.string :name
	      t.text :description
	
	      t.timestamps null: false
	    end
	  end
	end

__STUDENT model/migration__

	$ rails g model Student first_name:string last_name:string
________________________________________________________________________________
# CRUDing Records with ActiveRecord
________________________________________________________________________________

The following examples will be show in the __rails console__ since it gives us some nice feedback on what we're doing but keep in mind that the same syntax is valid in Ruby code elsewhere. Also not that, contrary to methods given to us in ARel, perform their action immediately. 
________________________________________________________________________________
## New vs Create  

__Model.new__  

Each model has a class method called `new` which is our constructor. Here it is being called without arguments: 

	$ rails console         # enter the Rails Console
	> teacher = Teacher.new # create object called teacher in temp. memory  

We would then set each attribute and run `teacher.save`. This is the long way to do things. We could have sent in values at the time of instantiation as aruguments to the constructor as we'll see next.  

__new With Arguments__ 

The `new` constructor takes `:key => value` pairs as arguments or the newer `key: value` syntax. The `:key` is actaually the column name in the table which, from Rail's pespective, is a data attribute of the Model class. You could populate the entire record (row) with on line in the Rails Console (known as __"Mass Assignment"__). You don't have to provide all the attributes, you can provide just the (non required) ones you want and let the defaults handle the rest. This only works if they actually do have defaults; you can set an attribute to reject not having it's value explicitly set as we will see later on with __"validations"__.  

	> teacher2 = Teacher.new(first_name: "Jeffrey", last_name: "Russ")
	> teacher2.save
	 # SQL INSERT ...
	 => true

One handy fact is that `teacher.save` returns true if it was sucessful so we can make it the condition of an `if` statement for error handling. If the data entered does not meet the requirements of your model or the database, false will be returned. __One reason for `save` failing is that you have not set a required field.__ You could also do the following but as you'll see in the next section, there is a better "one liner" option:  

	> teacher2 = Teacher.new(first_name: "Dennis", last_name: "Richie").save

__Model.create__ 

We used mass assignment with the `new` method, which then requires us to run `save` but we have another option of using `create` instead of `new`, which does not require `save` afterward. Unlike `save`, `create` does not return a boolean, it returns the object just like `new` does so we'll need to find out if it was successful by other means.  

	> teacher3 = Teacher.create(first_name:"Yukihiro", last_name:"Matsumoto")

Note that these three object we created are only temporary variables in our current `rails console` session and do not represent data actually on the database. If we restart the console they will be gone:  

	> teacher3
	 => #<Teacher id: 3, classroom_id: nil, first_name: "Yukihiro", last_name: "Matsumoto", created_at: "2016-04-08 19:28:25", updated_at: "2016-04-08 19:28:25"> 
	> exit
	$ rails console
	> teacher3 # this was a temp object and no longer exists!
	  NameError: undefined local variable or method `teacher3' for main:Object

__Model.create( [array] )__  

You can create many records with one call to create if you argument is an array of hashes. The return will be an array in the same format that you will get if you call `Model.all`, which outputs the whole table, only this is only containing the rows you just added:  

	> new_courses = Courses.create([{ :name => 'test1' }, { :name => 'test2' }])
	 => [#<Course id: 38, name: "test1">, #<Course id: 39, name: "test2">] # this is abbreviated for this guide

If you look at `new_courses[1]` you will see `#<Course id: 38, name: "test1">` You can also format the output if you use the `Hirb` gem: 

	> Hirb.enable
	> new_courses
		+----+-------+-------------+------------------+------------------+
		| id | name  | description | created_at       | updated_at       |
		+----+-------+-------------+------------------+------------------+
		| 38 | test1 |             | 2016-04-11 02:05 | 2016-04-11 02:05 |
		| 39 | test2 |             | 2016-04-11 02:05 | 2016-04-11 02:05 |
		+----+-------+-------------+------------------+------------------+
		
	> new_courses[1]
		+----+-------+-------------+------------------+------------------+
		| id | name  | description | created_at       | updated_at       |
		+----+-------+-------------+------------------+------------------+
		| 38 | test1 |             | 2016-04-11 02:05 | 2016-04-11 02:05 |
		+----+-------+-------------+------------------+------------------+


________________________________________________________________________________
## Find and other Simple Queries

Once you enter the console you might like to take a look at what's on the database just to get an overview.

	> ActiveRecord::Base.connection.tables # this is to display all tables
	> Teacher.column_names                 # this shows the columns for the teachers table
	> Hirb.erb                             # for nice formating (optional)
	> Teacher.all                          # shows the entire teachers table with data or nil if empty

`Teacher.all` probably showed you that the `teachers` table has one record with an id of 1. This is the first record and probably also the last. The following can be used to get at that row:  

	Teacher.find(1) # returns the row with id of 1
	Teacher.first   # returns the first row or nil
	Teacher.last    # returns the last row or nil

By saying they "return the row" we really mean an object from the class `Teacher` which effectively is a database row. Therefore, we can use this row to instantate a Ruby object. 

	> teach_id1 = Teacher.find(1) # save to object
	> teach_id1.class             # => Teacher( hash of attributes... ) 
	> teach_id1.class.superclass  # => ActiveRecord::Base 
	> teach_id1.new_record?       # returns false because teacher it already existed

	
If we created a new object with the `new` method (not by grabbing one from the database) `.new_record` would return `true`.  

Each column name in a table is also a data attribute avaible on objects pretaining to the table.

	> teach_id1.id                # prints the row's integer id. 
	> teach_id1.first_name        # prints out "Jo"

We haven't made any change to the object or the database. Let's do that next.  


________________________________________________________________________________
## Simple Assignment vs Update_Attributes  

We said that each each column name is also a data attribute of the object and we used `.id` and `.first_name` to view the current value. We can also assign to this attribute with the `=` operator but this assignment only effect the object, which is just a temporary representation of the row on the table. In order to push that change to the database we call the `save` method.  

	> teach_id1.first_name = "Jeff"  # we've only modified the temp object!
	> teacher.save                   # runs SQL UPDATE to save on db
 
__Using Mass Assignment:__ 

You can also use the `update_attributes` method with all of your attributes as `key: value` arguments. It's the same syntax as you would use with `new` only this is with a pre-existing record. Since we already have the object, `update_attributes` returns a boolean instead of the object, so we can use that for verifying the operation was successful.  

	> teacher.update_attributes(first_name: "Jeff", last_name: "Russ")
	  # runs SQL UPDATE
	 => true
________________________________________________________________________________
## Delete/Destroy Records  

Notice the title says "destroy records" and not "delete records". There is a `delete` method bypasses some Rails features and will not behaive as you expect so it's better to use the `destroy` method. The `delete` method will leave you with an "orphaned row" and `destroy` will not. After you run `find`:  

	> teacher.destroy # runs DELETE on actual database only
		=> you'll see a "frozen hash" here

The hash still sits in memory even though it was deleted from the database. It's is "frozen" which means you can't edit it but you can use this object and it's frozen hash to display information on what was deleted to the user or something else like load the data into a different table. The frozen hash could be handy.  

NOTE that whatever id was used by the deleted record is then abandoned. Future records will not take over this id integer but rather then will just increment the last id, whether or not it still exists. You can reset the SQL `AUTO_INCREMENT` value but this is not recommended unless you have a good reason!  

	SQL> ALTER TABLE tablename AUTO_INCREMENT = 1;

Or in SQLite:

	SQLite> DELETE FROM sqlite_sequence WHERE NAME = 'tablename';

In RoR:

	> tablename = YOUR_TABLE_NAME
	> SQL_STRING = "DELETE FROM sqlite_sequence WHERE NAME = '#{tablename}';" # or whatever your db expects
	> ActiveRecord::Base.connection.execute(SQL_STRING)

You can also delete the entire contents of a table with:  

	> ModelName.delete_all  # fast, straight to SQL way
	> ModelName.destroy_all # checks dependencies and callbacks first
	
________________________________________________________________________________
# Database Finders & Queries  
________________________________________________________________________________

Most of your interaction with the database via Rails will actually be queries (reading data, not writing). For that reason, Rails provides more than one way to do this.  

Remember the distinction between normal __ActiveRecord__ and what has been called __ARel (Active Relation)__ outlined before. When it comes to making queries to the database, you have a choice between these two . The former includes methods like `find` and the various `find_by` methods we will see next. They execute a single statement of SQL and do so immediately. The later include methods like `where` which are used to gradually "compose" a complex SQL queries until the time comes to run it.  

Be aware that some `find_by` related methods are deprecated, about to be removed or simply neglected in favor of the newer ARel Query methods. This guide tries to stick to only the common `find_by` methods but don't be surprised if one or more methods are removed by the time you read this.  
________________________________________________________________________________
## Finder Methods

Note that `find` is often not the ideal choice. The reason for this is that when it fails, it returns a severe error called `ActiveRecord::RecordNotFound` which usually results in a __404__ page to the user. Therefore you should only use `find` if you really are sure that the object exists, which by the way is not unusual.  

Our alternative is __"Dynamic Finders"__. The dynamic finder for id (primary keys) is `find_by_id` and they are others for different attributes. Unlike `find`, dynamic finders don't return and error, they return `nil` which is much easier to deal with. When they are sucessful, they return the record object. The reason they are called dynamic is that Rails creates one for each attribute in the model:  

	object = Model.find_by_attributename(value)

Dynamic Finders are actually "missing methods" handled by a Rails method called `method_missing` which takes the method name you typed, picks it apart and assembles a query (WHERE in SQL) using the parts of the name then __runs it right away returning ONLY first one that it finds.__ It's can be acceptable practice to use `find_by_id` but some of the other among the infinite possibilities should be avoided. Here is one that you might or might not want to use with our example:  

	> Teacher.find_by_first_name("Jeff")
	  # SQL SELECT
	 => # the hash

________________________________________________________________________________
## ARel Query Methods   

As you already know, ARel queries wait until they are needed before actually being performed. __Query Methods__ don't return an array like ActiveRecord does, they return an __Relation Object__, which can then be chained together with other query methods and when you are done, Active Relation will take them all and construct one big SQL statement. This way it's much more efficient.  

### The \`where\` Query Method  

`where` is one such query method and is named after the SQL `WHERE` clause it generates. If you execute this in the  __Rails Console__, you will actually see the resulting SQL printing back to you even though it wasn't run in the database yet. 

	> relation_object = Model.where(condition)
	  # preview of SQL
	 => #<ActiveRecord::Relation [ ... ]

Condition could be something like `id: 1`. We can chain `where` (or any ARel method) calls and the resulting SQL will be single complex statement including both conditions:

	> relation_object = Model.where(condition).where(another_condition)
	  # preview of the complex SQL statement
	 => #<ActiveRecord::Relation [ ... ]

But often you would just have multiple conditions (actually a hash) in one `where` call's argument instead and you'll get the exact same results. 

	> relation_object = Model.where(condition, another_condition)

You can grow your query statement over time by calling `where` (or any ARel method) 
on it repeatedly or all at once with chained methods: 

	> relation_object = Model.where(condition)
	  # preview of SQL
	 => #<ActiveRecord::Relation [ ... ]
	> relation_object = relation_object.where(another_condition)
	  # preview of the complex SQL statement
	 => #<ActiveRecord::Relation [ ... ]

Each point along the process you get a preview of the SQL. You can also preview the resulting SQL later by calling `.to_sql` on the __Relation Object__.

	> sql = relation_object.to_sql
	  # preview of SQL
	 => #<ActiveRecord::Relation [ ... ]

Even when there is only one possible match, you still get an `ActiveRecord::Relation` array. You can force it into not being an `ActiveRecord::Relation` array with `first`: 

	> output = Model.where(id: 1).first
	  # or
	> output = relation_object.first

And then you don't have an array or an `ActiveRecord::Relation` object of any kind, you have a hash.  

__Executing Queries Composed with ARel__

Once you have assemble a usable query you can call a method called `find_by_sql` on the Model, using the output of `to_sql` called on the ARel object. 

	> Model.find_by_sql(relation_object.to_sql)
	  # Executing SQL
	 => result as hash

Note that the above examples use the hash style argument. There are three possible arugument styles:  

1. __where with STRING... `Model.where(raw_SQL_string)`:__ 
   
   __BEWARE__ of how you use `where` when taking __raw SQL string__ because it invites the possibility of __SQL Injection__. If you give the user control of even a part of this string they could abuse it to insert malicious code. You should generally only use hard-coded strings that take no user input either directly or from data in the database that might have originated from user input. Even though the example below looks as if the string in the argument is Ruby, it's actually SQL (remember that model's attributes and their values are actually in hash syntax in Rails, not using an equal sign assignment operator)  
   
		relation_object = Client.where("orders_count = '2'")
   
   This is actually a conditional statement, at least in the resulting SQL, where it evaluated as true when `orders_count = '2'` Within these strings, you can insert variables using Ruby's string interpolation like `"orders_count = #{var}"` and, depending on how that `var` is set, this could be where the danger lies.  
   
2. __where with ARRAY... `Model.where([template_w_placeholders, inserts...])`:__ 
   
   The alternative to using a full SQL string is to use an __array__. The first element of the array is a __template__ that contains portions of SQL together with __placeholders__. The remaining element(s) are the inserts for the placeholders. This array argument way is safer because Rails has a chance to escape the inserted SQL before running it.  
   
		relation_object = Client.where(["orders_count = ?", 2])
   
   The square brackets here are actually optional, either way it will be interpreted as an array. The question mark `?` is the placeholder and `2` will be inserted in it.  
   
3. __where with HASH... `Model.where(hash_as_condition)`:__ 
   
   This option also provides safe SQL escaping and is a simpler approach compared to both strings and arrays. Each key-value pair will be joined by an SQL `AND` before generating the SQL `WHERE` clause.   
   
		relation_object = Client.where(orders_count: 2, shipping: "free") 

### Other Query Methods 

`where` is the most common query method but there are several others:  

	order(sql_fragment) # sort results alphabetically, reverse, etc  
	limit(integer)      # limit the number of results to `integer`  
	offset(integer)     # skip first `integer` result. example: see records 20 to end  

These are all chainable with each other and `where`. The order of the chaining doesn't _usually_ matter  

__Syntax for sql_fragment in `order` Method's Argument:__ 

The format for this argument roughly follows `table_name.column_name ASC /DESC`. Since we are calling `order` on a Model which essentially IS a table, we often do not need the `table_name` part of this argument. It's not necessary for for single tables but it is recommended for joined tables and REQUIRED when joined tables have the same column name. So if you have a `users` table joined to a `login_password` table you might want to specify where `name` is:

	User.where(account: "pro").order("users.name ASC")

This will find all pro users and sort them in ascending order by name as it appears in the users table. You can also have multiple arguments: 

	User.where(account: "pro").order("users.visible DESC, users.name ASC") 
________________________________________________________________________________
## Custom Queries with Named Scopes

So far we have interacted with the database with methods provided to us by the Rails Framework. We didn't need add any functionality to our Models in order to perform these queries and other CRUD operations. We also have __Named Scopes__, which allow us to define custom queries in our models using multiple __Active Relation query methods__. Our resulting __Named Scopes__ can be called taking arguments just like pre-existing Rails methods. Prior to Rails 4, __Lamda Syntax__ was option in them but now it's required.  

This is roughly how you define a scope in your model:

	scope :name_of_scope, lambda { where(active: true) }

Scopes are placed in your Model file class and most people put them before any method `def` blocks.   

You can use __"Stabby Lambda Syntax__, but be aware there are actually some subtle implementation differences so we won't be using this:  

	scope :name_of_scope, -> { where(active: true) }

Be aware that these both are really identical to just creating a class method like below. They are just a little nicer syntax to work with.

	def ModelName.name_of_scope
	  where(activ: true )
	end

The reason why lambda syntax is now required is that lambda are evaluated when they are called and not when they are defined. This matters when you use things like `Time.now` since you want that to be evaluated each time the lambda is called. This created a lot of errors and confusion to lambdas were made a requirement.   
	
__Named Scopes Taking Arguments:__ 

Here is the scope taking an argument. Note that this is one case where the __Stabby Sytax__ would not be the same:  

	scope :account, lambda {|acc_type| where(account_type:> acc_type )}
	
This would be called like: `User.account('pro')`  

__Named Scoped can be chained when they are called__ and can also have chainging within them, making for some really compacted sytax that would otherwise be a quite verbose set of queries.   
________________________________________________________________________________
## Rails Console Query Output Formatting

If you have done queries directly in SQL you'll know that the format of the output is much better than we see with ActiveRecord in the rails console. Although not necessary, it might be nicer and easier to read if we can get a more formatted output from the rails console. One, non invasive, option is to ask for YAML output with a `y`:  

	> y Teacher.all  # or...  puts Teacher.all.to_yaml
		- !ruby/object:Teacher
		  raw_attributes:
		    id: 1
		    classroom_id: 
		    first_name: Jeff
		    last_name: Russ
		    created_at: '2016-04-08 19:11:38.912743'
		    updated_at: '2016-04-08 19:35:03.534709'
		# etc....
		
For a SQL-like format, you can use the hirb gem by cldwalker:  

	> exit
	$ echo "# for formated queries in rails c" >> Gemfile
	$ echo "gem 'hirb'" >> Gemfile
	$ bundle install
	> rails console
	> require 'hirb' # might not be needed
	 => true (just loaded) or false (already loaded)
	> Hirb.enable
	 => true
	> Teacher.all
	
	Teacher Load (1.5ms)  SELECT "teachers".* FROM "teachers"
	+----+--------------+------------+-----------+-------------+-------------+
	| id | classroom_id | first_name | last_name | created_at  | updated_at  |
	+----+--------------+------------+-----------+-------------+-------------+
	| 1  |              | Jeff       | Russ      | 04-08 19:11 | 04-08 19:35 |
	| 2  |              | Dennis     | Richie    | 04-08 19:23 | 04-08 19:23 |
	| 3  |              | Yukihiro   | Matsumoto | 04-08 19:28 | 04-08 19:28 |
	+----+--------------+------------+-----------+-------------+-------------+
	3 rows in set

Much easier to read! 
________________________________________________________________________________
# Database Associations
________________________________________________________________________________

Relational databases make it easy to link tables together using __foreign keys__ and __joins__. If you want to work with data in related tables you could go about that by looking at a record's foreign key and then finding the related data by making a second query to to the related table but this is a bit tedious. It would be best if our Ruby side of things had prior knowledge about the relationships between tables and in fact it does. __ActiveRecord__ has what it calls __associations__ that are used to define relationships between data in separate tables.  
________________________________________________________________________________
## Associations In Our Example 

__INSERT STUFF__

Let's first look at how the relationships are conceived of in RDBMS and in Rails. There are three main __types of data model relationships__:  
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
example: __students \<- JOIN -\> courses__
	* a course `has_and_belongs_to_many :students`
	* a student `has_and_belongs_to_many :courses`
	* this must be a __JOIN__ since we have two foreign keys 

Your first observation of this should take note that whenever you see `belongs_to`, you also see __foreign key__. Whatever side does belongs to something else is the side with a foreign key in it's table. The _sort of_ exception to this is Many-to-many, where the foreign keys are actually stored in a third table called a __JOIN__ which we shall see later.  

The second observation should be that the One-to-One relationship says (reversible) this means that either side can be the keeper of the foreign key and have the `belongs_to` method.  

One-to-Many is not reversible and the many is the side that is the keeper of the foreign keya and has the `belongs_to` method.  

Keep this example in your memory and/or refer back to it as we will need it in future sections.   

__Rails Associations Methods__

The method `has_and_belongs_to_many` is used for this many-to-many and is often spoken of as "the HABTN method." It's essentially both `has_many` and `belongs_to` rolled into one. These, together with `has_one` make up the four macro-like methods for database associations provided to us by the Rails framework. They all accept symbols repesenting the models as arguments. Here 
are some things things to adhere to: 


* Each symbol has a plural form which must be used if appropriate
* Both sides should have have their associations specified
* The `belongs_to` side should have the foreign key
* The method declarations should be in the model class, often at the top 

__What Do They Do? THIS ALL MIGHT BE BOGUS INFO__

One concept that is important to understand is that the __inclusion of association methods in the Model classes has no direct effect on the database's schema__. It does not change anything about what happens when you run the migrations because does not effect the schema. For this reason, you can run the migrations before adding the association methods to the Models if you choose.  

Unless your foreign key field is required, you can create a row on that table that is completely disconected from the other table. 

When you define foreign keys and Join tables in the migration files and then run the migrations, you set up the possiblity of connecting records but that connection is not made until you actually populate the database with data. __Association methods simply provide the Rails programmer with methods used to connect rows of the table using the foreign keys and Join tables defined in the migrations__. 

Strictly speaking, on the database, _tables_ are NOT related to other _tables_, _rows_ are associated with _rows_ in other tables _because_ the table has a foreign key column.  

Once you have your schema loaded into the database you can start making actual records. __The methods added to the Models by the inclusion of association methods change what happens when you set a row's foreign key and this is when the association is made__
________________________________________________________________________________
## One-to-One Relationships

__As Per Our Classroom Example:__  

This is the easiest relationship to understand and set up. You have two single objects connect to each other: __classroom and teacher__. You have a choice to set this up in either direction: with classroom `belongs_to` teacher or teacher `belongs_to` classroom. It usually makes no difference in practice and is just a conceptual preference.  

However, you must note the fact that the __foreign key is stored with the object that__ `belongs_to` __and not the one that__ `has_one`. If we decided to have classrooms `belongs_to` their teacher, we could do this but we would put the foreign key on the classrooms table and then set up the classroom model to `has_one` teacher. 

The reason for this will be clear when you see the __One-to-many__ relationship which also follows this rule. 

__When Should we Use One-to-One Relationships?__  

One-to-one Relationships are __used to reject the possiblity of anything other than mutually unique ownership between to entities.__ For example, a US citizen has one and only one Social Security number and each SS number can only belong to (or be belonged to by) one citizen. Knowing that this will never change makes using a one-to-one relationships with person having `has_one :ss_number` ss_number having `has_one :person`. Whichever one has `belongs_to` also has has the foreign key, the choice is yours.  

__One-to-one relationships are not used very commonly__ because often the data they refer to could just be a single model/table.A good reasons for splitting them up might be performance or privacy. For example you might have a Customer model/table with phone number for each person and find your self doing most of your queries for the phone number and not any of the other attributes. Imagine you have a call center that really only needs the people's names and phone numbers. In this case __you might choose to break off a separate, smaller table__ called phone_numbers. This will speed up queries and hide non-essential data like credit card numbers.  

All told, you may want to avoid one-to-one relationships unless you have a good reason. They are often clunky and result in a database with too many tables. Also, if your schema evolves and you wind up adding a "row" for something you will then be dealing with "many" and you will need to break your associations and set up a new schema.   

__To Sumarize:__  
>
* one-to-one relationships are not very common  
* use one-to-one to break up tables or...  
* to reject the possibility of additional assocations or..   
* use one-to-one to help with frequent queries performance  


__Remember to reload console after changing association methods!__ When you do this you will see that objects created from the models actually had new methods magically added to them behind the scenes. Take this as a premise:  

> Create and setup `User` Model (without association) and migration  
> Create and setup `Page` Model (without association) and migration with foreign key

	$ rake db:migrate # creates tables `users` and `pages`
	$ rails console
	> first_user = User.new
	> first_page = Page.new

> In `User` Model, add `has_one :page` This gives it `.page` method  
> In `Page` Model, add `belongs_to :page` gives it a `.user` method  


The Rails association methods acutally generated customly named methods in both models, each one named to match the other Model's table name in the actual database. Each of these methods can be used to set the association with a row on the other table OR to see if there currently is one already set:
	
The `User` object `first_user` now has:
>* for getting: `first_user.page`   
>* for setting: `first_user.page = first_page`  

The `Page` object `first_page` now has:  
>* for getting: `first_page.user`  
>* for setting: `first_page.user = first_user`

__NOTE__ that the method names rails creates don't exactly match the table names. The method names are singularized tables name when there is a singular relationship and the same as the table (already plural) table name when there is a plural relationship. It's the name naming we passed into the association methods in the model's class definitions.   

Since the two objects we instantated in the console were defined BEFORE we changed their class's definitions they do not have these methods! The class defintions are loaded into the console when the console is started. Not only do we have to re-instantiate the object, we need to first restart the console:  
	
	> first_user.page # NO METHOD ERROR
	> first_page.user # NO METHOD ERROR
	> exit
	$ rails console
	>
	> first_user = User.find(1)
	> first_page = Page.find(1)
	>
	> first user.page # we no longer get the error!
	> first_page.user # we no longer get the error!

__NOTE__ that the two method names on the two different sides seem to indicate an identical functionality but they actually behaive differently depending according association method you placed in the model's class. This difference will be clarified ones we get our hands on an actual working example but here is a spoiler:  
>
* `belongs_to_other.other = other_obj` does NOT automatically save  
* `has_one_other.other = other_obj` DOES automatically save and right away  


### Updating our Example's One-to-One Relationships  

With our example: `Teacher` and `Classroom` we already have the foreign key and index in the Teachers migration. We then add:  

> `Teacher` model class `belongs_to :classroom`  Page
> `Classroom` model class `has_one :teacher`   Subject

When you have these associations added, it triggers Rails to do some magic behind the scenes. It sets up some automatic methods for you for both models. 

__Associating Two Specific Records:__  

First let's make some classrooms and instatiate some teacher objects:  

	$ rails c
	> room1 = Classroom.create(room_num:111)
	> room2 = Classroom.create(room_num:222)
	> room3 = Classroom.create(room_num:333)
	> teach1 = Teacher.find(1)  
	> teach2 = Teacher.find(2)  
	> teach3 = Teacher.find(3)  
	
Now that we have association methods set, we have new methods for each object:   
  
> `teach1.classroom` and `room1.teacher`  

The above two are meant to return the object on the other side of the relation if it exists or `nil` if it doesn't. Here are those methods for assignment:    

> `teach1.classroom = room1` or `room1.teacher = teach1`

As we started to say before, the two might seem to be the same but they are not. __Assigning an object to a object with a `belongs_to` association does not automatically save the object.__ It does not save the associated object either. This might seem backwards since the object with `belongs_to` is the one with the foreign key but it's true. You can use either but if you run `teach1.classroom = room1` you must then run `teach1.save` OR `room.save`. Doing so adds the foreign key and then saves both to the database. Let's do it the better way. First a test:   

	> teach1            # notice that `classroom_id` is empty
	> teach1.classroom  # => nil 
	> room1.teacher     # => nil

Now let's make the assocation: 

	> room1.teacher = teach1  
		  Teacher Load (0.2ms)  SELECT  "teachers".* FROM "teachers" WHERE "teachers"."classroom_id" = ? LIMIT 1  [["classroom_id", 1]]
		   (0.2ms)  begin transaction
		  SQL (0.4ms)  UPDATE "teachers" SET "classroom_id" = ?, "updated_at" = ? WHERE "teachers"."id" = ?  [["classroom_id", 1], ["updated_at", "2016-04-09 04:26:53.364744"], ["id", 1]]
		   (2.5ms)  commit transaction
		+----+--------------+------------+-----------+-----------+------------+
		| id | classroom_id | first_name | last_name | created_at| updated_at |
		+----+--------------+------------+-----------+---------- +------------+
		| 1  | 1            | Jeff       | Russ      | 16-04-08  | 16-04-09   |
		+----+--------------+------------+-----------+-----------+------------+
		1 row in set

It's pretty obvious that it worked but let's check:  

	> teach1            # now it `classroom_id` is NOT empty
	> teach1.classroom  # now it returns the row from classroom table 
	> room1.teacher     # now it returns the row from teacher table
	> Teacher.find(1)   # db show `classroom_id` is NOT empty

__Quick edits suggestions for use in development ONLY:__  

If we know the two id's we can actually do the entire thing in one line, without any variables like this, but __beware__ because it has no error handling!!:  

	> Classroom.find(2).teacher = Teacher.find(2)

If for some reason we had to do it from the other side we can do:  

	> (Teacher.find(3).classroom = Classroom.find(3)).save 

Even more extreme, you can do this to each active row in the entire table:  

	> Teacher.ids.each {|i| t = Teacher.find(i); t.classroom_id = i; t.save }

__Removing the Association Made:__  

You can remove the association without removing the actual data by:  
>
* `teacher1.classroom_id = nil`  
* `teacher1.classroom = nil`  
* `room1.teacher = nil`  
* `classroom.teacher.delete`  
* `first_teacher.classroom.delete` 

Or we can adapt our previous mass assignment iterator to be a mass unassigner:  

	> Teacher.ids.each {|i| t = Teacher.find(i); t.classroom_id = nil; t.save }

`.delete` in this case will not delete the record, only the foreign key. To destroy the record and remove the association to it:  
>
* `classroom.teacher.destroy`  
* `first_teacher.classroom.destroy`  

After `classroom.teacher.destroy` if you then run `classroom.teacher` it still shows it the teacher object, but in frozen state. The frozen state does not last forever though. If you search for classroom again it will be gone.  
________________________________________________________________________________
## One-to-Many Relationships

One-to-many relationships are much more common than one-to-one relationships and are perhaps the most common of the three.  

__As Per Our Classroom Example:__  

You might remember seeing that the the "foreign keys should go on the `courses` tables." and you might have wondered why. Think of it this way: if you have a single object attached to many, it makes more sense to have each on the the "many side" store the relationship to the single object. Otherwise, the single object would need many foreign keys, one for each of the many objects it's related to. Each of these would require an addtional column for the foreign key. This gets messy and it makes a lot more sense for each record the "many side" to have a single foreign key.  

For this reason, we have foreign key on the `courses` table, each pointing to the teacher that `belongs_to` it. To abstract this out of our example, the __foreign key MUST go on the table that__ `belongs_to` __when the thing it belongs to__ `has_many`, similar to what we saw with 1:1, only now it really matters since we are dealing with a `has_many`.


__About One-to-Many Relationships:__ 
>
* Possibly the most common used of the three
* Use the plural form of the model symbol in the `has_many` declaration
* Used when an single thing "collects" many things of another type AND
* When many the many things EXCLUSIVELY belong to one  

__Differences to One-to_One__  

The method name for the model that `has_many` is now plural and it's: 

* assignment with `=` form only takes arrays ( `= [obj1, obj1]`)  
  * assignment `= [with, array]` __removes all previous association!__  
* new append operator `<<` pushes one object ( `<< obj1 `)
  * assignment `<<` adds to previous assocations
* chain with: `object.others.delete(obj1)` to remove association with obj1
* chain with: `object.others.destroy(obj1)` to destroy obj2 completely __(NEEDS JOIN?)__
* chain with: `object.others.clear` to remove all associations
* chain with: `object.others.size` to return number of associated records
* chain with: `object.others.empty?` returns `true` if there aren't any 
* chain with: `object.others.where(id: 1)` further refines the return

### Updating our Example's One-to-Many Relationships 

Remember that our school example has a one-to-many relationship between Teacher and Courses. We already have the foreign key in the Courses migration associating each to it's respective teacher. Now add:  

> `Teacher` model class `has_many :courses`  
> `Course` model class `belongs_to :teacher`   

Now let's load up our teachers and create some courses:  

	$ rails c
	> Hirb.enable; teach1 = Teacher.find(1); teach2 = Teacher.find(2); teach3 = Teacher.find(3)
	> Course.column_names # to remind us => ["id", "teacher_id", "name", "description", ...]
	> art = Course.new(name: "art", description: "Art")	
	> art.class
		=> Course(id: integer, teacher_id: integer, name: string, description: text, created_at: datetime, updated_at: datetime) 

Let's leave `art` unsaved to preform a test. Now let's make a bunch more with `create` using the magic of Ruby's `eval` function which takes Ruby code as a raw string and exectutes it. Here we make a method that iterates over an array of strings and each will be set as the value in the `name:` column. The method will return a hash of all the course objects we created, with the keys being the symbol form of the strings for `name:`. First have a look at the method is a more readable form:  

	def create_courses array
	  h={}; arr.each do |c|
	    eval "h[c.to_sym] = Course.create(name: '#{c}')"
	  end 
	  return h
	end

You could actually make this a class method in the `Course` class and then make different ones, each slightly modified for each of the model classes. Or you could just spill it out in one line in `rails c`.

__TIP__ You can always type `ActiveRecord::Base.logger = nil` if you want to silence SQL output from view in the console.  

When we call this method we can use `%w[bio chem debate etc...]` which is shortcut for `["bio", "chem", "debate", etc...]`

	> def create_courses(arr) h={}; arr.each {|c| eval "h[c.to_sym] = Course.create(name: '#{c}')"; }; h; end
	> c = create_courses %w[bio chem debate english french geography health]
	>
	> c[:bio]  # returns the row for bio class
	> c[:chem] # same, but for chem class
	> c.values # shows all newly added rows in table
	> 
	> c[:bio].description = 'Biology Class'
	> c[:bio]  # now shows field is filled
	

This is still a modular approach in that we stored the method for future use, but it makes it be two lines. For a one off you could do:  

	> Course.create! %w(bio chem debate english french geography health).map{|c| {name: c'} }

but you won't be able to access what you just made without getting them out of the database. 

__Fdskla__

	Course.all.each { |r| eval "#{r.name} = Course.find(#{r.id})" }

__Associating Specific Records__

Note that `art` is just a temporary object. We could explicitly `.save` it before assigning it to ateacher but let's see if assignment will also save it. Let's first try mass assignment with `= [an, array]`. Remember from one-to-one, the object with `belongs_to` does not save when assigned to. In this case that's the `Course` object. Based on that, let's assume `Teacher` objects should automatically save and since it's a `has_many` it's the only side that can accept an array anyway so we'll try it out:  

	> teach1.courses = [art, bio] 

Now let's set some associations. This time we aren't just assigning an attribute, we are setting the contents of an array. 

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
	  
__Removing the Association Made:__ 

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
________________________________________________________________________________
## Many-to-Many with Model-less Joins

In the case of Many-to-many, it's far too complicated to have foreign keys on each of the two tables for the same reasons we saw the `has_many` table not being the suitable table to hold foreign keys, only now the issue has grown to BOTH tables with `has_many`. For this reason we bring in a third table to handle all the relationships. This third table is called __JOIN table__ which will store the __two foreign keys required for each Many-to-many relationship__. Let's refer back to the chart of our school example's associations:  

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_join.png)  

That mess of connections is now encapsulated in another green box. This is called a "join table" in relational database terminology and in fact __JOIN__ is a keyword in SQL. The Join's primary job is to hold the foreign keys for multiple tables so they don't have to. The naming convention in Rails is to name the table with the names of the two tables it joins, with an underscore between them. Of course, like all table names, the name will be two plural words. __IMPORTANT:__ Rails expects these two table names to be in __alphabetical order__ in the join table's name. You can configure Rails to use some other name but things won't work automatically unless you follow these conventions.  

__Join tables dealing with two Models in Rails have:__ 
>
* Two foreign key columns
* index for each foreign key pair, preferably one array w/two elements handling both
* NO PRIMARY KEY COLUMN in Rails joins! `id: false`

When you have two many-to-many tables, each row "has many" AND each "belongs to" many rows found on the other table. This combination of relationship is special and therefore has special treatment in Rails. We use: `has_and_belongs_to_many`.

### Updating our Example's Many-to-Many (Simple) 

Add these to the model classes:  

>`Course` model class `has_and_belongs_to_many :students`   
>`Student` model class `has_and_belongs_to_many :courses` 

Now we can run `generate`. With this simple many-to-many, our __JOIN__ will not need a model class so we'll create a migration file directly:  

	$ rails generate migration CreateCoursesStudentsJoin

The naming of this migration is just for clarity, the actual name of the table is more strict. This generate command will assume a table name based on our typing of `CreateCoursesStudentsJoin`. It will know that "Create" is should not be part of the table name but it may not know that "Join" should not. In other words you might see in the code:  

	create_table( :courses_students_joins )

Because it thinks the name of one of the tables is actually `students_joins` which is incorrect. We __must__ change it to: 

	create_table( :courses_students, id: false )

Notice that we also added `id: false`. The default for newly created tables is to add a primary key but we, again, __JOINS must not have a primary key!!__. Therefore we have to __suppress it with the__ `id: false` __hash__. 

Now we need to create three things: the two foreign keys, which are integer id's and one index to handle both of them.  

	class CreateCoursesStudentsJoin < ActiveRecord::Migration
	
	  def change
	    create_table( :courses_students, id: false ) do |t|
	      t.integer "course_id"
	      t.integer "student_id"
	    end
	    add_index( :courses_students, ["course_id", "student_id"])
	  end
	
	end

Notice that the second argument for `add_index` is now an array since we are dealing with two id's. This migration file is now complete and we can run `$ rake db:migrate` to create the join table. 

__ADD HERE overriding of :class_name in model and join table's name in model these go after assocation methods__

Note that at this point, no SQL JOIN clause has been run. We simply have a table with two id's and an index.   

__Associating Specific Records__

For this exercise you should have two courses and two students added to your database. You would do this the same way as you would with any other table with a Rails model. Also have the four records queried and saved to objects. the following assumes you have the four named as `course1`, `course2`, `student1`, and `student2`: 

	$ rails console
	> course1.students << student1
	> course1.students << student2
		# now let's use the array assignment way with course2
	> course2.students = [student1, student2]
________________________________________________________________________________
## Many-to-Many with Modeled Joins

When we associated students to courses all we did was record the fact that the two are linked without any further details about the relationship. In some cases it becomes necessary to record more details about the nature of the association. In our example's Student and Course models, we might want to keep track of what semeseter the student took or is taking the course, their grade, etc. All of this should go in the join table since it's the joins role to keep track of anything relating to both records in relation to each other.  

For this we need to restructure our Rails association methods. Before we had this:

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_join_model-less.png)  

Notice there is no Model defined in our code for the join table. Now we will actually define one with a different, more suitable name and give it two association methods. We will also change the associations in the other two models:  

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_join_with_model.png)  

Be aware that there is a better way to do this but for the sake of learning we will use the above association methods.  

__Keys in Join Models__

Our join will still have two foreign keys but now that __we have a model for it we must have a primary key and id__ because we will be performing CRUD operations on it and they should be fast and efficient!  

__Naming Join Models__

__When we create the join with an explicit model we no longer need to follow naming convensions and can give it a more descriptive name.__ Usually these join tables end with "__-ments__" or "__-ships__" as in "assignments" or "memberships." Usually there is one model name in this name like ""course enrollments" but since it's self apparent that "enrollments" involves students and teachers we can keep it short. It's a matter of preference.  

__Associations In Models that use a Modeled Join__

Also, __now that our join has a defined model, we need to have the two associated models it joins point to the join rather than each other.__  

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

Since we need both a model and migration we ran `rails g model`, which also makes the migration. Also, remember that models are singular and migration are plural. Running this created a `CreateEnrollments` migration, plural:  

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

A couple of things to note: unlike the model-less join, we do not need to add `id: false`. We need a primary key so we'll let the default take over. Also note that, since we used `t.references` instead of `t.integer`, we can leave off the `_id` at the end. We used an array to handle the two foreign keys at once.  

At this point we don't have any functionality that we lacked in the model-less join. Let's add the student's grade in the course, right before `timestamps`:   

	t.decimal :grade, precision: 5, scale: 2

We used `decimal` because it has fixed precision and is not floating point. `:scale` determines the number of digits after the decimal point and `:precision` determins the total number of digits. Now let's add something to show if the course is an elective or required:  

	t.boolean :elective, default: false

Now we can run `rake db:migrate` and move on to defining the model files which are empty classes at the moment. Add the following:  

>`Course` model class `has_many :enrollments`   
>`Student` model class `has_many :enrollments` 
>`Enrollment` model class `belongs_to :courses`
>`Enrollment` also should `belongs_to :students`


Remember that there is a better way to do this but for the sake of learning we will use the above association methods.  

__REVIST DEFAULT OVERRIDES:__ 

Note that at this point, no SQL JOIN clause has been run. We simply have a table with two id's and an index.   

__Associating Specific Records__

For this exercise you should have two courses and two students added to your database. You would do this the same way as you would with any other table with a Rails model. We have to handle the joins differently now that we have a model for the join table. Let's say a student visits the registrar and says he needs and elective. The student is looked up and `student1` is made. The desired course is looked up and `course1` is made, then:  

	$ rails console
	> student1.enrollments  # shows no courses. same for student2
	> course1.enrollments   # show no students. same for course2
	 
Next we open up a new enrollment object (the join) and set it to elective.  Since it has a model, we need to work with this join object. After we set it to elective we will add it to the course

	> enroll = Enrollment.new
	  => # you'll see keys but all nil
	> enroll.elective = true    
	> course1.enrollments << enroll
	
`<<` will automatically save the `course1` record. If we used the `=` assignment operator we would need to run `.new` on it to save it. Now we have `course1` with an unknown student as an elective. We could do this:  

	> course1.enrollments << student1

But let's do it this way: 

	> enroll.enrollments = student1 
	> enroll.save
	
__GOTCHA:__ You might thinks all is well since you ran `.save` but it's not. If you look at `course1.enrollments` you'll see that the student was added BUT if you look at `student1.enrollments` you won't see the course added! We need to reload `student1` from the database:  

	> student1.enrollments(true)
	> student1.enrollments 
      => # now you'll see it!

This reveals that `.save` only saved to the database but did not update our instantiated `student1` object. If we use `<<` on the JOIN table object it will save in both places. __BEWARE OF THIS__ since it leaves you with an out of sync object.  

__Using Mass Assignment__

Another to to associate two records that have a modeled join is to simply do it all with mass assignment to the join object. You'll still need to have student and course objects ready to go but this way is ultimately much quicker:  

	> Enrollment.create(student: student2, course: course2, elective: true)

__BEWARE OF THIS__ too since it also updates the database but not the object. We need to run this:  

	> student2.enrollments(true)
	> course2.enrollments(true)
	
Now the objects are updated to the new state of the database.  

### Traversing our Example with a Join Model

Before if we wanted to get a student's associated course data we could run `a_course.students` and get an array. We can't do that now since courses has no direct relationship with students and visa-versa. They instead both have a relationship with `enrollments` and we must go to this join to get the other table's associated data like this:  

	a_student.enrollments.map { |e| e.students } 
	
This goes through each enrollment to look up it's students and returns the same array. This is not only more of a pain, it's also results in not very efficient SQL. We want to be able to simple call `a_course.students` and have it __traverse__ the join. To do this, we must tell ActiveRecord about this outer relationship between courses and students. Do to this we use the `:through` hash with our `has_many` declarations.  

### INNER JOIN: __has_many__ with __:through__

The solution is to add to a second relation to each of our two outer models which using `through` which has similar effect as `has_and_belongs_to_many`. 

>`Course` model class `has_many :enrollments`  
>`Course` model class `has_many :students, through: :enrollments`  
> 
>`Student` model class `has_many :enrollments`  
>`Student` model class `has_many :courses, through: :enrollments`

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/db_join_with_through.png)

Basically what these do is say "we have a relatinship with students/courses that you can find out about if you look at the enrollments table." 

__REVIST DEFAULT OVERRIDES:__ 

Now if you go to console and query a student or course you will see the SQL has added an __"INNER JOIN."__ Now the following are available:  

	> student1.courses
		=> # shows course data
	> course1.students
		=> # shows student data
		
and show the other tables data by __"traversing the INNER JOIN."__ This is easier and more efficient but be aware that it's __not exactly the same as a direct assocation in some cases.__ We can use `<<` to add students and courses to each other but __if the INNNER JOIN has required fields we can't sucessfully save the record without adding to the JOIN directly.__ for this reason, you might want to do everything via an object from the JOIN when creating a record and then you can use the way possible with `:through` for modifying existing records. 

## CRUD with Controller Actions and Views


A lot of what we have done so far in the __rails console__ actually belongs in the controllers where the views can interact with them. 

### CRUD Naming Conventions in Rails  

If you keep to the naming conventions with your controller and action names, Rails will generate logical sounding URLs that map to their purpose and the object of their manipulations. 

__Action names and CRUD:__ 

Remember that the methods in Rails controllers are called "actions" and each usually corresponds to a view. Many of the view's purposes have something to do with the database: one might display a list of students or courses, one might allow a student to sign of for a course and another might allow the schools to create or delete a course from their curriculum.  

![missing image](https://s3.amazonaws.com/files.jeffruss.com/img/crud_actions.png)

In terms of what actually happens on the web, the __"HTTP Verb"__ are the only thing that actually exists. They keywords that are actually part of the HTTP response and request messages. The actions are, of course, the names of the methods in the Rails controller classes. THe CRUD operations are really just abstract catergories for the HTTP Verbs and the Rails actions basically 
add views, which are GET requests, to each of the CRUD operations. In this way: 

CRUD __create__ == HTTP __POST__ == Rails __create__  
CRUD __read__ == HTTP __GET__ == Rails __show__   
CRUD __update__ == HTTP __PUT__ or __PATCH__ == Rails __update__    
CRUD __delete__ == HTTP __DELETE__ == Rails __destroy__  

They only odd one here is that we have `destroy` where we expected `delete`. `delete` is actually used to display the delete form, a view/GET. This is because ActiveRecord has a `delete` method and a `destroy` method but, as was pointed out earlier, `delete` has issues and `destroy` is preferred. The action name `destroy` is meant to match this ActiveRecord method. In practice, you won't see the Rails `delete` action very often and if you do, it will be for form display (GET) purposees and not for the calling of `delete`. 
 
All of the CRUD operations have a corresponding Rails action that is GET request.   

Rails adds the GET action/view __new__ for CRUD __create__  
Rails adds the GET action/view __index__ for CRUD __read__  
Rails adds the GET action/view __edit__ for CRUD __update__    
Rails adds the GET action/view __delete__ for CRUD __delete__   

All of these are meant to display a form before modification takes place, with the excpetions of CRUD "__read__", which is already a GET request so Rails breaks it down in to the actions __index__ to show all records and __show__ to show a single one. 

A frequent practice is to place the standard CRUD actions in each controller in the following order: `index`, `show`, `new`, `edit`, `create`, `update` and `destroy` (omitting `delete`). You don't have to follow this order but since they are public methods they must be placed before private or protected method in the controller in order to work. 

__Controller names and CRUD__  

Where action names roughly map out to CRUD operations and Rails ActiveRecord names, controller names should refer to the database model names they work on. They should be __PLURAL__ and will often be one model per controller:    

> `ClassroomsController TeachersController CoursesController StudentsController`

### Generating Controller/Actions/Views for CRUD

Probably the prefered way to get started is to use the generate command and list the actions desired. Let's make a controller for the Classroom model:  

	$ rails generate controller Classrooms index show new edit create destroy
	
Notice we didn't type `ClassroomsController` even though that is what results. Also notice the order of the actions. There is in recent Rails a shortcut to generate this but it will often give you more than you need:  

	$ rails g scaffold_controller Classrooms 
	
`scaffold_controller`, in this case, will generate the following, only with more whitespace which was deleted for this guide:    

	class ClassroomsController < ApplicationController
	  before_action :set_classroom, only: [:show, :edit, :update, :destroy]
	
	  # GET /classrooms
	  # GET /classrooms.json
	  def index
	    @classrooms = Classroom.all
	  end
	
	  # GET /classrooms/1
	  # GET /classrooms/1.json
	  def show
	  end
	
	  # GET /classrooms/new
	  def new
	    @classroom = Classroom.new
	  end
	
	  # GET /classrooms/1/edit
	  def edit
	  end
	
	  # POST /classrooms
	  # POST /classrooms.json
	  def create
	    @classroom = Classroom.new(classroom_params)
	
	    respond_to do |format|
	      if @classroom.save
	        format.html { redirect_to @classroom, notice: 'Classroom was successfully created.' }
	        format.json { render :show, status: :created, location: @classroom }
	      else
	        format.html { render :new }
	        format.json { render json: @classroom.errors, status: :unprocessable_entity }
	      end
	    end
	  end
	
	  # PATCH/PUT /classrooms/1
	  # PATCH/PUT /classrooms/1.json
	  def update
	    respond_to do |format|
	      if @classroom.update(classroom_params)
	        format.html { redirect_to @classroom, notice: 'Classroom was successfully updated.' }
	        format.json { render :show, status: :ok, location: @classroom }
	      else
	        format.html { render :edit }
	        format.json { render json: @classroom.errors, status: :unprocessable_entity }
	      end
	    end
	  end
	
	  # DELETE /classrooms/1
	  # DELETE /classrooms/1.json
	  def destroy
	    @classroom.destroy
	    respond_to do |format|
	      format.html { redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.' }
	      format.json { head :no_content }
	    end
	  end
	
	  private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_classroom
	      @classroom = Classroom.find(params[:id])
	    end
	
	    # Never trust parameters from the scary internet, only allow the white list through.
	    def classroom_params
	      params.fetch(:classroom, {})
	    end
	end
 
 There is a lot in this code that might be foreign to you at this point but the  important takaways are: the order of the actions here follows Rails convention,  the extensive use of `@instance` variables is common for CRUD in the controllers,  and the tests `if @classroom.save` and `if @classroom.update(classroom_params)` are used for error handling. Let's cut this file down by deleting the `private`  methods, making the remaining methods be empty and deleting  `before_action :set_classroom, only: [:show, :edit, :update, :destroy]`.  
 
 

 
 
 
 
 