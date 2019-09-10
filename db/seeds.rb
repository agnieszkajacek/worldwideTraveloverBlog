# create user
User.create(email: 'test@test.com', password: 'fakepassword')

# create continents - main categories (visible in navbar)
asia = Category.create(name: 'Azja')
europe = Category.create(name: 'Europa')

# create countries - categories (subcategories)
thailand = Category.create(name: 'Tajlandia', ancestry: (asia.id).to_s)
cambodia = Category.create(name: 'Kambodża', ancestry: (asia.id).to_s)
spain = Category.create(name: 'Hiszpania', ancestry: (europe.id).to_s)

# create posts

post_list = [
  [
    Time.zone.now,
    spain.id,
    'Teneryfa - atrakcje',
    'Będąc na Teneryfie miałam okazję zobaczyć chyba wszystkie najlepszych głównych atrakcji, które należą do "must see". Pierwszą z nich, którą gorąco polecam to Siam Park. Jest to największy tematyczny park wodny w całej Hiszpanii. Park znajduje się w Playas de Las Americas, zjazd bezpośrednio z autostrady TF1. Park jest podzielony na trzy części.',
    'Pierwszą z nich, którą gorąco polecam to Siam Park. Jest to największy tematyczny park wodny w całej Hiszpanii. Park znajduje się w Playas de Las Americas, zjazd bezpośrednio z autostrady TF1. Park jest podzielony na trzy części. Pierwsza to Relaks, kolejna - Adrenalina i ostatnia to Rodzina. Składa się z ponad 25 różnych budynków, posiada kilkanaście zjeżdżalni. Największa z nich, The Tower of Power, ma aż 28 metrów, czyli to jakieś ósme piętro! Zjeżdżalnia ta kończy się tunelem w basenie, ale zanim do niego wpadniecie z impetem, będziecie mogli pooglądać w akwarium rekiny. Dla odważnych i twardzieli jak znalazł, emocje obstawiam niesamowite. Podczas mojego pobytu zjeżdżalnia była zamknięta. Sama z niej w życiu bym nie skorzystała, tchórz ze mnie!'
  ],
  [
    Time.zone.now,
    spain.id,
    'Teneryfa - ciekawe miejscowości',
    'Oprócz atrakcji dostępnych na Teneryfie, które są "must see", polecam Wam również klika miejsc naprawdę wartych zobaczenia. Podczas naszej tygodniowej podróży objechaliśmy całą wyspę dookoła, wzdłuż i wszerz. Wynajęliśmy samochód i ruszyliśmy na zwiedzanie. Nie mieliśmy konkretnego planu poruszania się.',
    'Naszym celem na Puerto de La Cruz była plaża - Playa Jardin. Plaża zdecydowanie ładna i chyba najczęściej odwiedzana, z racji charakterystycznego ciemnego wulkanicznego piasku.'
  ],
  [
    Time.zone.now,
    thailand.id,
    'Bangkok - czym się tu poruszać?',
    'Bangkok - szerokie ulice zapchane samochodami, skuterami, tuk-tukami i autobusami. Tym razem będzie o tym, z czego warto skorzystać i dlaczego powinniście mieć się na baczności i jak nie dać się oszukać naciągaczom.',
    'Tuk-tuki: Można by powiedzieć, że w Bangkoku są one największą udręką dla turystów. Na każdym kroku kierowcy zaczepiają przechodniów, którzy nie wyglądają jak Azjaci i każdy z osobna będzie Wam oferować swoje usługi transportowe.'
  ]
]

post_list.each do |published, category_id, title, introduction, content|
  Post.create!(published: published, category_id: category_id, title: title, introduction: introduction, content: content)
end
