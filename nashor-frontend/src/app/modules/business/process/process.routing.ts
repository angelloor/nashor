import { Route } from '@angular/router';
import { ContainerModalProcessComponent } from './container-modal-process/container-modal-process.component';
import { ProcessListComponent } from './list/list.component';
import { ProcessComponent } from './process.component';
import { CanDeactivateProcessDetails } from './process.guards';
import { ProcessResolver } from './process.resolvers';

export const processRoutes: Route[] = [
  {
    path: '',
    component: ProcessComponent,
    children: [
      {
        path: '',
        component: ProcessListComponent,
        children: [
          {
            path: ':id_process',
            component: ContainerModalProcessComponent,
            resolve: {
              task: ProcessResolver,
            },
            canDeactivate: [CanDeactivateProcessDetails],
          },
        ],
      },
    ],
  },
];
