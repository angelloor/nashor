import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { Route, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { NotfoundComponent } from './not-found/not-found.component';

const publicRoutes: Route[] = [
  {
    path: '',
    pathMatch: 'full',
    redirectTo: 'home',
  },
  {
    path: 'home',
    component: HomeComponent,
  },
  {
    path: 'landing',
    loadChildren: () =>
      import('./landing/landing.module').then((m) => m.LandingModule),
  },
  {
    path: 'not-found',
    component: NotfoundComponent,
  },
];

@NgModule({
  declarations: [HomeComponent, NotfoundComponent],
  imports: [
    RouterModule.forChild(publicRoutes),
    FormsModule,
    CommonModule,
    MatButtonModule,
    MatInputModule,
    ReactiveFormsModule,
  ],
})
export class PublicModule {}
