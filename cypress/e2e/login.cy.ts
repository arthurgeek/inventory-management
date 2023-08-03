describe('login flow', () => {
  it('redirects to login when not logged in', () => {
    cy.visit('/');

    cy.findByRole('heading', { name: /select your user/i }).should('exist');
  });

  it('only shows staff from the configured location', () => {
    cy.visit('/login');

    cy.findByRole('heading', { name: /mary/i }).should('exist');
    cy.findByRole('heading', { name: /richard/i }).should('not.exist');
  });

  it('logs staff in', () => {
    cy.visit('/login');

    cy.findByRole('heading', { name: /john/i }).click();

    cy.findByText(/signed in/i).should('exist');
    cy.findByText(/welcome john/i).should('exist');

    cy.visit('/');

    cy.findByText(/welcome john doe/i).should('exist');
  });

  it('logs staff out', () => {
    cy.visit('/login');

    cy.findByRole('heading', { name: /john/i }).click();

    cy.findByRole('button', { name: /sign out/i }).click();

    cy.findByText(/signed out/i).should('exist');
    cy.findByText(/welcome john doe/i).should('not.exist');
  });
});
