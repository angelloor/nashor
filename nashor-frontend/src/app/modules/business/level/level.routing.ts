import { Route } from '@angular/router';
import { LevelDetailsComponent } from './details/details.component';
import { LevelComponent } from './level.component';
import { CanDeactivateLevelDetails } from './level.guards';
import { LevelResolver } from './level.resolvers';
import { LevelListComponent } from './list/list.component';

export const levelRoutes: Route[] = [
  {
    path: '',
    component: LevelComponent,
    children: [
      {
        path: '',
        component: LevelListComponent,
        children: [
          {
            path: ':id_level',
            component: LevelDetailsComponent,
            resolve: {
              task: LevelResolver,
            },
            canDeactivate: [CanDeactivateLevelDetails],
          },
        ],
      },
    ],
  },
];
