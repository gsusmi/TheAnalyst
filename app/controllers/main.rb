Analyst.controller do
  layout :main
  get '/' do
    items = Item.all(order: [:rating_score.desc, :abv.asc, :name.asc])
    render("main/index", locals: { items: items })
  end
end
