import { Route } from '@angular/router';
import { DocumentationProfileDetailsComponent } from './details/details.component';
import { DocumentationProfileComponent } from './documentation-profile.component';
import { CanDeactivateDocumentationProfileDetails } from './documentation-profile.guards';
import { DocumentationProfileResolver } from './documentation-profile.resolvers';
import { DocumentationProfileListComponent } from './list/list.component';

export const documentationProfileRoutes: Route[] = [
  {
    path: '',
    component: DocumentationProfileComponent,
    children: [
      {
        path: '',
        component: DocumentationProfileListComponent,
        children: [
          {
            path: ':id_documentation_profile',
            component: DocumentationProfileDetailsComponent,
            resolve: {
              task: DocumentationProfileResolver,
            },
            canDeactivate: [CanDeactivateDocumentationProfileDetails],
          },
        ],
      },
    ],
  },
];
