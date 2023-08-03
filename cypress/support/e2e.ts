import '@testing-library/cypress/add-commands';
import './commands';

beforeEach(() => {
  cy.request('/cypress_rails_reset_state');
});
