import { Route } from '@angular/router';
// import { ContainerModalTaskComponent } from './container-modal-task/container-modal-task.component';
import { TaskListComponent } from './list/list.component';
import { TaskComponent } from './task.component';

export const taskRoutes: Route[] = [
  {
    path: '',
    component: TaskComponent,
    children: [
      {
        path: '',
        component: TaskListComponent,
      },
    ],
  },
];
