values = []

get "/" do
  200
end

delete "/" do
  values.clear
  200
end

post "/remember" do
  values << params[:value]
end

get "/remembered" do
  { :remembered => values }.to_json
end
