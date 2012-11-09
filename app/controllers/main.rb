Analyst.controller do
  layout :main
  get '/' do
    render("main/index", locals: { items: Item.all })
  end
end
