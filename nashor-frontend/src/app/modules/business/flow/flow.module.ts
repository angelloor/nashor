import { AngelAlertModule } from '@angel/components/alert';
import { AngelFindByKeyPipeModule } from '@angel/pipes/find-by-key';
import { DragDropModule } from '@angular/cdk/drag-drop';
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
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { RouterModule } from '@angular/router';
import { SharedModule } from 'app/shared/shared.module';
import * as moment from 'moment';
import { FlowDetailsComponent } from './details/details.component';
import { FlowComponent } from './flow.component';
import { flowRoutes } from './flow.routing';
import { FlowListComponent } from './list/list.component';
import { ModalEditFlowVersionLevelComponent } from './modal-edit-flow-version-level/modal-edit-flow-version-level.component';
import { ModalEditPositionLevelFatherComponent } from './modal-edit-position-level-father/modal-edit-position-level-father.component';
import { ModalFlowVersionComponent } from './modal-flow-version/modal-flow-version.component';
import { ModalSelectFlowComponent } from './modal-select-flow/modal-select-flow.component';
import { ModalVersionComponent } from './modal-version/modal-version.component';

@NgModule({
  declarations: [
    FlowListComponent,
    FlowDetailsComponent,
    FlowComponent,
    ModalFlowVersionComponent,
    ModalSelectFlowComponent,
    ModalEditFlowVersionLevelComponent,
    ModalEditPositionLevelFatherComponent,
    ModalVersionComponent,
  ],
  imports: [
    RouterModule.forChild(flowRoutes),
    MatButtonModule,
    MatCheckboxModule,
    MatDatepickerModule,
    MatDividerModule,
    DragDropModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatSlideToggleModule,
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
export class FlowModule {}
