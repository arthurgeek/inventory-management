export function loadFixture(fixtureNames: string) {
  cy.exec(`rake db:fixtures:load FIXTURES_DIR=../../cypress/fixtures FIXTURES=${fixtureNames}`);
}

export function login(name: RegExp) {
  cy.session(
    name,
    () => {
      cy.visit('/login');
      cy.findByRole('heading', { name: name }).click();
      cy.findByText(welcomeText(name)).should('exist');
      cy.findByText(/signed in/i).should('exist');
    },
    {
      validate: () => {
        cy.getCookie('_inventory_management_session').should('exist');
      },
    }
  );
}

export function logout(name: RegExp) {
  cy.findByRole('button', { name: /sign out/i }).click();

  cy.findByText(/signed out/i).should('exist');
  cy.findByText(welcomeText(name)).should('not.exist');
}

export function ensureLoginIsRequired(url: string) {
  cy.visit(url);

  cy.url().should('eq', `${Cypress.config('baseUrl')}login`);
  cy.findByRole('heading', { name: /select your user/i }).should('exist');
}

function welcomeText(name: RegExp) {
  return new RegExp(`welcome ${name.source}`, 'i');
}

Cypress.Commands.add('login', login);
Cypress.Commands.add('logout', logout);
Cypress.Commands.add('ensureLoginIsRequired', ensureLoginIsRequired);
Cypress.Commands.add('loadFixture', loadFixture);
