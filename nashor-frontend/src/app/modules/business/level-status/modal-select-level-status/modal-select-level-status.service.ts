import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalSelectLevelStatusComponent } from './modal-select-level-status.component';

@Injectable({
  providedIn: 'root',
})
export class ModalSelectLevelStatusService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalSelectLevelStatus() {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(
      ModalSelectLevelStatusComponent,
      {
        minHeight: 'inherit',
        maxHeight: 'inherit',
        height: 'auto',
        width: '32rem',
        maxWidth: '',
        panelClass: ['mat-dialog-cont'],
        data: {},
        disableClose: true,
      }
    ));
  }

  closeModalSelectLevelStatus() {
    this.dialogRef.close();
  }
}
