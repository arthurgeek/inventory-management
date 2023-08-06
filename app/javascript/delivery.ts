import Alpine from 'alpinejs';

window.Alpine = Alpine;

Alpine.store('selectedIngredients', {});

Alpine.data('ingredients', (ingredients) => ({
  search: '',
  ingredients: ingredients,

  get filteredIngredients() {
    return this.ingredients.filter((i: { name: string }) => i.name.toLowerCase().includes(this.search.toLowerCase()));
  },

  quantityWithUnits(quantity: number, unit: string) {
    return `${quantity} ${unit}`;
  },

  async acceptDelivery() {
    const response = await fetch('/accept_delivery', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ['X-CSRF-TOKEN']: (document.querySelector('[name=csrf-token]') as HTMLMetaElement).content,
      },
      body: JSON.stringify(Object.values(Alpine.store('selectedIngredients'))),
    });

    if (response.status === 200) {
      location.href = '/inventory';
    }
  },
}));

Alpine.start();
