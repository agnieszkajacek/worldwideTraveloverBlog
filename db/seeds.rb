#continents
asia = Category.create(name: 'Asia')
europe = Category.create(name: 'Europe')

#countries
thailand = Category.create(name: 'Thailand', parent: asia)
cambodia = Category.create(name: 'Cambodia', parent: asia)
spain = Category.create(name: 'Spain', parent: europe)
