require 'sinatra'
require "sinatra/activerecord"
require 'haml'

#require configurtions
require './application'

#require setting variables
require './settings'

#require models
require './models/models'

helpers do
  def pretty_date(time)
   time.strftime("%Y/%m/%d %H:%M:%S")
  end
end

#setting global environment variable
# before do
#   @foo = settings.foo
# end

get "/posts" do
  @posts = Post.order('created_at DESC')
  haml :"posts/index"
end

get "/posts/new" do
  @post = Post.new
  haml :"posts/new"
end

post "/posts" do
  @post = Post.new(params[:post])
end

get "/posts/:id/edit" do
  @post = Post.where("id = ?", params[:id])
  haml :"posts/edit"
end

get "/posts/:id" do
  @post = Post.where("id = ?", params[:id])
  haml :"posts/show"
end

put "/posts/:id" do
  @post = Post.where("id = ?", params[:id])
end

delete "/posts/:id" do
  @post = Post.where("id = ?", params[:id]).first
  if @post.destroy
    redirect "/posts"
  end
end


























# before do
#   @note = 'Hi' 
# end

# after do
#   #puts "====================="
#   #puts @note
#   #puts "====================="
# end

# #template :layout do
# #  haml :layout
# #end

# get '/:id/:name' do | id, name |
#   "Hello #{id}-#{name}!"
# end

# get '/', :host_name => /^admin\./ do
#   "管理员区域，无权进入！acb"
# end

# get '/', :provides => 'html' do
#   @test_var = "wtf_var"
#   @foo = settings.foo
#   haml :index
#   #haml "%h1 helloworld"
# end
