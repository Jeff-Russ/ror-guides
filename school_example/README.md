# Steps

## 1. make a landing page

	rails g controller pages home

Set it to root in routes.rb and make a default route.

## 2. Generate School Models

	rails g model Classroom room_num:integer lab_equip:boolean permalink:string:index;
	rails g model Teacher classroom:references first_name:string last_name:string;

	rails g model Course teacher_id:integer:index name:string description:text 

	rails g model Course teacher:references name:string description:text teacher_id:integer:index;
	rails g model Student first_name:string last_name:string;

to undo:

	rails destroy model Classroom; rails destroy model Teacher; rails destroy model Course; rails destroy model Student

Then:

add `, default: false` after `t.boolean "lab_equip"`  


