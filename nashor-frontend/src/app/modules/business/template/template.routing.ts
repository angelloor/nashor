import { Route } from '@angular/router';
import { TemplateDetailsComponent } from './details/details.component';
import { ModalTemplateControlComponent } from './template-control/modal-template-control/modal-template-control.component';
import { TemplateControlResolver } from './template-control/template-control.resolvers';
import { CanDeactivateTemplateDetails } from './template.guards';
import { TemplateResolver } from './template.resolvers';
import { TemplatesComponent } from './templates/templates.component';

export const templateRoutes: Route[] = [
  {
    path: '',
    component: TemplatesComponent,
  },
  {
    path: ':id_template',
    component: TemplateDetailsComponent,
    resolve: {
      board: TemplateResolver,
    },
    children: [
      {
        path: 'template-control/:id_template_control',
        component: ModalTemplateControlComponent,
        resolve: {
          control: TemplateControlResolver,
        },
        canDeactivate: [CanDeactivateTemplateDetails],
      },
    ],
  },
];
