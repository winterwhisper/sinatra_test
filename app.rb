require 'sinatra'
require "sinatra/activerecord"
require 'haml'
require 'pry'

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

  def paginate(obj)
    per_page = settings.per_page
    count = eval(obj.table_name.singularize.capitalize).all.count
    max_page = (count / per_page > 0 ? (count / per_page + (count % per_page == 0 ? 0 : 1)) : 1) 
    current_page = params[:page].to_i

    html = "<ul>"

    if current_page == 1
      html << "<li class='disabled'>"
    else
      html << "<li>"
    end
    prev_page = current_page == 1 ? 1 : current_page - 1
    html << "<a href='/posts/page/#{prev_page}'>&laquo; Prev</a></li>"

    for page in 1..max_page
      if params[:page].nil? && page == 1
        html << "<li class='active'>"
      else
        if page == current_page
          html << "<li class='active'>"
        else
          html << "<li>"
        end
      end
      html << "<a href='/posts/page/#{page}'>#{page}</a></li>"
    end

    if current_page == max_page
      html << "<li class='disabled'>"
    else
      html << "<li>"
    end
    next_page = current_page == max_page ? max_page : current_page + 1
    html << "<a href='/posts/page/#{next_page}'>Next &raquo;</a></li>"

    html << "</ul>"

    return html
  end
end

#setting global environment variable
# before do
#   @foo = settings.foo
# end

get "/posts" do
  per_page = settings.per_page
  @posts = Post.order('created_at DESC').limit(per_page)
  haml :"posts/index"
end

get "/posts/page/:page" do
  per_page = settings.per_page
  @posts = Post.order('created_at DESC').offset(per_page * (params[:page].to_i - 1)).limit(per_page)
  # binding.pry
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
