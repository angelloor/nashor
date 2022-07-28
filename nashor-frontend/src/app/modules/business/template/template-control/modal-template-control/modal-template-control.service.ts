import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalTemplateControlComponent } from './modal-template-control.component';

@Injectable({
  providedIn: 'root',
})
export class ModalTemplateControlService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}

  dialogRef: any;

  openModalTemplateControl(id_template_control: string) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalTemplateControlComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '35rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: { id_template_control },
      disableClose: true,
    }));
  }

  closeModalTemplateControl() {
    this.dialogRef.close();
  }
}
