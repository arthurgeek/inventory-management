import { loadFixture, login, logout, ensureLoginIsRequired } from 'support/commands';

declare global {
  namespace Cypress {
    interface Chainable {
      loadFixture: typeof loadFixture;
      login: typeof login;
      logout: typeof logout;
      ensureLoginIsRequired: typeof ensureLoginIsRequired;
    }
  }
}
