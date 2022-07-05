import { Route } from '@angular/router';
import { FlowDetailsComponent } from './details/details.component';
import { FlowComponent } from './flow.component';
import { CanDeactivateFlowDetails } from './flow.guards';
import { FlowResolver } from './flow.resolvers';
import { FlowListComponent } from './list/list.component';

export const flowRoutes: Route[] = [
  {
    path: '',
    component: FlowComponent,
    children: [
      {
        path: '',
        component: FlowListComponent,
        children: [
          {
            path: ':id_flow',
            component: FlowDetailsComponent,
            resolve: {
              task: FlowResolver,
            },
            canDeactivate: [CanDeactivateFlowDetails],
          },
        ],
      },
    ],
  },
];
