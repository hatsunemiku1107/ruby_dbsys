#! C:\Ruby\bin\ruby.exe -Ku
require 'cgi'
require 'cgi/session'
require 'rubygems'
require 'sqlite3'
require 'digest/md5'
db = SQLite3::Database.new("test.db" )
cgi = CGI.new
puts cgi.header("charset" => "UTF-8")

	begin #Cookieを読み込み、セッションがあるかを確認(なくても生成しない)
		 session = CGI::Session.new(cgi,{'new_session' => false,}) 
	rescue ArgumentError
		session = nil
		puts"既にログアウトしています"
		puts "<a href=\"./login.html\">ログイン</a>"
		exit
	end
	#セッションが存在する
		session.delete
puts "<a href=\"./login.html\">ログイン</a>"
puts"ログアウトしました"
