import { loadFixture } from 'support/commands';

declare global {
  namespace Cypress {
    interface Chainable {
      loadFixture: typeof loadFixture;
    }
  }
}
