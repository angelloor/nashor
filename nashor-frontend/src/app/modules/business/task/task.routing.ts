import { Route } from '@angular/router';
import { ContainerModalTaskComponent } from './container-modal-task/container-modal-task.component';
import { TaskListComponent } from './list/list.component';
import { TaskComponent } from './task.component';
import { CanDeactivateTaskDetails } from './task.guards';
import { TaskResolver } from './task.resolvers';

export const taskRoutes: Route[] = [
  {
    path: '',
    component: TaskComponent,
    children: [
      {
        path: '',
        component: TaskListComponent,
        children: [
          {
            path: ':id_task',
            component: ContainerModalTaskComponent,
            resolve: {
              task: TaskResolver,
            },
            canDeactivate: [CanDeactivateTaskDetails],
          },
        ],
      },
    ],
  },
];
