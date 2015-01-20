#! C:\Ruby\bin\ruby.exe -Ku
require 'cgi'
require 'cgi/session'
require 'rubygems'
require 'sqlite3'
require 'digest/md5'
db = SQLite3::Database.new("test.db" )
cgi = CGI.new
	begin #Cookieを読み込み、セッションがあるかを確認(なくても生成しない)
		 session = CGI::Session.new(cgi,{'new_session' => false,}) 
	rescue ArgumentError
		session = nil
	end
	if session == nil then
		#ID/PWがPOSTされているかチェック
		begin
			screen_name = cgi['screen_name'].chomp
			password = Digest::MD5.new.update(cgi['password'].chomp)
		rescue ArgumentError
			#POSTがミスっている
			print"不正なアクセスが検出されました。"
			exit
		end
		#空文字チェック
		if screen_name != "" && password != "" then
			#ログインSQL生成
			sql_login_auth = <<-SQL
				SELECT screen_name,password,username FROM login WHERE screen_name = '#{screen_name}' AND password = '#{password}';
			SQL
			#DBへ問い合わせ
			res = db.execute(sql_login_auth)
			if res.length == 0 then#ユーザが存在しない
				puts cgi.header("charset" => "UTF-8")
				puts "ユーザーー名またはパスワードが間違っています\n"
				exit
			elsif res.length != 1 then #ログイン失敗
				puts"技術的エラーが発生している可能性があります"
				exit
			end
			#ログイン成功
			screen_name = res[0][0] #screen_name
			username = res[0][2]#username
			session = CGI::Session.new(cgi,{'new_session' => true,
					                'session_expires' => Time.now + 3600})
			session['screen_name'] = screen_name
			session['username'] = username
			session.close
		else 
			puts cgi.header("charset" => "UTF-8")
			print("IDまたはパスワードが入力されていません。")
			exit();
		end
	else #セッションが存在する
		screen_name = session['screen_name']
		username = session['username']
		session.close
	end
puts cgi.header("charset" => "UTF-8")
puts "<a href=\"./login.rb\">ログイン</a><br>"
puts "<a href=\"./logout.rb\">ログアウト</a>"
puts "#{screen_name}(#{username})さんようこそ！"
