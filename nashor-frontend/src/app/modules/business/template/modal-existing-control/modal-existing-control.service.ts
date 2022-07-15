import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalExistingControlComponent } from './modal-existing-control.component';

@Injectable({
  providedIn: 'root',
})
export class ModalExistingControlService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}

  dialogRef: any;

  openExistingControl(id_user: string, id_template: string) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalExistingControlComponent, {
      minHeight: 'inherit',
      maxHeight: 'inherit',
      height: 'auto',
      width: '32rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: {
        id_user,
        id_template,
      },
      disableClose: true,
    }));
  }

  closeExistingControl() {
    this.dialogRef.close();
  }
}
