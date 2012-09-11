# encoding: utf-8
class MyApp < Sinatra::Base
  #session
  enable :sessions

  #reload
  configure :development do
    register Sinatra::Reloader
  end

  #weibo
  WeiboOAuth2::Config.api_key = "3527445027"
  WeiboOAuth2::Config.api_secret = "9de472733a1529e43fbf81e07ad7c65a"
  WeiboOAuth2::Config.redirect_uri = "http://127.0.0.1:9292/callback"




  #首页
  get "/" do
	client = WeiboOAuth2::Client.new
	if session[:access_token] && !client.authorized?
	  token = client.get_token_from_hash({:access_token => session[:access_token], :expires_at => session[:expires_at]}) 
	  p "*" * 80 + "validated"
	  p token.inspect
	  p token.validated?
	  
	  unless token.validated?
		reset_session
		redirect '/connect'
		return
	  end
	end
	if session[:uid]
	  @user = client.users.show_by_uid(session[:uid]) 
	  @statuses = client.statuses
	end

	erb :index
  end

  #链接
  get '/connect' do
	client = WeiboOAuth2::Client.new
	redirect client.authorize_url
  end

  #回调
  get '/callback' do
	client = WeiboOAuth2::Client.new
	access_token = client.auth_code.get_token(params[:code].to_s)
	session[:uid] = access_token.params["uid"]
	session[:access_token] = access_token.token
	session[:expires_at] = access_token.expires_at
	p "*" * 80 + "callback"
	p access_token.inspect
	@user = client.users.show_by_uid(session[:uid].to_i)
	redirect '/'
  end

  #退出
  get '/logout' do
	reset_session
	redirect '/'
  end


  #发送微博
  post '/update' do
	p "!!!"*20
	p params
	client = WeiboOAuth2::Client.new
	client.get_token_from_hash({:access_token => session[:access_token], :expires_at => session[:expires_at]}) 
	statuses = client.statuses

	unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
	  statuses.update(params[:status])
	else
	  status = params[:status] || '图片'
	  pic = File.open(tmpfile.path)
	  statuses.upload(status, pic)
	end

	redirect '/'
  end







  #helpers
  helpers do 
	#重置session
	def reset_session
	  session[:uid] = nil
	  session[:access_token] = nil
	  session[:expires_at] = nil
	end
  end




end
