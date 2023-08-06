describe('login', () => {
  context('the login page', () => {
    it('only shows staff from the configured location', () => {
      cy.visit('/login');

      cy.findByRole('heading', { name: /mary/i }).should('exist');
      cy.findByRole('heading', { name: /richard/i }).should('not.exist');
    });

    it('allows staff to log in', () => {
      cy.login(/john/i);
    });
  });
});
