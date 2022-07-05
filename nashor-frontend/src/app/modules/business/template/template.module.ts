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
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { RouterModule } from '@angular/router';
import { SharedModule } from 'app/shared/shared.module';
import * as moment from 'moment';
import { MaterialFileInputModule } from 'ngx-material-file-input';
import { TemplateDetailsComponent } from './details/details.component';
import { ModalExistingControlComponent } from './modal-existing-control/modal-existing-control.component';
import { ModalSelectTemplateComponent } from './modal-select-template/modal-select-template.component';
import { ModalTemplateComponent } from './modal-template/modal-template.component';
import { ModalTemplateControlDetailsComponent } from './template-control/modal-template-control/modal-template-control-details/modal-template-control-details.component';
import { ModalTemplateControlComponent } from './template-control/modal-template-control/modal-template-control.component';
import { TemplateComponent } from './template.component';
import { templateRoutes } from './template.routing';
import { TemplatesComponent } from './templates/templates.component';

@NgModule({
  declarations: [
    TemplateDetailsComponent,
    TemplateComponent,
    ModalSelectTemplateComponent,
    TemplatesComponent,
    ModalTemplateComponent,
    ModalExistingControlComponent,
    ModalTemplateControlComponent,
    ModalTemplateControlDetailsComponent,
  ],
  imports: [
    RouterModule.forChild(templateRoutes),
    MatButtonModule,
    MatCheckboxModule,
    MatDatepickerModule,
    MaterialFileInputModule,
    MatDividerModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatMenuModule,
    MatMomentDateModule,
    MatDialogModule,
    DragDropModule,
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
export class TemplateModule {}
