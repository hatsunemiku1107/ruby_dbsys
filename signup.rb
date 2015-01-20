#! C:\Ruby\bin\ruby.exe -Ku
require 'cgi'
require 'rubygems'
require 'sqlite3'
require 'digest/md5'
db = SQLite3::Database.new("test.db" )
cgi = CGI.new
print cgi.header("charset" => "UTF-8")

screen_name = cgi['screen_name'].chomp
username = cgi['username'].chomp
password = Digest::MD5.new.update(cgi['password'].chomp)

sql_insert = <<-SQL
	INSERT INTO login (screen_name, username, password) values('#{screen_name}','#{username}','#{password}');
SQL
	begin #dbへ登録
		 db.execute(sql_insert)
	rescue#登録できない
		puts"登録できません"
		exit
	end
sql_regchk =<<-SQL
		SELECT * FROM login WHERE screen_name = '#{screen_name}';
SQL

	res = db.execute(sql_regchk)
	res.each{|value|
		puts "#{value}  \n<br>"
	}
	db.close
