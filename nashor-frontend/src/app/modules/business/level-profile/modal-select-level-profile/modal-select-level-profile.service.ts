import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalSelectLevelProfileComponent } from './modal-select-level-profile.component';

@Injectable({
  providedIn: 'root',
})
export class ModalSelectLevelProfileService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalSelectLevelProfile() {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(
      ModalSelectLevelProfileComponent,
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

  closeModalSelectLevelProfile() {
    this.dialogRef.close();
  }
}
