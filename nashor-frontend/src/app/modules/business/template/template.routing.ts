import { Route } from '@angular/router';
import { TemplateResolver } from './template.resolvers';
import { TemplatesComponent } from './templates/templates.component';

export const templateRoutes: Route[] = [
  {
    path: '',
    component: TemplatesComponent,
  },
  {
    path: ':id_template',
    resolve: {
      board: TemplateResolver,
    },
  },
];
