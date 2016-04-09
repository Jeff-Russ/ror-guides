# Steps

## 1. make a landing page

	rails g controller pages home

Set it to root in routes.rb and make a default route.

## 2. Generate School Models

	rails g model Classroom room_num:integer lab_equip:boolean;
	rails g model Teacher classroom_id:integer:index first_name:string last_name:string;
	rails g model Course teacher:references name:string description:text;
	rails g model Student first_name:string last_name:string;

to undo:

	rails destroy model Classroom; rails destroy model Teacher; rails destroy model Course; rails destroy model Student

Then:

add `, default: false` after `t.boolean "lab_equip"`  


Hirb.enable; teach1 = Teacher.find(1); teach2 = Teacher.find(2); teach3 = Teacher.find(3); room1 = Classroom.find(1); room2 = Classroom.find(2); room3 = Classroom.find(3); 
