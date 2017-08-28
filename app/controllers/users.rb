get '/' do
  @questions = Question.all
  erb :'questions/index'
end

get '/users' do
  redirect '/'
end

get '/users/login' do
  if logged_in?
    redirect '/users/profile'
  else
    erb :'users/login'
  end
end

post '/users/login' do
  @user = User.authenticate(params[:user][:username], params[:user][:hashed_password])
  halt(401, erb(:'users/401')) unless @user
  session[:user_id] = @user.id
  redirect '/users/profile'
end

get '/users/new' do
  erb :'users/new'
end

post '/users/logout' do
  halt(404, erb(:'users/404')) unless logged_in?
  session[:user_id] = nil
  redirect '/users/login'
end

get '/users/profile' do
  @user = User.find(session[:user_id])
  erb :'users/profile'
end

post '/users' do
  user_info = params[:user]
  puts user_info
  user = User.new(first_name: user_info[:first_name], last_name: user_info[:last_name],  username: user_info[:username], email: user_info[:email], password: user_info[:hashed_password] )
  if user_info[:hashed_password].length == 0
    user.valid?
    password_error = "Password can't be blank"
  else
    user.save
  end

  if user.persisted?
    session[:user_id] = user.id
    redirect '/users'
  else
    errors = user.errors.full_messages.concat([password_error])
    report_create_errors(errors)
  end

  redirect "/users/profile"
end




