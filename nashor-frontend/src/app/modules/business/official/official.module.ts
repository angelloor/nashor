import { AngelAlertModule } from '@angel/components/alert';
import { AngelFindByKeyPipeModule } from '@angel/pipes/find-by-key';
import { NgModule } from '@angular/core';
import { MatMomentDateModule } from '@angular/material-moment-adapter';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatRippleModule, MAT_DATE_FORMATS } from '@angular/material/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatDialogModule } from '@angular/material/dialog';
import { MatDividerModule } from '@angular/material/divider';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatMenuModule } from '@angular/material/menu';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatRadioModule } from '@angular/material/radio';
import { MatSelectModule } from '@angular/material/select';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { RouterModule } from '@angular/router';
import { SharedModule } from 'app/shared/shared.module';
import * as moment from 'moment';
import { OfficialDetailsComponent } from './details/details.component';
import { OfficialListComponent } from './list/list.component';
import { ModalSelectOfficialComponent } from './modal-select-official/modal-select-official.component';
import { OfficialComponent } from './official.component';
import { officialRoutes } from './official.routing';
import { ModalSelectOfficialByLevelProfileComponent } from './modal-select-official-by-level-profile/modal-select-official-by-level-profile.component';

@NgModule({
  declarations: [
    OfficialListComponent,
    OfficialDetailsComponent,
    OfficialComponent,
    ModalSelectOfficialComponent,
    ModalSelectOfficialByLevelProfileComponent,
  ],
  imports: [
    RouterModule.forChild(officialRoutes),
    MatButtonModule,
    MatCheckboxModule,
    MatDatepickerModule,
    MatDividerModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatMenuModule,
    MatMomentDateModule,
    MatDialogModule,
    MatProgressBarModule,
    MatRadioModule,
    MatRippleModule,
    MatSelectModule,
    MatSidenavModule,
    MatTableModule,
    MatTooltipModule,
    AngelFindByKeyPipeModule,
    AngelAlertModule,
    SharedModule,
  ],
  providers: [
    {
      provide: MAT_DATE_FORMATS,
      useValue: {
        parse: {
          dateInput: moment.ISO_8601,
        },
        display: {
          dateInput: 'LL',
          monthYearLabel: 'MMM YYYY',
          dateA11yLabel: 'LL',
          monthYearA11yLabel: 'MMMM YYYY',
        },
      },
    },
  ],
})
export class OfficialModule {}
