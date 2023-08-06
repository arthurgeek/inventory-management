describe('dashboard page', () => {
  context('when user is not logged in', () => {
    it('will not be able to access the page', () => {
      cy.ensureLoginIsRequired('/');
    });
  });

  context('when user is logged in', () => {
    it('allows staff to log out', () => {
      const staff = /john/i;
      cy.login(staff);

      cy.visit('/');
      cy.logout(staff);
    });
  });
});
