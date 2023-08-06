describe('inventory page', () => {
  const url = 'inventory';

  context('when user is not logged in', () => {
    it('will not be able to access the page', () => {
      cy.ensureLoginIsRequired(`/${url}`);
    });
  });

  context('when user is logged in', () => {
    const staffName = /john/i;

    beforeEach(() => {
      cy.login(staffName);
    });

    context('when user is in the dashboard page', () => {
      it('can access the inventory page via menu', () => {
        cy.visit('/');

        cy.findByRole('navigation').within(() => {
          cy.findByRole('link', { name: /inventory/i }).click();
          cy.url().should('eq', `${Cypress.config('baseUrl')}${url}`);
        });
      });
    });

    context('when user is in the inventory page', () => {
      beforeEach(() => {
        cy.visit(`/${url}`);
      });

      it('allows to log out', () => {
        cy.logout(staffName);
      });

      it('list all available ingredients for current location', () => {
        cy.findByRole('row', { name: /paprika/i }).should('exist');
        cy.findByRole('row', { name: /shiitake mushrooms/i }).should('exist');
      });

      it('will not list ingredients from other locations', () => {
        cy.findByRole('row', { name: /camomile tea/i }).should('not.exist');
      });
    });
  });
});
