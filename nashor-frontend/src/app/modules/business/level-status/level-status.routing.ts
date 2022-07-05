import { Route } from '@angular/router';
import { LevelStatusDetailsComponent } from './details/details.component';
import { LevelStatusComponent } from './level-status.component';
import { CanDeactivateLevelStatusDetails } from './level-status.guards';
import { LevelStatusResolver } from './level-status.resolvers';
import { LevelStatusListComponent } from './list/list.component';

export const levelStatusRoutes: Route[] = [
  {
    path: '',
    component: LevelStatusComponent,
    children: [
      {
        path: '',
        component: LevelStatusListComponent,
        children: [
          {
            path: ':id_level_status',
            component: LevelStatusDetailsComponent,
            resolve: {
              task: LevelStatusResolver,
            },
            canDeactivate: [CanDeactivateLevelStatusDetails],
          },
        ],
      },
    ],
  },
];
