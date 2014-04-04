require 'sinatra'
require 'data_mapper'
DataMapper.setup(:default, "sqlite3:database.sqlite3")


class Minion 
	include DataMapper::Resource

	property :race, String
	property :id, Serial #minion count, starting at 1
	property :title, String #minion class, like warrior/rogue etc
	property :abilities, Text #description of abilities
	property :created_at, DateTime #when this minion joined your army
	property :avatar, String

	#can add ':required => true' later on to force completion
	#":default => false" ... gives a default value, cool!
end

DataMapper.finalize
DataMapper.auto_upgrade!


Minion.all.each do |minion|
	minion.destroy
end

azure_drake = Minion.create(title: "Azure Drake", race: "Dragon", abilities: "Spell dmg +1, draw a card", avatar: "/azure_drake.jpeg")


get "/" do
	erb :index
end

get "/army" do
	erb :army
end
#------enlisting new minion---------
get "/minion/new" do
	erb :new_minion
end

post "/army" do
	erb :army
end
#---------editing a minion--------------

get "/minion/:id/edit" do
	@minion = Minion.get(params[:id])
	erb :edit_minion
end

put "/minion/:id" do

	@minion = Minion.get(params[:id].to_i)
	@minion.race = params[:race]
	@minion.title = params[:title]
	@minion.abilities = params[:abilities]
	@minion.save
	redirect to ("/army")
end

