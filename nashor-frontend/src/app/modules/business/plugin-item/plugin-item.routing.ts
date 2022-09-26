import { Route } from '@angular/router';
import { PluginItemDetailsComponent } from './details/details.component';
import { PluginItemListComponent } from './list/list.component';
import { PluginItemComponent } from './plugin-item.component';
import { CanDeactivatePluginItemDetails } from './plugin-item.guards';
import { PluginItemResolver } from './plugin-item.resolvers';

export const pluginItemRoutes: Route[] = [
  {
    path: '',
    component: PluginItemComponent,
    children: [
      {
        path: '',
        component: PluginItemListComponent,
        children: [
          {
            path: ':id_plugin_item',
            component: PluginItemDetailsComponent,
            resolve: {
              task: PluginItemResolver,
            },
            canDeactivate: [CanDeactivatePluginItemDetails],
          },
        ],
      },
    ],
  },
];
