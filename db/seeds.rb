#continents
asia = Category.create(name: 'Asia')
europe = Category.create(name: 'Europe')

#countries
thailand = Category.create(name: 'Thailand', parent: asia)
cambodia = Category.create(name: 'Cambodia', parent: asia)
spain = Category.create(name: 'Spain', parent: europe)

#cities
Subcategory.create(name: 'Bangkok', category: thailand)
Subcategory.create(name: 'Chiang Mai', category: thailand)
Subcategory.create(name: 'Angkor Wat', category: cambodia)
Subcategory.create(name: 'Tenerife', category: spain)
