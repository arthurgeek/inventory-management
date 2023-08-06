describe('accepting a delivery', () => {
  const url = 'accept_delivery';

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
      it('can access the accept delivery page via menu', () => {
        cy.visit('/');

        cy.findByRole('navigation').within(() => {
          cy.findByRole('link', { name: /accept deliveries/i }).click();
          cy.url().should('eq', `${Cypress.config('baseUrl')}${url}`);
        });
      });
    });

    context('when user is in the accept delivery page', () => {
      beforeEach(() => {
        cy.visit(`/${url}`);
      });

      it('allows to log out', () => {
        cy.logout(staffName);
      });

      it('list all available ingredients for all location', () => {
        cy.findByRole('heading', { level: 3, name: /paprika/i }).should('exist');
        cy.findByRole('heading', { level: 3, name: /shiitake mushrooms/i }).should('exist');
        cy.findByRole('heading', { level: 3, name: /camomile tea/i }).should('exist');
      });

      it('focuses the search input', () => {
        cy.findByPlaceholderText(/search/i).should('be.focused');
      });

      it('allows to search for specific ingredients', () => {
        cy.findByPlaceholderText(/search/i).type('m');

        cy.findByRole('heading', { level: 3, name: /shiitake mushrooms/i }).should('exist');
        cy.findByRole('heading', { level: 3, name: /camomile tea/i }).should('exist');
        cy.findByRole('heading', { level: 3, name: /paprika/i }).should('not.exist');

        cy.findByPlaceholderText(/search/i).type('u');

        cy.findByRole('heading', { level: 3, name: /shiitake mushrooms/i }).should('exist');
        cy.findByRole('heading', { level: 3, name: /camomile tea/i }).should('not.exist');
      });

      it('show all quantities as 0', () => {
        cy.findByRole('heading', { level: 3, name: /paprika/i })
          .next()
          .within(() => {
            cy.findByText('0 kilos').should('exist');
          });

        cy.findByRole('heading', { level: 3, name: /shiitake mushrooms/i })
          .next()
          .within(() => {
            cy.findByText('0 kilos').should('exist');
          });

        cy.findByRole('heading', { level: 3, name: /camomile tea/i })
          .next()
          .within(() => {
            cy.findByText('0 liters').should('exist');
          });
      });

      context('when user have not made any changes to item quantities', () => {
        it('cannot accept a delivery', () => {
          cy.findByRole('button', { name: /accept delivery/i }).should('be.disabled');
        });

        it('cannot select a negative quantity', () => {
          cy.findByRole('heading', { level: 3, name: /paprika/i })
            .next()
            .within(() => {
              cy.findByRole('button', { name: '-' }).should('be.disabled');
            });
        });
      });

      context('when user increases an ingredient quantity', () => {
        beforeEach(() => {
          cy.findByRole('heading', { level: 3, name: /paprika/i })
            .next()
            .within(() => {
              cy.findByRole('button', { name: '+' }).click();
            });
        });

        it('enables the accept delivery button', () => {
          cy.findByRole('button', { name: /accept delivery/i }).should('be.enabled');
        });

        it('enables to reduce the quantity', () => {
          cy.findByRole('heading', { level: 3, name: /paprika/i })
            .next()
            .within(() => {
              cy.findByRole('button', { name: '-' }).should('be.enabled');
            });
        });

        it('changes the displayed quantity for the ingredient accordingly', () => {
          cy.findByRole('heading', { level: 3, name: /paprika/i })
            .next()
            .within(() => {
              cy.findByText(/1 kilo/i).should('exist');
            });
        });

        it('enables to increase quantity even further', () => {
          cy.findByRole('heading', { level: 3, name: /paprika/i })
            .next()
            .within(() => {
              cy.findByRole('button', { name: '+' }).click();

              cy.findByText(/2 kilo/i).should('exist');

              cy.findByRole('button', { name: '+' }).click();

              cy.findByText(/3 kilo/i).should('exist');
            });
        });

        context('when user clicks the accept delivery button', () => {
          it('is redirected to inventory page', () => {
            cy.findByRole('button', { name: /accept delivery/i }).click();
            cy.url().should('eq', `${Cypress.config('baseUrl')}inventory`);
          });

          it('increases the number of ingredients available in the inventory for each changed item', () => {
            cy.findByRole('heading', { level: 3, name: /paprika/i })
              .next()
              .within(() => {
                cy.findByRole('button', { name: '+' }).click();
              });

            cy.findByRole('heading', { level: 3, name: /mushroom/i })
              .next()
              .within(() => {
                cy.findByRole('button', { name: '+' }).click();
              });

            cy.findByRole('button', { name: /accept delivery/i }).click();

            cy.findByRole('row', { name: /paprika/i }).within(() => {
              cy.findByText(/12.0 kilos/i).should('exist');
            });

            cy.findByRole('row', { name: /mushroom/i }).within(() => {
              cy.findByText(/4.0 kilos/i).should('exist');
            });
          });
        });
      });

      context('when user increases an ingredient quantity, but undo them', () => {
        beforeEach(() => {
          cy.findByRole('heading', { level: 3, name: /paprika/i })
            .next()
            .within(() => {
              cy.findByRole('button', { name: '+' }).click();

              cy.findByText(/1 kilo/i).should('exist');

              cy.findByRole('button', { name: '-' }).click();
            });
        });

        it('cannot accept a delivery', () => {
          cy.findByRole('button', { name: /accept delivery/i }).should('be.disabled');
        });

        it('cannot select a negative quantity', () => {
          cy.findByRole('heading', { level: 3, name: /paprika/i })
            .next()
            .within(() => {
              cy.findByRole('button', { name: '-' }).should('be.disabled');
            });
        });
      });
    });
  });
});
