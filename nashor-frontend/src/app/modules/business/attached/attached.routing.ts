import { Route } from '@angular/router';
import { AttachedComponent } from './attached.component';
import { CanDeactivateAttachedDetails } from './attached.guards';
import { AttachedResolver } from './attached.resolvers';
import { AttachedDetailsComponent } from './details/details.component';
import { AttachedListComponent } from './list/list.component';

export const attachedRoutes: Route[] = [
  {
    path: '',
    component: AttachedComponent,
    children: [
      {
        path: '',
        component: AttachedListComponent,
        children: [
          {
            path: ':id_attached',
            component: AttachedDetailsComponent,
            resolve: {
              task: AttachedResolver,
            },
            canDeactivate: [CanDeactivateAttachedDetails],
          },
        ],
      },
    ],
  },
];
