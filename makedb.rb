#! C:\Ruby\bin\ruby.exe -Ku
require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'digest/md5'

puts "Content-type:text/html\n\n"
db = SQLite3::Database.new("test.db" )
sql_maketable = <<-SQL
	CREATE TABLE IF NOT EXISTS login (
	  id		INTEGER		UNIQUE PRIMARY KEY AUTOINCREMENT,
	  screen_name	varchar(64)	NOT NULL UNIQUE,
	  username	varchar(64)	NOT NULL,
	  password	varchar(64)	NOT NULL );
SQL
	db.execute(sql_maketable)
=begin	res = db.execute("SELECT * FROM login")
	res.each{|value|
		puts "#{value}  \n<br>"
	}
=end
	db.close
