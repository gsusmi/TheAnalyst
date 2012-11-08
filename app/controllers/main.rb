Analyst.controller do
  layout :main
  get '/' do
    render :haml, "Hello"
  end
end
