import { Route } from '@angular/router';
import { ItemDetailsComponent } from './details/details.component';
import { ItemComponent } from './item.component';
import { CanDeactivateItemDetails } from './item.guards';
import { ItemResolver } from './item.resolvers';
import { ItemListComponent } from './list/list.component';

export const itemRoutes: Route[] = [
  {
    path: '',
    component: ItemComponent,
    children: [
      {
        path: '',
        component: ItemListComponent,
        children: [
          {
            path: ':id_item',
            component: ItemDetailsComponent,
            resolve: {
              task: ItemResolver,
            },
            canDeactivate: [CanDeactivateItemDetails],
          },
        ],
      },
    ],
  },
];
