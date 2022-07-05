import { Route } from '@angular/router';
import { PositionDetailsComponent } from './details/details.component';
import { PositionListComponent } from './list/list.component';
import { PositionComponent } from './position.component';
import { CanDeactivatePositionDetails } from './position.guards';
import { PositionResolver } from './position.resolvers';

export const positionRoutes: Route[] = [
  {
    path: '',
    component: PositionComponent,
    children: [
      {
        path: '',
        component: PositionListComponent,
        children: [
          {
            path: ':id_position',
            component: PositionDetailsComponent,
            resolve: {
              task: PositionResolver,
            },
            canDeactivate: [CanDeactivatePositionDetails],
          },
        ],
      },
    ],
  },
];
