import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatTooltipModule } from '@angular/material/tooltip';
import { Route, RouterModule } from '@angular/router';
import { AuthGuard } from 'app/core/auth/guards/auth.guard';
import { HomeComponent } from './home/home.component';

const businessRoutes: Route[] = [
  {
    path: '',
    pathMatch: 'full',
    redirectTo: 'home',
  },
  {
    path: 'home',
    canActivate: [AuthGuard],
    component: HomeComponent,
  },
  {
    path: 'area',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () => import('./area/area.module').then((m) => m.AreaModule),
  },
  {
    path: 'position',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./position/position.module').then((m) => m.PositionModule),
  },
  {
    path: 'official',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./official/official.module').then((m) => m.OfficialModule),
  },
  {
    path: 'attached',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./attached/attached.module').then((m) => m.AttachedModule),
  },
  {
    path: 'documentation-profile',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./documentation-profile/documentation-profile.module').then(
        (m) => m.DocumentationProfileModule
      ),
  },
  {
    path: 'item-category',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./item-category/item-category.module').then(
        (m) => m.ItemCategoryModule
      ),
  },
  {
    path: 'item',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () => import('./item/item.module').then((m) => m.ItemModule),
  },
  {
    path: 'control',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./control/control.module').then((m) => m.ControlModule),
  },
  {
    path: 'template',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./template/template.module').then((m) => m.TemplateModule),
  },
  {
    path: 'process-type',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./process-type/process-type.module').then(
        (m) => m.ProcessTypeModule
      ),
  },
  {
    path: 'level-status',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./level-status/level-status.module').then(
        (m) => m.LevelStatusModule
      ),
  },
  {
    path: 'level-profile',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./level-profile/level-profile.module').then(
        (m) => m.LevelProfileModule
      ),
  },
  {
    path: 'level',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./level/level.module').then((m) => m.LevelModule),
  },
  {
    path: 'flow',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () => import('./flow/flow.module').then((m) => m.FlowModule),
  },
  {
    path: 'process',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () =>
      import('./process/process.module').then((m) => m.ProcessModule),
  },
  {
    path: 'task',
    canActivate: [AuthGuard],
    canActivateChild: [AuthGuard],
    loadChildren: () => import('./task/task.module').then((m) => m.TaskModule),
  },
];

@NgModule({
  declarations: [HomeComponent],
  imports: [
    RouterModule.forChild(businessRoutes),
    FormsModule,
    CommonModule,
    MatButtonModule,
    MatTooltipModule,
    MatIconModule,
    MatSelectModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    ReactiveFormsModule,
  ],
})
export class BusinessModule {}
