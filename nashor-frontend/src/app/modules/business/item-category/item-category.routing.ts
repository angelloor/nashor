import { Route } from '@angular/router';
import { ItemCategoryDetailsComponent } from './details/details.component';
import { ItemCategoryComponent } from './item-category.component';
import { CanDeactivateItemCategoryDetails } from './item-category.guards';
import { ItemCategoryResolver } from './item-category.resolvers';
import { ItemCategoryListComponent } from './list/list.component';

export const itemCategoryRoutes: Route[] = [
  {
    path: '',
    component: ItemCategoryComponent,
    children: [
      {
        path: '',
        component: ItemCategoryListComponent,
        children: [
          {
            path: ':id_item_category',
            component: ItemCategoryDetailsComponent,
            resolve: {
              task: ItemCategoryResolver,
            },
            canDeactivate: [CanDeactivateItemCategoryDetails],
          },
        ],
      },
    ],
  },
];
