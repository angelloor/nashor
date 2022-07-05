import { Route } from '@angular/router';
import { ProcessTypeDetailsComponent } from './details/details.component';
import { ProcessTypeListComponent } from './list/list.component';
import { ProcessTypeComponent } from './process-type.component';
import { CanDeactivateProcessTypeDetails } from './process-type.guards';
import { ProcessTypeResolver } from './process-type.resolvers';

export const processTypeRoutes: Route[] = [
  {
    path: '',
    component: ProcessTypeComponent,
    children: [
      {
        path: '',
        component: ProcessTypeListComponent,
        children: [
          {
            path: ':id_process_type',
            component: ProcessTypeDetailsComponent,
            resolve: {
              task: ProcessTypeResolver,
            },
            canDeactivate: [CanDeactivateProcessTypeDetails],
          },
        ],
      },
    ],
  },
];
