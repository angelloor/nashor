import { Route } from '@angular/router';
import { LevelProfileDetailsComponent } from './details/details.component';
import { LevelProfileComponent } from './level-profile.component';
import { CanDeactivateLevelProfileDetails } from './level-profile.guards';
import { LevelProfileResolver } from './level-profile.resolvers';
import { LevelProfileListComponent } from './list/list.component';

export const levelProfileRoutes: Route[] = [
  {
    path: '',
    component: LevelProfileComponent,
    children: [
      {
        path: '',
        component: LevelProfileListComponent,
        children: [
          {
            path: ':id_level_profile',
            component: LevelProfileDetailsComponent,
            resolve: {
              task: LevelProfileResolver,
            },
            canDeactivate: [CanDeactivateLevelProfileDetails],
          },
        ],
      },
    ],
  },
];
