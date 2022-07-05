import { Route } from '@angular/router';
import { OfficialDetailsComponent } from './details/details.component';
import { OfficialListComponent } from './list/list.component';
import { OfficialComponent } from './official.component';
import { CanDeactivateOfficialDetails } from './official.guards';
import { OfficialResolver } from './official.resolvers';

export const officialRoutes: Route[] = [
  {
    path: '',
    component: OfficialComponent,
    children: [
      {
        path: '',
        component: OfficialListComponent,
        children: [
          {
            path: ':id_official',
            component: OfficialDetailsComponent,
            resolve: {
              task: OfficialResolver,
            },
            canDeactivate: [CanDeactivateOfficialDetails],
          },
        ],
      },
    ],
  },
];
