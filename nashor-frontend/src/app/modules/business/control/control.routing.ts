import { Route } from '@angular/router';
import { ControlComponent } from './control.component';
import { CanDeactivateControlDetails } from './control.guards';
import { ControlResolver } from './control.resolvers';
import { ControlDetailsComponent } from './details/details.component';
import { ControlListComponent } from './list/list.component';

export const controlRoutes: Route[] = [
  {
    path: '',
    component: ControlComponent,
    children: [
      {
        path: '',
        component: ControlListComponent,
        children: [
          {
            path: ':id_control',
            component: ControlDetailsComponent,
            resolve: {
              task: ControlResolver,
            },
            canDeactivate: [CanDeactivateControlDetails],
          },
        ],
      },
    ],
  },
];
