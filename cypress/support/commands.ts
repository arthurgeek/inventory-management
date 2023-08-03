export function loadFixture(fixtureNames: string) {
  cy.exec(`rake db:fixtures:load FIXTURES_DIR=../../cypress/fixtures FIXTURES=${fixtureNames}`);
}

Cypress.Commands.add('loadFixture', loadFixture);
