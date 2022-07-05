import { Route } from '@angular/router';
import { AreaComponent } from './area.component';
import { CanDeactivateAreaDetails } from './area.guards';
import { AreaResolver } from './area.resolvers';
import { AreaDetailsComponent } from './details/details.component';
import { AreaListComponent } from './list/list.component';

export const areaRoutes: Route[] = [
  {
    path: '',
    component: AreaComponent,
    children: [
      {
        path: '',
        component: AreaListComponent,
        children: [
          {
            path: ':id_area',
            component: AreaDetailsComponent,
            resolve: {
              task: AreaResolver,
            },
            canDeactivate: [CanDeactivateAreaDetails],
          },
        ],
      },
    ],
  },
];
